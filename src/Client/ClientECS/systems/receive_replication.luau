-- Libraries
local jecs = require("@luau_packages/jecs")
local pair = jecs.pair

local types = require("@ecs/types")
local remotes = require("@ecs/remotes")
local collect = require("@ecs/collect")

local getPrettyPrint = require("@Common/getPrettyPrint")

-- Helpers
local client_ids = {}

-- Original
-- local function ecs_map_get(world: any, id: types.Entity)
-- 	local deserialised_id = 0

-- 	if not world:exists(id) or not world:contains(id) then
-- 		deserialised_id = world:entity(id)
-- 		client_ids[id] = deserialised_id
-- 	else
-- 		deserialised_id = client_ids[id]
-- 	end

-- 	return deserialised_id
-- end

local function ecs_map_get(world: any, id: types.Entity) : jecs.Id<any>
	local deserialised_id = 0 :: any

	if not client_ids[id] then
		deserialised_id = world:entity()
		client_ids[id] = deserialised_id
	else
		deserialised_id = client_ids[id]
	end

	return deserialised_id
end

local function ecs_make_alive_id(world: types.World, id: jecs.Id) : (jecs.Id<any>, jecs.Id<any>)
	local relation = jecs.ECS_PAIR_FIRST(id)
	local target = jecs.ECS_PAIR_SECOND(id)

	local mappedTarget = ecs_map_get(world, target)

	return relation, mappedTarget
end

local function processSnapshot(world: types.World, snapshot)
	if workspace:GetAttribute("DebugNetworking") then
		print("Processing:")
		print(getPrettyPrint(snapshot))
	end
	
	for key, map: any in snapshot do
		local id = (tonumber(key) :: any) :: jecs.Id
		if jecs.IS_PAIR(id) then
			local relation, target = ecs_make_alive_id(world, id)
			id = pair(relation, target)
		end

		local set = map.set
		if set then
			if jecs.is_tag(world, id) then
				for _, entity in set do
					entity = ecs_map_get(world, entity)
					world:add(entity, id)
				end
			else
				local values = map.values :: { any }
				for i, entity in set do
					entity = ecs_map_get(world, entity)
					world:set(entity, id, values[i])
				end
			end
		end

		local removed = map.removed
		if removed then
			for _i, e in removed do
				if not world:contains(e) then
					continue
				end
				world:remove(e, id)
			end
		end
	end
end

-- Init
local snapshots = collect(remotes.replication.OnClientEvent)
return function(world: types.World)
	local accepting_packets = false
	task.spawn(function()
		(remotes.init.OnClientEvent :: RBXScriptSignal):Once(function(snapshot)
			processSnapshot(world, snapshot)
			accepting_packets = true
		end)
		
		remotes.request_snapshot:FireServer()
	end)

    -- System
    return function()
        for snapshot in snapshots do
			if not accepting_packets then
				continue
			end

			processSnapshot(world, snapshot)
        end
    end
end
