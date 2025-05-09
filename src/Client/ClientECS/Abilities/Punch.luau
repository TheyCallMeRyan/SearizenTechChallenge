-- Libraries
local types = require("@ecs/types")
local ct = require("@ecs/components")
local animation_ids = require("@Common/animation_ids")

local AbilityData = require("@Common/AbilityData")

local function getCharacter(world: types.World, abilityId: types.Entity)
    local stanceId = world:target(abilityId, ct.AbilityOf)
    local playerEntity = stanceId and world:target(stanceId, ct.StanceOf)
    local renderable = playerEntity and world:get(playerEntity, ct.Renderable)
    return renderable
end

local function playTrack(character: Model, animationId: number?) : AnimationTrack?
    if not animationId then
        warn("No animationId")
        return
    end

    local Humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    if not Humanoid then
        warn("No humanoid", character, Humanoid)
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
    track.Looped = false
    track.Priority = Enum.AnimationPriority.Action
    track:Play()

    return track
end

local function getHumanoid(hit: Instance) : Humanoid?
    while hit.Parent do
        local humanoid = hit:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            return humanoid
        end

        hit = hit.Parent
    end

    return nil
end

local function trackHits(character: Model)
    local HitHumanoids = {}
    local RightHand = character:FindFirstChild("RightHand") :: BasePart
    return RightHand.Touched:Connect(function(hit)
        local humanoid = getHumanoid(hit)
        if humanoid and not HitHumanoids[humanoid] then
            HitHumanoids[humanoid] = true

            -- TODO - send humanoid to server, have the server do validation instead
            humanoid:TakeDamage(10)
        end
    end)
end

-- Stance Init
return function(world: types.World, abilityId: types.Entity)
    local character = getCharacter(world, abilityId) :: Model

    local track = playTrack(character, animation_ids.Abilities.Punch)
    if not track then
        return
    end

    local hitTracker = trackHits(character)

    track.Ended:Once(function()
        hitTracker:Disconnect()
    end)

    world:set(abilityId, ct.Cooldown, os.clock() + AbilityData.Punch.Cooldown)
end