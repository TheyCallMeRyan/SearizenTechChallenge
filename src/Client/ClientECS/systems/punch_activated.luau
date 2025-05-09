-- Libraries
local types = require("@ecs/types")
local ct = require("@ecs/components")
local Abilities = require("@ClientECS/Abilities")

-- Locals

-- System
return function(world: types.World, _dt: number)
    for ability, abilityName in world:query(ct.Ability):with(ct.Activated) do
        local stance = world:target(ability, ct.AbilityOf)
        if not stance or not world:contains(stance) then
            warn("Ability should be deleted?")
            continue
        end

        local playerEntity = world:target(stance, ct.StanceOf)
        if not playerEntity or not world:contains(playerEntity) then
            warn("Stance should be deleted?")
            continue
        end

        if not world:has(ability, ct.Cooldown) then
            Abilities[abilityName](world, ability)
        end

        world:remove(ability, ct.Activated)
    end
end
