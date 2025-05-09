local jecs = require(game:GetService('ReplicatedStorage'):WaitForChild('luau_packages'):WaitForChild('jecs'))

local Networked = jecs.tag()
local NetworkedPair = jecs.tag()

local Renderable = jecs.component() :: jecs.Id<Instance>
jecs.meta(Renderable, Networked, nil)

local Player = jecs.component() :: jecs.Id<Player>
jecs.meta(Player, Networked)

local Stance = jecs.component() :: jecs.Id<string>
jecs.meta(Stance, Networked)

local StanceOf = jecs.tag()
jecs.meta(StanceOf, NetworkedPair, nil)

local Ability = jecs.component() :: jecs.Id<string>
jecs.meta(Ability, Networked)

local AbilityOf = jecs.tag()
jecs.meta(AbilityOf, NetworkedPair, nil)

local IsLocalPlayer = jecs.tag()

local LocalPlayerId = jecs.component() :: jecs.Id<jecs.Id<any>>

local ActiveStance = jecs.component() :: jecs.Id<jecs.Id<any>>

local Activated = jecs.tag()

local AnimationTrack = jecs.component() :: jecs.Id<AnimationTrack>

local Cooldown = jecs.component() :: jecs.Id<number>

local components = {
	Renderable = Renderable,
	Player = Player,

	Stance = Stance,
	StanceOf = StanceOf,
	Ability = Ability,
	AbilityOf = AbilityOf,

	IsLocalPlayer = IsLocalPlayer,
	LocalPlayerId = LocalPlayerId,

	Activated = Activated,

	ActiveStance = ActiveStance,
	AnimationTrack = AnimationTrack,

	Cooldown = Cooldown,

	Networked = Networked,
	NetworkedPair = NetworkedPair,
}

for name, component in components do
	jecs.meta(component :: any, jecs.Name, name :: any)
end

return components