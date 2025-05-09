
-- Libraries
local jecs = require("@luau_packages/jecs")

local types = require("@ecs/types")
local ct = require("@ecs/components")
local remotes = require("@ecs/remotes")

local getPrettyPrint = require("@Common/getPrettyPrint")

-- Init
return function(world: types.World)
    local storages = {}

    for component in world:query(ct.Networked) do
        local is_tag = jecs.is_tag(world, component)
        local storage = {} :: { [types.Entity]: any }
        storages[component] = storage

        if is_tag then
            world:added(component, function(entity)
                storage[entity] = true
            end)
        else
            world:added(component, function(entity, _, value)
                storage[entity] = value
            end)
            world:changed(component, function(entity, _, value)
            	storage[entity] = value
            end)
        end

        world:removed(component, function(entity)
            storage[entity] = "jecs.Remove"
        end)
    end
    
    for relation in world:query(ct.NetworkedPair) do
        world:added(relation, function(entity, id, value)
            local is_tag = jecs.is_tag(world, id)
            local storage = storages[id]
            if not storage then
                storage = {}
                storages[id] = storage
            end
            if is_tag then
                storage[entity] = true
            else
                storage[entity] = value
            end
        end)

        world:changed(relation, function(entity, id, value)
            local is_tag = jecs.is_tag(world, id)
            if is_tag then
                return
            end

            local storage = storages[id]
            if not storage then
                storage = {}
                storages[id] = storage
            end

            storage[entity] = value
        end :: <T>(types.Entity, types.Id<T>, T) -> ())

        world:removed(relation, function(entity, id)
            local storage = storages[id]
            if not storage then
                storage = {}
                storages[id] = storage
            end

            storage[entity] = "jecs.Remove"
        end)
    end

    -- System
    return function()
        local snapshot = {} :: remotes.Snapshot

        local set_ids = {} :: { types.Entity }
        local removed_ids = {} :: { types.Entity }

        for component, storage in storages do
            local set_values = {}
            local set_n = 0
            local removed_n = 0
            for e, v in storage do
                if v ~= "jecs.Remove" then
                    set_n += 1
                    set_ids[set_n] = e
                    set_values[set_n] = v or true
                elseif world:contains(e) then
                    removed_n += 1
                    removed_ids[removed_n] = e
                end
            end

            table.clear(storage)

            local dirty = false

            if set_n > 0 or removed_n > 0 then
            	dirty = true
            end

            if dirty then
	            snapshot[tostring(component)] = {
                    set = if set_n > 0 then table.move(set_ids, 1, set_n, 1, {}) else nil,
                    values = if set_n > 0 then set_values else nil,
                    removed = if removed_n > 0 then table.move(removed_ids, 1, removed_n, 1, {} :: { types.Entity }) else nil
                } :: any
	        end
        end

        if next(snapshot) ~= nil then
            if workspace:GetAttribute("DebugNetworking") then
                print(getPrettyPrint(snapshot))
            end
        	remotes.replication:FireAllClients(snapshot)
        end
    end
end
