-- Services
local Players = game:GetService("Players")

-- Libraries
local types = require("@ecs/types")
local ct = require("@ecs/components")

-- Locals
local LocalPlayer = Players.LocalPlayer

-- System
return function(world: types.World, _dt: number)
    local NewPlayers = {}

    world:added(ct.Player, function(entity: types.Entity, _, _value: Player)  
        table.insert(NewPlayers, entity)
    end)

    return function()
        for _, newPlayerEntity in NewPlayers do
            local player = world:contains(newPlayerEntity) and world:get(newPlayerEntity, ct.Player)
            if player == LocalPlayer then
                world:add(newPlayerEntity, ct.IsLocalPlayer)
                world:set(ct.LocalPlayerId, ct.LocalPlayerId, newPlayerEntity)
            end
        end

        table.clear(NewPlayers)
    end
end
