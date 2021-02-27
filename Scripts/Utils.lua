function HexToChar(value) -- Item Names, ?
	local char = ""

	if value >= 0x7F and value <= 0x99 then -- A to Z
		char = string.char(value - 63)
	elseif value >= 0x9A and value <= 0xBE then -- a to z & 0 to 9
		char = string.char(value - 57)
	elseif value == 0xBE then --Exclamation Point
		char = "!"
	elseif value == 0xBF then --Question Mark
		char = "?"
	elseif value == 0xC3 then --Apostrophe
		char = "'"
	elseif value == 0xC4 then --Hyphen
		char = "-"
	elseif value >= 0xD8 and value <= 0xEA then -- Pass over Item/Spell Symbols
		char = "" --"{" .. bizstring.hex(value) .. "}"
	elseif value >= 0xFE then --Space
		char = " "
	--elseif value ~= 0xFF then
		--char = bizstring.hex(value)
	end

	return char
end

function HexToChar2(value)
	local char = ""

	if value >= 0x7F and value <= 0x99 then -- A to Z
		char = string.char(value - 63)
	elseif value >= 0x9A and value <= 0xB4 then -- a to z
		char = string.char(value - 57)
	elseif value >= 0xB5 and value <= 0xBE then -- 0 to 9
		char = string.char(value - 132)
	elseif value == 0xBE then --Exclamation Point
		char = "!"
	elseif value == 0xBF then --Question Mark
		char = "?"
	elseif value == 0xC3 then --Apostrophe
		char = "'"
	elseif value == 0xC4 then --Hyphen
		char = "-"
	elseif value >= 0xD8 and value <= 0xEA then -- Pass over Item/Spell Symbols
		char = "" --"{" .. bizstring.hex(value) .. "}"
	elseif value >= 0xFE then --Space
		char = " "
	--elseif value ~= 0xFF then
		--char = bizstring.hex(value)
	end

	return char
end

function PadLeft(text, length, char)
	char = char or " "

	local strLen = string.len(text)
	if (strLen >= length) then
		return text
	end

	local newString = ""
	for i=1, length - strLen, 1 do
		newString = newString .. char
	end

	newString = newString .. text

	return newString
end

function PadRight(text, length, char)
	char = char or " "

	local strLen = string.len(text)
	if (strLen >= length) then
		return text
	end

	local newString = text

	for i=1, length - strLen, 1 do
		newString = newString .. char
	end
	
	return newString
end

function TableToString(table, joiningChars)
	if table == nil then console.log("ERR!: TableToString() table = nil") end
	joiningChars = joiningChars or ", "

	--console.log(table)
	if #table == 1 then return table[1] end

	local string = ""
	for i=1, #table, 1 do
		string = string .. table[i]
		if i ~= #table then string = string .. joiningChars end
	end

	return string
end

function AreTablesDifferent(table1, table2, ignoreDifferentLengths)
	local ignoreDifferentLengths = ignoreDifferentLengths or false

	if not ignoreDifferentLengths and #table1 ~= #table2 then
		console.log("ERR: Comparing Tables of different length")
		console.log("table1 Length: " .. #table1)
		console.log(table1)
		console.log("table2 Length: " .. #table2)
		console.log(table2)
	end

	for i=1, #table1, 1 do
		if table1[i] ~= table2[i] then return true end
	end

	return false
end

function ConvertRawColorToARGB(colorValues)
    local r = 0
    local g = 0
    local b = 0
    local colorPoints = 0

	--console.log("Convert colorValues:")
	--console.log(colorValues)
    -- red
    colorPoints = bit.band(colorValues[1], 0x1F)
    r = colorPoints * 8 + math.floor(colorPoints / 4)

    --green
    colorPoints = bit.band(colorValues[2], 0x03) * 8 + (bit.band(colorValues[1], 0xE0) / 0x20)
    g = colorPoints * 8 + math.floor(colorPoints / 4)

    --blue
    colorPoints = bit.band(colorValues[2], 0x7C) / 4
    b = colorPoints * 8 + math.floor(colorPoints / 4)

    --console.log("RGB: " .. bizstring.hex(r) .. " " .. bizstring.hex(g) .. " " .. bizstring.hex(b))
    return 0xFF000000 + r * 0x010000 + g * 0x000100 + b * 0x000001
end




