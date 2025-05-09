
local types = require("@ecs/types")

return {
    Fighting = require(script.Fighting),
} :: {
    [string]: (types.World, types.Entity) -> ()
}