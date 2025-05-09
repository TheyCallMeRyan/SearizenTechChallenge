local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require("@ecs/types")

type Remote<T...> = {
	FireClient: (Remote<T...>, player: Player, T...) -> (),
	FireAllClients: (Remote<T...>, T...) -> (),
	FireServer: (Remote<T...>, T...) -> (),
	OnServerEvent: {
		Connect: (any, fn: (Player, T...) -> () ) -> (RBXScriptConnection)
	},
	OnClientEvent: {
		Connect: (any, fn: (T...) -> () ) -> (RBXScriptConnection)
	}

}

local function stream_ensure(name): Remote<any>
	local remote = ReplicatedStorage:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = ReplicatedStorage
	end
	return remote :: any
end

local function datagram_ensure(name): Remote<any>
	local remote = ReplicatedStorage:FindFirstChild(name)
	if not remote then
		remote = Instance.new("UnreliableRemoteEvent")
		remote.Name = name
		remote.Parent = ReplicatedStorage
	end
	return remote :: any
end

export type Snapshot = {
	[string]: {
		set: { types.Entity }?,
		values: { any }?,
		removed: { types.Entity }?
	}
}

return {
	input = datagram_ensure("input") :: Remote<string>,
	
	request_snapshot = stream_ensure("request_snapshot") :: Remote<>,
	init = stream_ensure("init") :: Remote<Snapshot>,
	replication = stream_ensure("replication") :: Remote<Snapshot>,
}
