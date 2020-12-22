local nameDataAddress = 0x0FC050
local nameDataLength = 0x10
local statsDataAddress = 0x0F0000
local statsDataLength = 0x20
local dropStealDataAddress = 0x0F3000
local dropStealDataLength = 0x04
local morphPackDataAddress = 0x047F40
local morphPackDataLength = 0x04


function GetEnemyElementalProperties(enemyID, rawValues)
    local rawValues = rawValues or false

	local address = statsDataAddress + (enemyID * statsDataLength) + 0x17
	local abs, null, weak = {}, {}, {}
	local absValue = memory.read_u8(address, "CARTROM")
	local nullValue = memory.read_u8(address + 1, "CARTROM")
	local weakValue = memory.read_u8(address + 2, "CARTROM")

	-- Remove elems absorbed from weak value
    weakValue = bit.bxor(bit.bor(weakValue, absValue), absValue)
    
    if rawValues then return absValue, nullValue, weakValue end

	for iCheck = 1, 8, 1 do
		if bit.check(absValue, (iCheck - 1)) then
			table.insert(abs, elemList[iCheck])
		end

		if bit.check(nullValue, (iCheck - 1)) then
			table.insert(null, elemList[iCheck])
		end

		if bit.check(weakValue, (iCheck - 1)) then
			table.insert(weak, elemList[iCheck])
		end

		--[[
		if bit.check(value, (iCheck - 1)) then
			table.insert(elements, elemList[iCheck])
		end
		]]--
	end

	return abs, null, weak
end

function GetEnemyStatusImmunities(enemyID, rawValues)
    local rawValues = rawValues or false

	local address = statsDataAddress + (enemyID * statsDataLength) + 0x14
	local values = {}

	for i=1, 3, 1 do
		values[i] = memory.read_u8(address + (i - 1), "CARTROM")
    end
    
    if rawValues then return values end

	local immune, vulnerable = {}, {}
	for iValue=1, 3, 1 do
		for iStatus=1, 8, 1 do
			if bit.check(values[iValue], (iStatus - 1)) then
				table.insert(immune, statusList[iValue][iStatus])
			else
				table.insert(vulnerable, statusList[iValue][iStatus])
			end
		end
	end

	return immune, vulnerable
end

function GetEnemyStatuses(enemyID, rawValues)
    local rawValues = rawValues or false

	local address = statsDataAddress + (enemyID * statsDataLength) + 0x1B
	local values = {}

	for i=1, 3, 1 do
		values[i] = memory.read_u8(address + (i - 1), "CARTROM")
    end
    
    if RawValues then return values end

	local statuses = {}
	for iValue=1, 3, 1 do
		for iStatus=1, 8, 1 do
			if bit.check(values[iValue], (iStatus - 1)) then
				table.insert(statuses, statusList[iValue][iStatus])
			end
		end
	end

	return statuses
end

-- Raw Value: TRUE = returns the byte value, FALSE = return an array of strings
-- Else, if there are no other properties, the string will be blank
function GetEnemyOtherProperties(enemyID, rawValue)
    local rawValue = rawValue or false

    local address = statsDataAddress + (enemyID * statsDataLength) + 0x12
    if rawValue == true then return memory.read_u16_le(address, "CARTROM") end

	local values = {}
	local otherProps = {}
    
    values = { memory.read_u8(address, "CARTROM"), memory.read_u8(address + 1, "CARTROM") }

	if bit.band(values[1], 0x01) == 0x01 then
		table.insert(otherProps, "Dies at MP Zero | ")
	end

	if bit.band(values[1], 0x10) == 0x10 then
		table.insert(otherProps, "Humanoid | ")
	end

	if bit.band(values[1], 0x80) == 0x80 then
		table.insert(otherProps, "Undead | ")
	end

	if bit.band(values[2], 0x01) == 0x01 then
		table.insert(otherProps, "Difficult to Run | ")
	end

    --[[
	if bit.band(values[2], 0x02) == 0x02 then
		table.insert(otherProps, "Ambusher | ")
	end
    ]]--

	if bit.band(values[2], 0x08) == 0x08 then
		table.insert(otherProps, "Can't Run | ")
	end

	if #otherProps > 0 then
		local string = "Other: "
		for i=1, #otherProps, 1 do
			string = string .. otherProps[i]
		end

		return string
	end

    return ""
end

function GetEnemySteals(enemyID)
    -- Item 1: 1/8, Item 2: 7/8
    local address = dropStealDataAddress + (enemyID * dropStealDataLength)
    local stealIDs = {
        memory.read_u8(address, "CARTROM"),
        memory.read_u8(address + 1, "CARTROM")
    }

    return stealIDs
end

function GetEnemyDrops(enemyID)
    -- Item 1: 1/8, Item 2: 7/8
    local address = dropStealDataAddress + (enemyID * dropStealDataLength)
    local dropIDs = {
        memory.read_u8(address + 2, "CARTROM"),
        memory.read_u8(address + 3, "CARTROM")
    }
end

-- returns (chanceString, itemIDs[4]) or just an empty string if there is no chance
function GetEnemyMorphs(enemyID)
	morphAddress = statsDataAddress + (enemyID * statsDataLength) + 0x11
	morphValue = memory.read_u8(morphAddress, "CARTROM")

	local hitRate = bit.band(morphValue, 0xE0)
	if hitRate == 0xE0 then return "" end -- 0xE0 means no morph :(

    -- Get chance string
    chanceString = "Morph: (" .. morphRateList[bit.rshift(hitRate, 5) + 1] .. "): "

    -- Get pack of morph items
    local pack = bit.band(morphValue, 0x1F)
    
    morphPackAddress = morphPackDataAddress + (pack * morphPackDataLength)
    morphPackValues = {}
    for i=1, 4, 1 do
        morphPackValues[i] = memory.read_u8(morphPackAddress + (i - 1), "CARTROM")
    end

    return chanceString, morphPackValues
end

function GetEnemyName(enemyID)
    require 'Utils'

	local address = nameDataAddress + (enemyID * nameDataLength)
	local name = ""

	for iChar = 0, 9, 1 do
		charAddress = address + iChar
		local value = memory.read_u8(charAddress, "CARTROM");
		local char = HexToChar(value)

		-- Numbers + Other characters MISSING
		

		if char ~= "" then
			name = name .. char
		end

	end

	return name
end

function GetEnemyLV(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x10
    return memory.read_u8(address, "CARTROM")
end

function GetEnemyHP(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x08
    return memory.read_u16_le(address + 0x08, "CARTROM")
end

function GetEnemyMP(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x0A
    return memory.read_u16_le(address + 0x08, "CARTROM")
end

function GetEnemyXP(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x0C
    return memory.read_u16_le(address + 0x08, "CARTROM")
end

function GetEnemyGP(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x0E
    return memory.read_u16_le(address + 0x08, "CARTROM")
end

function GetEnemyATK(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x01
    return memory.read_u8(address, "CARTROM")
end

function GetEnemyMPOW(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x07
    return memory.read_u8(address, "CARTROM")
end

function GetEnemyDEF(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x05
    return memory.read_u8(address, "CARTROM")
end

function GetEnemyMDEF(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x06
    return memory.read_u8(address, "CARTROM")
end

function GetEnemySPD(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x00
    return memory.read_u8(address, "CARTROM")
end

function GetEnemyHIT(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x02
    return memory.read_u8(address, "CARTROM")
end

function GetEnemyEVD(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x03
    return memory.read_u8(address, "CARTROM")
end

function GetEnemyMBLK(enemyID)
    local address = statsDataAddress + (enemyID * statsDataLength) + 0x04
    return memory.read_u8(address, "CARTROM")
end
	
	
--[[
function GetEnemyInfo(enemyID)
	GetEnemyName(enemyID)
	GetEnemyStats(enemyID)
	GetEnemyItems(enemyID)
end
]]--

-------------- DISPLAY ---------------------------

function DisplayEnemyInfo()

end

