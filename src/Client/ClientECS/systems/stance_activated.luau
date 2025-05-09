-- Libraries
local types = require("@ecs/types")
local ct = require("@ecs/components")

-- Locals

-- System
return function(world: types.World, _dt: number)
    for stance in world:query(ct.Stance):with(ct.Activated) do
        local playerEntity = world:target(stance, ct.StanceOf)
        if not playerEntity or not world:contains(playerEntity) then
            warn("Stance should be deleted?")
            continue
        end

        local activeStance = world:get(playerEntity, ct.ActiveStance)
        if activeStance and activeStance == stance then
            world:remove(playerEntity, ct.ActiveStance)
        else
            -- TODO player may have a different stance currently equipped, cleanup current stance and switch
            world:set(playerEntity, ct.ActiveStance, stance)
        end

        world:remove(stance, ct.Activated)
    end
end
