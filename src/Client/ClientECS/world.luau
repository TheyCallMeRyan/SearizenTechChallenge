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
RUN(world)

return world