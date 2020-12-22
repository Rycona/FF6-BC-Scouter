function HexToChar(value)
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
		char = ""
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
		char = ""
	elseif value >= 0xFE then --Space
		char = " "
	--elseif value ~= 0xFF then
		--char = bizstring.hex(value)
	end

	return char
end

function PadLeft(text, length, char)
	char = " " or char

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
	char = " " or char

	local strLen = string.len(text)
	if (strLen >= length) then
		return text
	end

	local newString = text

	console.log(length - strLen)
	for i=1, length - strLen, 1 do
		newString = newString .. char
	end

	return newString
end

function ByteToBinary(value)
	if value > 255 then return "(0bERR!)" end

	local string = value .. ": 0b"

	for i=0, 7, 1 do 
		if bit.check(value, i) then
			string = string .. "1"
		else
			string = string .. "0"
		end
	end

	return string
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
