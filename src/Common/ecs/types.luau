local jecs = require("@luau_packages/jecs")
local observers_add = require("@ecs/observers_add")

export type World = typeof(observers_add(jecs.world()))
export type Entity = jecs.Entity
export type Id<T> = jecs.Id<T>

return {}