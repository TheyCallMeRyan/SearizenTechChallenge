-- Libraries
local types = require("@ecs/types")
local ct = require("@ecs/components")

-- System
return function(world: types.World, _dt: number)
    for entity, player in world:query(ct.Player):without(ct.Renderable) do
        if player.Character and player.Character.Parent then
            world:set(entity, ct.Renderable, player.Character)
        end
    end
end
