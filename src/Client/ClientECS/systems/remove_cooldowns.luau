-- Libraries
local types = require("@ecs/types")
local ct = require("@ecs/components")

-- Locals

-- System
return function(world: types.World, _dt: number)
    for id, cooldown in world:query(ct.Cooldown) do
        if os.clock() > cooldown then
            world:remove(id, ct.Cooldown)
        end
    end
end
