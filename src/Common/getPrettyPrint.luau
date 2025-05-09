--!strict

local indent = "    "

local function getPrettyPrint(topLevel, _indentLevel: number?)
	local indentLevel = _indentLevel or 0
	local output = {}

	if typeof(topLevel) == "table" then
		table.insert(output, "{\n")

		for key, value in pairs(topLevel) do
			table.insert(output, indent:rep(indentLevel + 1))
			table.insert(output, tostring(key))
			table.insert(output, " = ")

			table.insert(output, getPrettyPrint(value, indentLevel + 1))
			table.insert(output, "\n")
		end

		table.insert(output, indent:rep(indentLevel))
		table.insert(output, "}")
	elseif typeof(topLevel) == "string" then
		table.insert(output, string.format("%q", topLevel))
		table.insert(output, " (string)")
	else
		table.insert(output, tostring(topLevel))
		table.insert(output, " (")
		table.insert(output, typeof(topLevel))
		table.insert(output, ")")
	end

	return table.concat(output, "")
end

return getPrettyPrint