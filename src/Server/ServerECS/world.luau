-- Libraries
local jecs = require("@luau_packages/jecs")
local observers_add = require("@ecs/observers_add")

-- Components/scheduler must be init'd prior to World.new because tags must be set prior to it
local schedule = require("@ecs/schedule")
local _components = require("@ecs/components") 

local SYSTEM = schedule.SYSTEM
local RUN = schedule.RUN

local server_ecs = script.Parent
local systems = server_ecs.systems

local world = observers_add(jecs.World.new())

SYSTEM(world, systems.replication)
SYSTEM(world, systems.init_replication)
SYSTEM(world, systems.players_added)
RUN(world)

return world