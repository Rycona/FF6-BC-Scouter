console.clear()

Utils = loadfile("Utils.lua")
Utils()
Constants = loadfile("Constants.lua")
Constants()
Display = loadfile("Display.lua")
Display()
Item = loadfile("Item Data.lua")
Item()
--Enemy = loadfile("Enemy Data.lua")
--Enemy()
Spell = loadfile("Spell Data.lua")
Spell()
Actor = loadfile("Actor Data.lua")
Actor()


CreateDisplay()


-- Input ---------------------------------------
--[[
local itemIDAvailable = {} -- array of items seen (to prevent seeing new info in shops)
Read/Write file with ROM name to track what items have been worn/in inventory for info access (For Shop Buy)
	]]
local input1, input2

function IsBButtonPressed()
	if bit.check(input1, 6) then return true end

	return false
end

function IsXButtonPressed()
	if bit.check(input1, 6) then return true end

	return false
end

-- Items ------------------------------------------------------------
local curItemID = 0xFF
local oldItemID = 0xFF
local charPointer, charID, cursorPos

function GetItemIDFromItemMenuList()
	return mainmemory.read_u8(0x1869 + cursorPos)
end

function GetItemIDFromEquipRelicList()
	charPointer = mainmemory.read_u8(0x9D8A + cursorPos)
	return mainmemory.read_u8(0x1869 + charPointer)
end

function GetItemIDFromCharEquip()
	charPointer = mainmemory.read_u16_le(0x67)
	charID = mainmemory.read_u8(charPointer)
	return mainmemory.read_u8(0x1600 + (charID * 0x25) + 0x1F + cursorPos)
end

function GetItemIDFromCharRelic()
	charPointer = mainmemory.read_u16_le(0x67)
	charID = mainmemory.read_u8(charPointer)
	return mainmemory.read_u8(0x1600 + (charID * 0x25) + 0x23 + cursorPos)
end

function GetItemIDFromShopBuy(shopIndex)
	return memory.read_u8(0x047AC0 + 0x01 + (shopIndex * 0x09) + cursorPos, "CARTROM")
end

-- Menus (Item, Equip, Relic, Shop) ---------------------------------
local curMenuID
local isMenuOrShopOpen = false
--local shopIndex
local isDrawingMenuItem

function IsMenuOpen()
	if (mainmemory.read_u8(0x59) ~= 0x00) then return true end

	return false
end 

function IsOnItemMenuList()
	if curMenuID == 0x08 or curMenuID == 0x19 or curMenuID == 0x64 or curMenuID == 0x5E then
		isDrawingMenuItem = true
		return true
	end

	return false
end

function IsOnEquipOrRelicMenuList()
	if curMenuID == 0x57 or	curMenuID == 0x5B then
		isDrawingMenuItem = true
		return true
	end

	return false
end 

function IsOnCharEquip()
	if curMenuID == 0x55 or curMenuID == 0x56 then
		isDrawingMenuItem = true
		return true
	end

	return false
end

function IsOnCharRelic()
	if curMenuID == 0x5A or curMenuID == 0x5C then
		isDrawingMenuItem = true
		return true
	end

	return false
end

function IsOnShopBuyMenu()
	if curMenuID == 0x26 or curMenuID == 0x27 then
		isDrawingMenuItem = true
		return true
	end

	return false
end

function IsOnShopSellMenu()
	if curMenuID == 0x29 or curMenuID == 0x2A then
		isDrawingMenuItem = true
		return true
	end

	return false
end

-- Frame Delay (to prevent flickering of item info) -----------------------------
local frameDelayMenu = 0
local numFramesForDelay = 3
local framesDelayed = 0
local isDelayFinished = false

function CheckFrameDelay(menuIndex)
	if menuIndex == frameDelayMenu then
		if isDelayFinished then return end

		framesDelayed = framesDelayed + 1

		if framesDelayed == numFramesForDelay then isDelayFinished = true end
	else -- i.e, New Menu
		SetNewFrameDelay(menuIndex)
	end
end

function SetNewFrameDelay(menuIndex)
	frameDelayMenu = menuIndex
	isDelayFinished = false
	framesDelayed = 0
end

function ResetFrameDelay()
	isDelayFinished = false
	framesDelayed = 0
	frameDelayMenu = 0
end

-- Battle -----------------------------------------------------------------------
local curNumEnemiesAlive = 0xFF
local oldNumEnemiesAlive = curNumEnemiesAlive
local hasEnteredBattle = false
local battleVariable1 = mainmemory.read_u24_le(0x2F35)
local battleVariable2 = mainmemory.read_u24_le(0x2F38)
local battleDialogID = mainmemory.read_u24_le(0x88D7)

function CheckForBattle()
	if curNumEnemiesAlive ~= 0xFF and curNumEnemiesAlive > 0 then
		hasEnteredBattle = true
	end
end

function IsDropItemDialogLoading()
	if battleDialogID == 0xD1F258 or battleDialogID == 0xD1F264 then
		--console.log("Drop Item Dialog")
		battleVariable1 = mainmemory.read_u24_le(0x2F35)
		battleVariable2 = mainmemory.read_u24_le(0x2F38)
		return true
	end

	return false
end

function IsMorphItemDialogLoading()
	if battleDialogID == 0xD1F22A then return true end

	return false
end

function IsStealItemDialogLoading()
	if battleDialogID == 0xD1F031 then return true end

	return false
end

function IsGoldDialogLoading()
	if battleDialogID == 0xD1F2A8 then return true end

	return false
end

-- Steal / Metamorphosis ----------------------
local curStealMorphItemID = 0xFF
local oldStealMorphItemID = 0xFF
local checkStealMorphItemID = 0xFF
local drawStealMorphFrameDelay = 300
local curDrawStealMorphFrameDelay = 0
local ignoreFirstDropChange = false
local curCommandIndex = mainmemory.read_u8(0x3A7A)
local oldCommandIndex = curCommandIndex
local isMorphingOrStealingItem = false

function IsFightingBattle()
	if curNumEnemiesAlive ~= 0xFF and curNumEnemiesAlive > 0 then return true end

	return false
end

function IfStealMorphItemIDChanges()
	if curStealMorphItemID ~= oldStealMorphItemID then return true end

	return false
end

function StartStealMorphDrawFrames()
	curDrawStealMorphFrameDelay = drawStealMorphFrameDelay
end

function UpdateStealMorphDrawFrames()
	curDrawStealMorphFrameDelay = curDrawStealMorphFrameDelay - 1
end

function DrawStealMorphItem(itemID)
	StartStealMorphDrawFrames()
	UpdateItemDisplay(itemID)
	ignoreFirstDropChange = true
end

-- Enemy Drops -------------------------------------
local curDropItemID = mainmemory.read_u8(0x2E72)
local oldDropItemID = curDropItemID
local isDrawingDrop = false

function IsAtEndOfBattle()
	if curNumEnemiesAlive == 0 and oldNumEnemiesAlive ~= 0xFF then return true end

	return false
end

function IfDropItemChanges()
	if curDropItemID ~= oldDropItemID then return true end

	return false
end

function DrawDropItem(itemID)
	isDrawingDrop = true
	UpdateItemDisplay(itemID)
end

function StopDrawingDropItem()
	isDrawingDrop = false
	ResetDisplay()
end

-- Treasure On Field -------------------------------------------------------
local curTreasureID = mainmemory.read_u8(0x0583)
local oldTreasureID = curTreasureID
local isDrawingTreasure = false
local treasurePosX, treasurePosY
local curEnableFieldDialog = mainmemory.read_u8(0xBA)
local oldEnableFieldDialog = curEnableFieldDialog
local dialogID

function IsTreasureDialogOpen()
	if curEnableFieldDialog == 0x01 and oldEnableFieldDialog == 0x00 then
		--console.log("DIALOG")
		dialogID = mainmemory.read_u16_le(0xD0)

		if dialogID == 0x0B85 then -- Treasure Dialog
			--console.log("TREASURE DIALOG")
			return true
		end
	end

	return false
end

function HasMovedOnMap()
	local curPosX = mainmemory.read_u8(0x00AF)
	local curPosY = mainmemory.read_u8(0x00B0)

	if curPosX ~= treasurePosX or curPosY ~= treasurePosY then -- Move or Menu
		return true
	end

	return false
end

function IsNotOnWorldMap()
	if mapIndex > 0x01 then return true end

	return false
end

function IfTreasureItemIndexChanges()
	if curTreasureID ~= oldTreasureID then return true end

	return false
end

function DrawTreasureItem(itemID)
	UpdateItemDisplay(itemID)
	isDrawingTreasure = true
	treasurePosX = mainmemory.read_u8(0x00AF)
	treasurePosY = mainmemory.read_u8(0x00B0)
end

function StopDrawingTreasure()
	ResetDisplay()
	isDrawingTreasure = false
end

-- MISC -------------------------------------------------------
local onEmuDisplay = false --true



function ReadRAM()
	input1 = mainmemory.read_u8(0x04)
	input2 = mainmemory.read_u8(0x05)
	curMenuID = mainmemory.read_u8(0x26)
	cursorPos = mainmemory.read_u8(0x4B)
	mapIndex = mainmemory.read_u16_le(0x82)

	oldTreasureID = curTreasureID
	curTreasureID = mainmemory.read_u8(0x0583)

	oldEnableFieldDialog = curEnableFieldDialog
	curEnableFieldDialog = mainmemory.read_u8(0xBA)

	oldNumEnemiesAlive = curNumEnemiesAlive
	curNumEnemiesAlive = mainmemory.read_u8(0x3A77)

	if not hasEnteredBattle then
		CheckForBattle()
	else
		battleDialogID = mainmemory.read_u24_le(0x88D7)
	end
end

function ResetDisplay()
	ClearDisplay()
	curItemID = 0xFF
	--displayedItemID = 0x00
end

-- ------------- MAIN LOOP ----------------------------------------------------
while true do
	
	ReadRAM()

	-- Player On Field Treasure --------------------------------------------
	if IsTreasureDialogOpen() then
		--console.log("HERE")
		if curTreasureID ~= 0xFF then
			DrawTreasureItem(curTreasureID)
		else
			ResetDisplay()
		end
	elseif isDrawingTreasure then
		if HasMovedOnMap() or IsMenuOpen() then StopDrawingTreasure() end

	-- In Battle ------------------------------------------------------------
	elseif hasEnteredBattle then
		if IsFightingBattle() then -- In a battle
			-- Steal / Metamorphosis Display ---------------
			if curDrawStealMorphFrameDelay > 0 then
				UpdateStealMorphDrawFrames()

				if curDrawStealMorphFrameDelay == 0 then ResetDisplay() end
			-- Check / Update Morphs ---------------------------
			elseif isMorphingOrStealingItem then
				
				-- Keep up if new item fills the index
				checkStealMorphItemID = mainmemory.read_u8(0x32F4)
				if (checkStealMorphItemID ~= 0xFF) then
					--oldStealMorphItemID = curStealMorphItemID
					curStealMorphItemID = checkStealMorphItemID
				end

				-- Track Command Index changes to indicate end of multi-steal/capture/Ragnarok
				oldCommandIndex = curCommandIndex
				curCommandIndex = mainmemory.read_u8(0x3A7A)

				-- After all steals/captures/Ragnaroks conclude (hopefully)
				if curCommandIndex ~= oldCommandIndex then
					--console.log("Steal/Morph Drawn")
					DrawStealMorphItem(curStealMorphItemID)
					isMorphingOrStealingItem = false
					curStealMorphItemID = 0xFF
					--oldStealMorphItemID = 0xFF
					checkStealMorphItemID = 0xFF
				end
				--[[
				if curStealMorphItemID == 0xFF and IfStealMorphItemIDChanges() then
					--console.log("Steal/Morph Changed")
					DrawStealMorphItem(oldStealMorphItemID)
				end
				]]
			
			elseif IsMorphItemDialogLoading() or IsStealItemDialogLoading() then -- Check for new Morphs/Steals		
				--console.log("Morphin' Time!")
				isMorphingOrStealingItem = true
				curStealMorphItemID = mainmemory.read_u8(0x32F4)
				oldCommandIndex = curCommandIndex
				curCommandIndex = mainmemory.read_u8(0x3A7A)
				--oldStealMorphItemID = curStealMorphItemID
			end

			

		elseif IsAtEndOfBattle() then
			battleDialogID = mainmemory.read_u24_le(0x88D7)
			--gui.text(10, 10, "END OF BATTLE: " .. bizstring.hex(battleDialogID))
			if IsDropItemDialogLoading() then
				--console.log("DRAW DROP")
				--oldDropItemID = curDropItemID
				curDropItemID = battleVariable1
				--quantity = battleVariable2
				DrawDropItem(curDropItemID)
				
			elseif IsGoldDialogLoading() then
				StopDrawingDropItem()
			end

		elseif curNumEnemiesAlive == 0xFF then -- Return to Field
			hasEnteredBattle = false
			StopDrawingDropItem()
		end

	-- Player In Menus -----------------------------------------------------
	elseif IsMenuOpen() then
		if IsOnItemMenuList() then
			CheckFrameDelay(curMenuID)
			
			if isDelayFinished then
				oldItemID = curItemID
				curItemID = GetItemIDFromItemMenuList()

				if curItemID ~= oldItemID then UpdateItemDisplay(curItemID) end
			end

		elseif IsOnCharEquip() then -- Actor Equipment / Equip -> Remove
			CheckFrameDelay(curMenuID)

			if isDelayFinished then
				oldItemID = curItemID
				curItemID = GetItemIDFromCharEquip()

				if curItemID ~= oldItemID then UpdateItemDisplay(curItemID) end
			end

		elseif IsOnEquipOrRelicMenuList() then
			CheckFrameDelay(curMenuID)

			if isDelayFinished then
				pointer = mainmemory.read_u8(0x9D8A + cursorPos)
				oldItemID = curItemID
				curItemID = mainmemory.read_u8(0x1869 + pointer)

				if curItemID ~= oldItemID then UpdateItemDisplay(curItemID) end
			end

		elseif IsOnCharRelic() then -- Relic Menu (Char Relics)
			CheckFrameDelay(curMenuID)
			
			if isDelayFinished then
				oldItemID = curItemID
				curItemID = GetItemIDFromCharRelic()

				if curItemID ~= oldItemID then UpdateItemDisplay(curItemID) end
			end

		--[[elseif IsOnShopBuyMenu() then -- Shop Menu -> Buy (X'ed for now, because it can show new info)
			CheckFrameDelay(curMenuID)
			
			if isDelayFinished then
				shopIndex = mainmemory.read_u8(0x0201)
				--console.log("SHOP: " .. shopIndex)
				oldItemID = curItemID
				curItemID = GetItemIDFromShopBuy(shopIndex)

				if curItemID ~= oldItemID then UpdateItemDisplay(curItemID) end
			end
			]]
		elseif IsOnShopSellMenu() then -- Shop Menu -> Sell
			CheckFrameDelay(curMenuID)
			
			if isDelayFinished then
				oldItemID = curItemID	
				curItemID = GetItemIDFromItemMenuList() -- Same as Item list

				if curItemID ~= oldItemID then UpdateItemDisplay(curItemID) end
			end
		
		
		
		
		
		elseif isDrawingMenuItem then -- Was Drawing Menu Item
			ResetDisplay()
			isDrawingMenuItem = false
		end
	end

	emu.frameadvance()
end


