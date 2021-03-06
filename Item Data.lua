local itemNameAddress = 0x12B300
local itemNameLength = 0x0D
local itemDataAddress = 0x185000
local itemDataLength = 0x1E

local commandNameDataAddress = 0x18CEA0
local commandNameDataLength = 0x07

function GetCommandName(commandID)
	local address = commandNameDataAddress + (commandID * commandNameDataLength)
	local string = ""
    for i=1, 7, 1 do
        string = string .. HexToChar2(memory.read_u8(address + (i-1), "CARTROM"))
	end
	
	return string
end

-- DEBUG Function
--[[
function OutputCommandsList()
	local address = 0
	local string = ""

	for i=0, 0x20, 1 do
		address = commandNameDataAddress + (i * commandNameDataLength)
		string = ""

		for i2=1, 7, 1 do
			string = string .. HexToChar(memory.read_u8(address + (i2-1), "CARTROM"))
		end

		console.log(tostring(bizstring.hex(i)) .. ": " .. string)
	end
end
]]

function SetChangedCommandNames()
	beforeValues = {}
	afterValues = {}

	for i=0, 4, 1 do
		address1 = 0x36198
		address2 = 0x3619D

		beforeValues[i + 1] = memory.read_u8(address1 + i, "CARTROM")
		afterValues[i + 1] = memory.read_u8(address2 + i, "CARTROM")
	end

	itemSpecialEffectsList[2][3] = GetCommandName(beforeValues[5]) .. " > " .. GetCommandName(afterValues[5])
	itemSpecialEffectsList[2][4] = GetCommandName(beforeValues[4]) .. " > " .. GetCommandName(afterValues[4])
	itemSpecialEffectsList[2][5] = GetCommandName(beforeValues[3]) .. " > " .. GetCommandName(afterValues[3])
	itemSpecialEffectsList[2][6] = GetCommandName(beforeValues[2]) .. " > " .. GetCommandName(afterValues[2])
	itemSpecialEffectsList[2][7] = GetCommandName(beforeValues[1]) .. " > " .. GetCommandName(afterValues[1])
end





-- Items ---------------------------
function GetItemName(itemID)
	if itemID == 0xFF then return "" end
    
	local address = itemNameAddress + (itemID * itemNameLength)
	local string = ""

	require 'Utils'
	for i=1, 13, 1 do
		string = string .. HexToChar(memory.read_u8(address + (i - 1), "CARTROM"))
	end

	return string
end

function GetItemSymbolValue(itemID)
	if itemID == 0xFF then return 0x00 end
    
	local address = itemNameAddress + (itemID * itemNameLength)

	return memory.read_u8(address, "CARTROM")
end

function GetAllItemRawData(itemID)
	local address = itemDataAddress + (itemID * itemDataLength)
	local string = ""

	for i=0, itemDataLength + 1, 1 do
		string = string .. PadLeft(bizstring.hex(memory.read_u8(address+i, "CARTROM")), 2, "0") .. " "
	end

	--console.log(string)
	return string
end

function DoesItemProc(itemID)
	local value = GetItemDataValue(itemID, 0x13)
	if bit.band(value, 0x04) == 0x04 then
		return true
	end
	
	return false
end

function DoesItemTeachSpell(itemID)
	if GetItemDataValue(itemID, 0x03) > 0x00 then return true end

	return false
end

function GetItemType(itemID, rawValue)
	local rawValue = rawValue or false
    
	local address = itemDataAddress + (itemID * itemDataLength)
	local value = memory.read_u8(address, "CARTROM")

	-- Remove other flags
	value = bit.band(value, 0x07)

	if rawValue then return value end

	if value == 0x00 then 
		return "Tool"
	elseif value == 0x01 then 
		return "Weapon"
	elseif value == 0x02 then 
		return "Body Armor"
	elseif value == 0x03 then 
		return "Shield"
	elseif value == 0x04 then 
		return "Helm"
	elseif value == 0x05 then 
		return "Relic"
	elseif value == 0x06 then 
		return "Consumable"
	else
		return "Other?"
	end
end

function GetItemDataValue(itemID, offset)
	if itemID >= 255 then
		console.log("ERR: GetItemDataValue() itemID >= 255 (itemID = " .. itemID .. ")")
		return
	end

	local address = itemDataAddress + (itemID * itemDataLength) + offset
	local value = memory.read_u8(address, "CARTROM")

	return value
end

function GetItemSpellLearned(itemID, rawValues)
    local rawValues = rawValues or false
    
    local spellRate = GetItemDataValue(itemID, 0x03)
    local spellIndex = GetItemDataValue(itemID, 0x04)

    if rawValues then return spellIndex, spellRate end

    require 'Spell Data'
	local spellName = GetSpellName(spellIndex)

	return spellName .. " * " .. spellRate
end

function GetItemFieldEffects(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x05)

	if rawValue then return value end

	value = bit.band(value, 0x23)

	require 'Constants'
	local strings = {}
	for i=1, 8, 1 do
		if bit.check(value, (i - 1)) then
			strings[#strings + 1] = itemFieldEffectsList[i]
		end
	end
	
	return strings
end

function GetItemProcSpell(itemID, rawValue)
	local rawValue = rawValue or false
    
	local value = GetItemDataValue(itemID, 0x12)

	if rawValue then return value end

	require 'Spell Data'
	if value < 0x36 then
		return GetSpellName(value)
	elseif value < 0x51 then
		return GetEsperName(value - 0x36)
	else
		return GetAttackName(value - 0x51)
	end
end

function GetItemEquipableActors(itemID, filterEnabledActors, rawValues)
	local filter = filterEnabledActors or false
	local rawValues = rawValues or false
    
	local equipLowByte = GetItemDataValue(itemID, 0x01)
	local equipHighByte = GetItemDataValue(itemID, 0x02)

	if rawValues == true then return equipLowByte, equipHighByte end

	require 'Actor Data'
	local actorNames = {}
	-- Low Byte
	for i=0, 7, 1 do
		if (filter == false or IsActorEnabled(i)) and bit.check(equipLowByte, i) then
			actorNames[#actorNames + 1] = GetActorName(i)
		else
			actorNames[#actorNames + 1] = "      "
		end
	end
	-- High Byte
	for i=0, 5, 1 do
		if (filter == false or IsActorEnabled(8 + i)) and bit.check(equipHighByte, i) then
			actorNames[#actorNames + 1] = GetActorName(8 + i)
		else
			actorNames[#actorNames + 1] = "      "
		end
	end	
	
	return actorNames
end

function GetItemHalvedElements(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x0F)

	if rawValue then return value end

	require 'Constants'
	local elems = {}
	for i=1, 8, 1 do
		if bit.check(value, (i - 1)) then
			elems[#elems + 1] = elemList[i]
		end
	end
	
	return elems
end

function GetItemNullElements(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x17)

	if rawValue then return value end

	require 'Constants'
	local elems = {}
	for i=1, 8, 1 do
		if bit.check(value, (i - 1)) then
			elems[#elems + 1] = elemList[i]
		end
	end

	return elems
end

function GetItemAbsorbElements(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x16)

	if rawValue then return value end

	require 'Constants'
	local elems = {}
	for i=1, 8, 1 do
		if bit.check(value, (i - 1)) then
			elems[#elems + 1] = elemList[i]
		end
	end

	return elems
end

function GetItemWeakElements(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x18)

	if rawValue then return value end

	require 'Constants'
	local elems = {}
	for i=1, 8, 1 do
		if bit.check(value, (i - 1)) then
			elems[#elems + 1] = elemList[i]
		end
	end

	return elems
end

function GetWeaponElements(itemID, rawValue)
	return GetItemHalvedElements(itemID, rawValue) -- Same Address, HEHE!
end

function GetItemStatusProtection(itemID, rawValues)
	local rawValues = rawValues or false

	local values = {}
	values[1] = GetItemDataValue(itemID, 0x06)
	values[2] = GetItemDataValue(itemID, 0x07)

	if rawValues then return values end

	require 'Constants'
	local strings = {}
	for iValue=1, 2, 1 do
		for iStatus=1, 8, 1 do
			if bit.check(values[iValue], (iStatus - 1)) then
				strings[#strings + 1] = itemStatusList[iValue][iStatus]
			end
		end
	end

	return strings
end

function GetItemStatusEffects(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x08)

	if rawValue then return value end

	require 'Constants'
	local strings = {}
	for iStatus=1, 8, 1 do
		if bit.check(value, (iStatus - 1)) then
			strings[#strings + 1] = itemStatusList[3][iStatus]	
		end
	end

	return strings
end

function GetItemSpecialEffects(itemID, rawValues)
	local rawValues = rawValues or false

	local values = {}
	values[1] = GetItemDataValue(itemID, 0x09)
	values[2] = GetItemDataValue(itemID, 0x0A)
	values[3] = GetItemDataValue(itemID, 0x0B)
	values[4] = GetItemDataValue(itemID, 0x0C)
	values[5] = GetItemDataValue(itemID, 0x0D)

	if rawValues then return values end
	

	require 'Constants'
	local strings = {}
	for iValue=1, 5, 1 do
		strings[iValue] = {}
		for iStatus=1, 8, 1 do
			strings[iValue][iStatus] = ""
			if bit.check(values[iValue], (iStatus - 1)) then
				strings[iValue][iStatus] = itemSpecialEffectsList[iValue][iStatus]
			else
				strings[iValue][iStatus] = "      "
			end
		end
	end

	return strings
end

function GetItemWeaponProperties(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x13)

	if rawValue then return value end

	-- No need to display Proc and Break from here
	value = bit.clear(value, 2) 
	value = bit.clear(value, 3)

	require 'Constants'
	local strings = {}

	if bit.check(value, 1) then
		strings[#strings + 1] = weaponPropertiesList[2]
	else
		strings[#strings + 1] = "       "
	end

	if bit.check(value, 5) then
		strings[#strings + 1] = weaponPropertiesList[6]
	else
		strings[#strings + 1] = "       "
	end

	if bit.check(value, 6) then
		strings[#strings + 1] = weaponPropertiesList[7]
	else
		strings[#strings + 1] = "      "
	end

	if bit.check(value, 7) then
		strings[#strings + 1] = weaponPropertiesList[8]
	else
		strings[#strings + 1] = "     "
	end

	return strings
end

function GetItemSpecialStatus(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x19)

	if rawValue then return value end

	require 'Constants'
	local strings = {}
	for iStatus=1, 8, 1 do
		if bit.check(value, (iStatus - 1)) then
			strings[#strings + 1] = equipmentStatusList[iStatus]
		end
	end

	return strings
	

end

function GetWeaponSpecialAbility(itemID, rawValue)
	local rawValue = rawValue or false

	local value = GetItemDataValue(itemID, 0x1B)

	if rawValue then return value end

	-- Seems like 0x0F deal with defensive things?
	-- And 0xF0 deals with offensive things?
	local offenseValue = bit.rshift(value, 4)
	if offenseValue == 0x00 then return "" end

	return weaponSpecials[offenseValue]
end

function GetItemOtherEffects(itemID, offset)
	local values = {}
	values[1] = GetItemDataValue(itemID, offset)

	local strings = {}
	for iStatus=1, 8, 1 do
		if bit.check(values[1], (iStatus - 1)) then
			strings[#strings + 1] = "Bit " .. tostring(iStatus - 1)
		end
	end

	return strings
end



