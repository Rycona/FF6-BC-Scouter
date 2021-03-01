local spellNameAddress = 0x26F567
local spellNameLength = 0x07
local spellDataAddress = 0x146AC0 
local spellDataLength = 0x0E

local esperNameAddress = 0x26F6E1
local esperNameLength = 0x08

local esperDataAddress = 0x186E00
local esperDataLength = 0x0B

local attackNameAddress = 0x26F7B9
local attackNameLength = 0x0A

-- Spells -----------------------------------
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

-- Espers --------------------------------------
function GetEsperName(esperID)
    require 'Utils'

	local address = esperNameAddress + (esperID * esperNameLength)

	local name = ""
	for i=0, 7, 1 do
		name = name .. HexToChar(memory.read_u8(address + i, "CARTROM"))
	end

	return name
end

function GetEsperSpellID(esperID, spellSlot) --SpellSlot - 0-Index
	local address = esperDataAddress + (esperID * esperDataLength) + 0x01 + (spellSlot * 0x02)
	return memory.read_u8(address, "CARTROM")
end

function GetEsperSpellLearnRate(esperID, spellSlot) --SpellSlot - 0-Index
	local address = esperDataAddress + (esperID * esperDataLength) + (spellSlot * 0x02)
	return memory.read_u8(address, "CARTROM")
end

function GetEsperLevelBonusID(esperID)
	local address = esperDataAddress + (esperID * esperDataLength) + 0x0A
	return memory.read_u8(address, "CARTROM")
end

function IsEsperEnabled(esperID)
	--console.log("esperID: " .. esperID)
	if esperID > 0x1A then return false end

	local byte = 0
	local bitToCheck = esperID
	while bitToCheck > 7 do
		bitToCheck = bitToCheck - 8
		byte = byte + 1
	end

	--console.log("byte: " .. byte)
	--console.log("bit: " .. bit)
	--console.log("read: " ..value)
	if bit.check(mainmemory.read_u8(0x1A69 + byte), bitToCheck) then return true end

	return false
end

-- Attacks ----------------------------------------
function GetAttackName(attackID)
    require 'Utils'

	local address = attackNameAddress + (attackID * attackNameLength)

	local name = ""
	for i=0, 9, 1 do
		name = name .. HexToChar(memory.read_u8(address + i, "CARTROM"))
	end

	return name
end