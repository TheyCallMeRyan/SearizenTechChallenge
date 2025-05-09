-- Libraries
local types = require("@ecs/types")
local ct = require("@ecs/components")
local animation_ids = require("@Common/animation_ids")

-- Locals

-- Utils
local function changeTrack(world: types.World, playerEntity: types.Entity, animationId: number?)
    local activeTrack = world:get(playerEntity, ct.AnimationTrack)
    if activeTrack then
        activeTrack:Stop()
        activeTrack:Destroy()
    end

    if not animationId then
        warn("No animationId")
        return
    end

    local renderable = world:get(playerEntity, ct.Renderable)
    local Humanoid = renderable and renderable:FindFirstChildWhichIsA("Humanoid")
    if not Humanoid then
        warn("No humanoid", renderable, Humanoid)
        return
    end

    local Animator = Humanoid:FindFirstChildWhichIsA("Animator")
    if not Animator then
        warn("No animator")
        return
    end

    local Animation = Instance.new("Animation")
    Animation.AnimationId = `rbxassetid://{animationId}`

    local track = Animator:LoadAnimation(Animation)
    track.Looped = true
    track.Priority = Enum.AnimationPriority.Idle
    track:Play()

    world:set(playerEntity, ct.AnimationTrack, track)
end

-- System
return function(world: types.World, _dt: number)
    world:added(ct.ActiveStance, function(entity: types.Entity, _, value: any)
        local stanceName = world:get(value, ct.Stance)
        changeTrack(world, entity, animation_ids.Stances[stanceName].Idle)
    end)

    world:changed(ct.ActiveStance, function(entity: types.Entity, _, value: any)  
        local stanceName = world:get(value, ct.Stance)
        changeTrack(world, entity, animation_ids.Stances[stanceName].Idle)
    end)

    world:removed(ct.ActiveStance, function(entity: types.Entity)  
        changeTrack(world, entity, nil)
    end)

    return function()
        
    end
end
