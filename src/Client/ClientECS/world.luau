-- Libraries
local jecs = require("@luau_packages/jecs")
local observers_add = require("@ecs/observers_add")

-- Components/scheduler must be init'd prior to World.new because tags must be set prior to it
local schedule = require("@ecs/schedule")
local _components = require("@ecs/components") 

local SYSTEM = schedule.SYSTEM
local RUN = schedule.RUN

local world = observers_add(jecs.World.new())


local client_ecs = script.Parent
local systems = client_ecs.systems

SYSTEM(world, systems.receive_replication)
SYSTEM(world, systems.tag_local_player)
SYSTEM(world, systems.remove_cooldowns)
SYSTEM(world, systems.player_input)
SYSTEM(world, systems.stance_activated)
SYSTEM(world, systems.animate_stance)
SYSTEM(world, systems.punch_activated)
RUN(world)

return world