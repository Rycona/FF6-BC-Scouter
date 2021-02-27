--[[
statusList = { 
	{ "Blind", "Zombie", "Poison", "Magitek", "Vanish", "Imp", "Petrify", "Death" },
	{ "Condemned", "Near-Death", "Image", "Mute", "Berserk", "Confuse", "Seizure", "Sleep" },
	{ "Float", "Regen", "Slow", "Haste", "Stop", "Shell", "Protect", "Reflect" },
	{ "Cover", "Runic", "Reraise", "Morph", "Casting", "Disappear", "Interceptor", "Floating" }
}
]]

function GetBattleActorName(partySlot)
	return GetActorName(mainmemory.read_u8(0x3ED8) + 2 * partySlot)
end

function GetBattleActorData(partySlot, slotOffset, addresses)
	local values = {}
	for i=1, #addresses, 1 do 
		values[i] = mainmemory.read_u8(addresses[i] + (partySlot * slotOffset))
	end

	return values
end

function GetStringsFromList(values, list)
	local strings = {}
	if #value == 1 then
		for iByte=0, 8, 1 do
			if bit.check(values[iByte+1], iBit) then
				strings[#strings+1] = list[iBit]
			end
		end
	else
		for iBit=0, #values - 1, 1 do
			for iByte=0, 8, 1 do
				if bit.check(values[iByte+1], iBit) then
					strings[#strings+1] = list[iByte][iBit]
				end
			end
		end
	end

	return strings
end

-- Specific Data Functions -------------------------------------
function GetBattleActorID(partySlot)
	return mainmemory.read_u8(0x2EC6 + (partySlot * 0x20))
end

function GetBattleActorStats(partySlot, rawValues)
	--[[ Stat Order:
	Level, CurHP, MaxHP, CurMP, MaxMP,
	Vigor * 2, Speed, Stamina, Mag Pwr, Bat Pwr (2, Main Hand + Off Hand)
	Defense, 255 - (Evade * 2) + 1, Mag Def, 255 - (MBlock * 2) + 1
	]]
	local rawValues = rawValues or false

	local pulledValues = GetBattleActorData(
		partySlot,
		2,
		{
			-- Level, CurHP (2), MaxHP (2), CurMP(2), MaxMP(2),
			0x3B18,	0x3BF4, 0x3BF5, 0x3C1C, 0x3C1D, 0x3C08, 0x3C09, 0x3C30, 0x3C31,
			-- Vigor * 2, Speed, Stamina, Mag Pwr, Bat Pwr (2, Main Hand + Off Hand)
			0x3B2C, 0x3B19, 0x3B40, 0x3B41, 0x3B68, 0x3B69,
			-- Defense, 255 - (Evade * 2) + 1, Mag Def, 255 - (MBlock * 2) + 1
			0x3BB8, 0x3B54, 0x3BB9, 0x3B55
		}
	)

	local values = {
		pulledValues[1],
		pulledValues[2] + pulledValues[3] * 256,
		pulledValues[4] + pulledValues[5] * 256,
		pulledValues[6] + pulledValues[7] * 256,
		pulledValues[8] + pulledValues[9] * 256,
		pulledValues[10] / 2,
		pulledValues[11], pulledValues[12], pulledValues[13],
		pulledValues[14] + pulledValues[15],
		pulledValues[16],
		(-pulledValues[17] + 256) / 2,
		pulledValues[18],
		(-pulledValues[19] + 256) / 2
	}

	--console.log(values)
	--[[
	-- Combine CurHP into one value (2 <- 3)
	pulledValues[2] = pulledValues[2] + pulledValues[3] * 256
	-- Combine MaxHP into one value (4 <- 5)
	pulledValues[4] = pulledValues[4] + pulledValues[5] * 256
	-- Combine CurMP into one value (6 <- 7)
	pulledValues[6] = pulledValues[6] + pulledValues[7] * 256
	-- Combine MaxMP into one value (8 <- 9)
	pulledValues[8] = pulledValues[8] + pulledValues[9] * 256
	
	-- Set Vigor to actual value (10)
	pulledValues[10] = pulledValues[10] / 2
	-- Set Mag.Pwr to actual value (Seem to be normal)
	-- Combine Main + OffHand Bat Pwrs
	pulledValues[14] = pulledValues[14] + pulledValues[15]
	-- Set Evade to actual value (17)
	pulledValues[17] = (-pulledValues[17] + 256) / 2
	-- Set MBlock to actual value (19)
	pulledValues[19] = (-pulledValues[19] + 256) / 2

	console.log(values)
	-- Remove extra values
	table.remove(values, 3)
	table.remove(values, 4)
	table.remove(values, 5)
	table.remove(values, 6)
	console.log(values)
	]]

	if rawValues then return values end

	--return GetStringsFromList(values, List?)
end

function GetBattleActorStatuses(partySlot, rawValues)
	local rawValues = rawValues or false

	local values = GetBattleActorData(
		partySlot,
		2,
		{
			0x3EE4,
			0x3EE5,
			0x3EF8,
			0x3EF9
		}
	)

	if rawValues then return values end

	return GetStringsFromList(values, battleStatusList)
end

function GetBattleActorElems(partySlot, rawValues)
	--[[
		$3BCC Absorbed Elements
        $3BCD Immune Elements
        $3BE0 Weak Elements
		$3BE1 Halved Elements
	]]
	local rawValues = rawValues or false

	local values = GetBattleActorData(
		partySlot,
		2,
		{
			0x3BCC,
			0x3BCD,
			0x3BE0,
			0x3BE1
		}
	)

	if rawValues then return values end

	return GetStringsFromList(values, elemList)
end

function GetBattleActorEquipment(partySlot, rawValues)
	local rawValues = rawValues or false

	local handAndRelicValues = GetBattleActorData(
		partySlot,
		2,
		{
			0x3CA8,
			0x3CA9,
			0x3CD0,
			0x3CD1
		}
	)

	local helmAndArmorValues = {
		GetActorEquipByID(mainmemory.read_u8(0x3ED8 + (0x02 * partySlot)), 2, true),
		GetActorEquipByID(mainmemory.read_u8(0x3ED8 + (0x02 * partySlot)), 3, true)
	}

	local values = {
		handAndRelicValues[1],
		handAndRelicValues[2],
		helmAndArmorValues[1],
		helmAndArmorValues[2],
		handAndRelicValues[3],
		handAndRelicValues[4]
	}

	if rawValues then return values end

	local strings = {}
	for i=1, #values, 1 do
		strings[i] = GetItemName(values[i])
	end

	return strings
end

function GetBattleActorBlockTypes(partySlot, rawValues)
	local rawValues = rawValues or false

	local values = GetBattleActorData(
		partySlot,
		2,
		{
			0x3CE4,
			0x3CE5
		}
	)

	--Filter out Block Type
	values[1] = bit.band(values[1], 0x0F)
	values[2] = bit.band(values[2], 0x0F)
	if rawValues then return values end

	local allStrings, physStrings, magStrings = {}
	physStrings = GetStringsFromList(values[1], blockTypeList)
	magStrings = GetStringsFromList(values[2], blockTypeList)
	for i=1, #physStrings, 1 do 
		allStrings[#allStrings + 1] = physStrings[i]
	end
	for i=1, #magStrings, 1 do 
		allStrings[#allStrings + 1] = magStrings[i]
	end

	return allStrings
end

function GetBattleCantRun()
	return bit.check(mainmemory.read_u8(0x00B1), 2)
end

function GetBattleGolemHP()
	return mainmemory.read_u16_le(0x3A36)
end

function GetBattleElemsNulled()
	return mainmemory.read_u8(0x3EC8)
end

function GetNumEnemiesAlive()
	return mainmemory.read_u8(0x3A77)
end

function GetBattleDialogID()
	return mainmemory.read_u24_le(0x88D7)
end

function GetStealMorphItemID()
	return mainmemory.read_u8(0x32F4)
end

function GetCurrentBattleCommand()
	return mainmemory.read_u8(0x3A7A)
end

function GetBattleMsgVariable(varID, bitmask)
	local value = mainmemory.read_u24_le(0x2F35 + (varID * 3))

	if bitmask ~= nil then
		return bit.band(value, bitmask)
	end

	return value
end

function GetBattleInventory()
	-- $2686-$2B85 Battle Inventory (256 + 8 items, 5 bytes each)
	-- $2686 Item Index
	-- $2689 Item Quantity
	local items = {}
	local quantities = {}
	local itemID = 0xFF
	for i=0, 255, 1 do
		itemID = mainmemory.read_u8(0x2686 + (i * 0x05))
		if itemID ~= 0xFF then
			items[#items+1] = itemID
			quantities[#quantities+1] = mainmemory.read_u8(0x2689 + (i * 0x05))
		end
	end

	return items, quantities
end


------- SPELL FUNCTIONS ---------------------------------------------



------- ENEMY FUNCTIONS ---------------------------------------------
--[[
function GetInfoOnEnemies()
    require 'Enemy Data'
    require 'Item Data'

	--console.clear()

	for i=1, 4, 1 do
		local enemyID = mainmemory.read_u16_le(0x00200D + ((i - 1) * 2))
		
		if enemyID ~= 0xFFFF then
			console.log("EnemyID: 0x" .. bizstring.hex(enemyID)) -- DEBUG
			GetEnemyInfo(enemyID)
			console.log("-------------------------------------")
		end
	end

	console.log("-------------------------------------")

end
]]

