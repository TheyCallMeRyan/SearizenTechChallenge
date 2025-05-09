local jecs = require(game:GetService('ReplicatedStorage'):WaitForChild('luau_packages'):WaitForChild('jecs'))

local Networked = jecs.tag()
local NetworkedPair = jecs.tag()

local Renderable = jecs.component() :: jecs.Id<Instance>
jecs.meta(Renderable, Networked, nil)

local Player = jecs.component() :: jecs.Id<Player>
jecs.meta(Player, Networked)

local components = {
	Renderable = Renderable,
	Player = Player,

	Networked = Networked,
	NetworkedPair = NetworkedPair,
}

for name, component in components do
	jecs.meta(component :: any, jecs.Name, name :: any)
end

return components