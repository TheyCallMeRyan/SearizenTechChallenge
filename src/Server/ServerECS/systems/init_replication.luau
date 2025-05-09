
-- Libraries
local jecs = require("@luau_packages/jecs")
local pair = jecs.pair
local __ = jecs.Wildcard

local types = require("@ecs/types")
local ct = require("@ecs/components")
local remotes = require("@ecs/remotes")
local collect = require("@ecs/collect")

local getPrettyPrint = require("@Common/getPrettyPrint")

local function getSnapshot(world: types.World) : remotes.Snapshot
    local storages = {}

    for component in world:query(ct.Networked) do
        local is_tag = jecs.is_tag(world, component)
        local storage = {} :: { [types.Entity]: any }
        storages[component] = storage

        if is_tag then
            for entity in world:query(component) do
                storage[entity] = true
            end
        else
            for entity, value in world:query(component) do
                storage[entity] = value
            end
        end
    end

    for relation in world:query(ct.NetworkedPair) do
        for entity, value in world:query(pair(relation, __)) do
            local id = pair(relation, world:target(entity, relation) :: jecs.Id<any>)
            local is_tag = jecs.is_tag(world, id :: jecs.Id<any>)
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
        end
    end
    
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

    return snapshot
end

-- Init
local snapshotRequests = collect(remotes.request_snapshot.OnServerEvent)
return function(world: types.World)
    local snapshot: remotes.Snapshot
    for player in snapshotRequests do
        -- So if multiple players request at once, it doesn't have to getSnapshot() each time
        snapshot = snapshot or getSnapshot(world)
        if workspace:GetAttribute("DebugNetworking") then
            print(getPrettyPrint(snapshot))
        end

        remotes.init:FireClient(player, snapshot)
    end
end
