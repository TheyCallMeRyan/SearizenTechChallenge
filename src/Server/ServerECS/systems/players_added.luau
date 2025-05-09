-- Services
local Players = game:GetService("Players")

-- Libraries
local jecs = require("@luau_packages/jecs")
local pair = jecs.pair

local collect = require("@ecs/collect")
local types = require("@ecs/types")
local ct = require("@ecs/components")

-- System
local player_added = collect(Players.PlayerAdded)
return function(world: types.World, _dt: number)
	for player in player_added do
		local playerEntity = world:entity()
		world:set(playerEntity, ct.Player, player)

		local fightingStance = world:entity()
		world:set(fightingStance, ct.Stance, "Fighting")
		world:add(fightingStance, pair(ct.StanceOf, playerEntity))
	end
end
