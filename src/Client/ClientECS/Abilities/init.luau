
local types = require("@ecs/types")

return {
    Punch = require(script.Punch),
} :: {
    [string]: (types.World, types.Entity) -> ()
}