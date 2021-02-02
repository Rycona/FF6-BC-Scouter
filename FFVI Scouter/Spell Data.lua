local spellNameAddress = 0x26F567
local spellNameLength = 0x07
local spellDataAddress = 0x146AC0 
local spellDataLength = 0x0E

local esperNameAddress = 0x26F6E1
local esperNameLength = 0x08

local attackNameAddress = 0x26F7B9
local attackNameLength = 0x0A

function GetSpellName(spellID)
    require 'Utils'

	local address = spellNameAddress + (spellID * spellNameLength)

	local name = ""
	for i=0, 6, 1 do
		name = name .. HexToChar2(memory.read_u8(address + i, "CARTROM"))
	end

	return name
end

function GetSpellSymbolValue(spellID)
	local address = spellNameAddress + (spellID * spellNameLength)

	return memory.read_u8(address, "CARTROM")
end

function GetEsperName(esperID)
    require 'Utils'

	local address = esperNameAddress + (esperID * esperNameLength)

	local name = ""
	for i=0, 7, 1 do
		name = name .. HexToChar(memory.read_u8(address + i, "CARTROM"))
	end

	return name
end

function GetAttackName(attackID)
    require 'Utils'

	local address = attackNameAddress + (attackID * attackNameLength)

	local name = ""
	for i=0, 9, 1 do
		name = name .. HexToChar(memory.read_u8(address + i, "CARTROM"))
	end

	return name
end