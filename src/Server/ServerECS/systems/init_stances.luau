
-- Libraries
local jecs = require("@luau_packages/jecs")
local pair = jecs.pair
local __ = jecs.Wildcard

local types = require("@ecs/types")
local ct = require("@ecs/components")

local Stances = require("@ServerECS/Stances")

-- Init
return function(world: types.World)
    local new = {}
    local old = {}

    world:added(ct.Stance, function(entity, _, value)
        table.insert(new, {id = entity, stance = value})
    end)

    world:changed(ct.Stance, function()
        error("Stance name should not change? Unexpected behavior")
    end)

    world:removed(ct.Stance, function(entity, _id)
        table.insert(old, entity)
    end)

    -- System
    return function()
        for _, data in new do
            local stanceId = data.id
            local stance = data.stance

            Stances[stance](world, stanceId)
        end

        table.clear(new)

        for _, stanceId in old do
            for child in world:query(pair(ct.AbilityOf, stanceId)) do
                world:delete(child)
            end
        end

        table.clear(old)
    end
end
