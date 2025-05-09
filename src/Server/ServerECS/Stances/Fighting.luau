
-- Libraries
local jecs = require("@luau_packages/jecs")
local pair = jecs.pair

local types = require("@ecs/types")
local ct = require("@ecs/components")

-- Stance Init
return function(world: types.World, stanceId: types.Entity)
    local punch = world:entity()
    world:set(punch, ct.Ability, "Punch")
    world:add(punch, pair(ct.AbilityOf, stanceId))

    -- TODO Add more abilities to the fighting stance
end