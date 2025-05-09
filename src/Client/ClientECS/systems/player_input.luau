-- Services
local ContextActionService = game:GetService("ContextActionService")

-- Libraries
local jecs = require("@luau_packages/jecs")
local pair = jecs.pair
local __ = jecs.Wildcard

local types = require("@ecs/types")
local ct = require("@ecs/components")

-- Locals
local ToggleFighting = false
local InitPunch = false

local function fightPressed(_actionName, inputState, _inputObject)
    if inputState == Enum.UserInputState.Begin then
        ToggleFighting = true
    end
end

local function punchClicked(_actionName, inputState, _inputObject)
    if inputState == Enum.UserInputState.Begin then
        InitPunch = true
    end
end


-- System

ContextActionService:BindAction("EnterFighting", fightPressed, true, Enum.KeyCode.F)
ContextActionService:BindAction("Punch", punchClicked, true, Enum.UserInputType.MouseButton1)
return function(world: types.World, _dt: number)
    local LocalPlayerId = world:get(ct.LocalPlayerId, ct.LocalPlayerId)
    if not LocalPlayerId then
        return
    end

    if ToggleFighting then
        ToggleFighting = false

        for stance, stanceName in world:query(ct.Stance, pair(ct.StanceOf, LocalPlayerId)) do
            if stanceName == "Fighting" then
                world:add(stance, ct.Activated)
            end
        end
    end
    
    if InitPunch then
        InitPunch = false

        local ActiveStance = world:get(LocalPlayerId, ct.ActiveStance)
        if not ActiveStance then
            warn("Cannot punch, no active stance")
            return
        end

        for ability, abilityName in world:query(ct.Ability, pair(ct.AbilityOf, ActiveStance)) do
            if abilityName == "Punch" then
                world:add(ability, ct.Activated)
            end
        end
    end
end
