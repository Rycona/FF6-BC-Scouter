console.clear()

Utils = loadfile("Utils.lua")
Utils()
Constants = loadfile("Constants.lua")
Constants()
Display = loadfile("Display.lua")
Display()
Item = loadfile("Item Data.lua")
Item()
Spell = loadfile("Spell Data.lua")
Spell()
Actor = loadfile("Actor Data.lua")
Actor()
Battle = loadfile("Battle Data.lua")
Battle()
Field = loadfile("Field Data.lua")
Field()
Menu = loadfile("Menu Data.lua")
Menu()
Program = loadfile("Program Data.lua")
Program()
UI = loadfile("UI.lua")
UI()
Input = loadfile("Input.lua")
Input()

local currentRomName
local checkedRomName

local updateDisplayFlag = false
-- Check for Command Change names
local checkComamndNamesFlag = false

function CheckCommandChangeNames()
	if checkComamndNamesFlag == false then
		SetChangedCommandNames()
		checkComamndNamesFlag = true
	end
end


-- Program States -------------------------------------------------
local programState, oldProgramState
--[[
local c_World = 0
local c_Field = 1
local c_Menu = 2
local c_Battle = 3
]]


-- Items ------------------------------------------------------------
local displayedItemID = 0xFF
local queuedItemID = 0xFF

function QueueItemDisplay(itemID)
	queuedItemID = itemID
	updateDisplayFlag = true
end

-- Menu Program Variables ---------------------------------
local menuID
local cursorIndex
local actorIDPtr
local charID
local shopIndex
local numItemsOwned
local curMenuBGDesign, oldMenuBGDesign
local curMenuBGColor, oldMenuBGColor

function GetItemIDFromInventory(cursorIndex)
	return mainmemory.read_u8(0x1869 + cursorIndex)
end

function GetItemIDFromEquipRelicList(cursorIndex)
	-- List is of positions in inventory
	return GetItemIDFromInventory(mainmemory.read_u8(0x9D8A + cursorIndex))
end

function GetItemIDFromCharEquip(actorIDPtr, cursorIndex)
	return GetActorEquipByPtr(actorIDPtr, cursorIndex)
end

function GetItemIDFromCharRelic(actorIDPtr, cursorIndex)
	return GetActorEquipByPtr(actorIDPtr, cursorIndex + 4)
end

function GetItemIDFromShopBuy(shopID, cursorIndex)
	return memory.read_u8(0x047AC0 + 0x01 + (shopID * 0x09) + cursorIndex, "CARTROM")
end

function IsOnItemMenuList(menuID)
	if menuID == 0x08 or menuID == 0x19 then
		return true
	end

	return false
end

function IsOnItemMenuOptions(menuID)
	if menuID == 0x17 then return true end

	return false
end

function IsOnEquipOrRelicMenuList(menuID)
	if menuID == 0x57 or menuID == 0x5B then
		return true
	end

	return false
end 

function IsOnEquipMenuEquips(menuID)
	if menuID == 0x55 or menuID == 0x56 then
		return true
	end

	return false
end

function IsOnEquipMenuOptions(menuID)
	if menuID == 0x36 then
		return true
	end

	return false
end

function IsOnRelicMenuEquips(menuID)
	if menuID == 0x5A or menuID == 0x5C then
		return true
	end

	return false
end

function IsOnRelicMenuOptions(menuID)
	if menuID == 0x59 then
		return true
	end

	return false
end

function IsOnShopBuyMenu(menuID)
	if menuID == 0x26 or menuID == 0x27 then
		return true
	end

	return false
end

function IsOnShopSellMenu(menuID)
	if menuID == 0x29 or menuID == 0x2A then
		return true
	end

	return false
end

function IsOnShopOptions(menuID)
	if menuID == 0x25 then
		return true
	end

	return false
end

function IsOnConfigMenu(menuID)
	if menuID == 0x0E then return true end

	return false
end

function DidMenuBGChange()
	if curMenuBGDesign ~= oldMenuBGDesign or curMenuBGColor ~= oldMenuBGColor then
		return true
	end

	return false
end

-- Battle -----------------------------------------------------------------------
local curNumEnemiesAlive = 0xFF
local battleVariable1 -- = mainmemory.read_u24_le(0x2F35)
--local battleVariable2 = mainmemory.read_u24_le(0x2F38)
local battleDialogID -- = mainmemory.read_u24_le(0x88D7)

function IsFightingBattle()
	if curNumEnemiesAlive > 0 then return true end

	return false
end

function IsAtEndOfBattle()
	if curNumEnemiesAlive == 0 then return true end

	return false
end

function IsDropItemDialogLoading(battleDialogID)
	if battleDialogID == 0xD1F258 or battleDialogID == 0xD1F264 then
		return true
	end

	return false
end

function IsMorphItemDialogLoading(battleDialogID)
	if battleDialogID == 0xD1F22A then return true end

	return false
end

function IsStealItemDialogLoading(battleDialogID)
	if battleDialogID == 0xD1F031 then return true end

	return false
end

function IsGoldDialogLoading(battleDialogID)
	if battleDialogID == 0xD1F2A8 then return true end

	return false
end

-- Steal / Metamorphosis ----------------------
local curStealMorphItemID = 0xFF
local checkStealMorphItemID = 0xFF
local drawStealMorphFrameDelay = 300
local curDrawStealMorphFrameDelay = 0
local curCommandIndex = 0xFF
local oldCommandIndex = 0xFF
local isMorphingItem = false
local isStealingItem = false
local morphCommandIndexChanges = 0

function StartStealMorphDrawFrameCount()
	curDrawStealMorphFrameDelay = drawStealMorphFrameDelay
end

function UpdateStealMorphDrawFrameCount()
	curDrawStealMorphFrameDelay = curDrawStealMorphFrameDelay - 1
end

-- Enemy Drops -------------------------------------
local curDropItemID -- = mainmemory.read_u8(0x2E72)
local isDrawingDrop = false

-- Treasure On Field -------------------------------------------------------
local curTreasureID = 0xFF
local isDrawingTreasure = false
local treasurePosX, treasurePosY
local fieldDialogState
local fieldDialogID

function IsFieldDialogOpen(fieldDialogState)
	if fieldDialogState == 0x01 then return true end

	return false
end

function IsTreasureDialogOpen(fieldDialogState, dialogID)
	if IsFieldDialogOpen(fieldDialogState) and dialogID == 0x0B85 then
		return true
	end

	return false
end

function HasMovedOnMap(curPosX, curPosY)
	if curPosX ~= treasurePosX or curPosY ~= treasurePosY then
		return true
	end

	return false
end

function DrawTreasureItem(itemID)
	QueueItemDisplay(itemID)
	treasurePosX = mainmemory.read_u8(0x00AF)
	treasurePosY = mainmemory.read_u8(0x00B0)
end

function StopDrawingTreasure()
	--SetCurrentItemID(0xFF)
	QueueItemDisplay(0xFF)
end

-- Initialize -------------------------------------
local hasInitialized
function Initialize()
	CreateWindow("FF6BC Scouter - v0.31b", 512, 448)
	checkComamndNamesFlag = false
	currentRomName = gameinfo.getromname()
	curMenuBGDesign = GetMenuBGDesignID()
	oldMenuBGDesign = curMenuBGDesign
	curMenuBGColor = GetMenuBGColorARGB()
	oldMenuBGColor = curMenuBGColor

	hasInitialized = true
end

function Reinitialize()
	checkComamndNamesFlag = false
	currentRomName = checkedRomName
	curMenuBGDesign = GetMenuBGDesignID()
	oldMenuBGDesign = curMenuBGDesign
	curMenuBGColor = GetMenuBGColorARGB()
	oldMenuBGColor = curMenuBGColor
end

Initialize()

-- ------------- MAIN LOOP ----------------------------------------------------
while true do
	oldProgramState = programState
	programState = GetCurrentProgram()

	if programState ~= oldProgramState then
		--console.log("state = " .. GetProgramName(programState))
		-- No Item Displays carrying over between programs
		-- (Helps with clearing end of battle displays 
		-- 		if there's no GP dialog)
		QueueItemDisplay(0xFF)
	end
	
	if programState == c_Menu then
		-- IN MENU -------------------------------------------------------
		menuID = GetMenuID()
		cursorIndex = GetMenuCursorIndex()
		actorIDPtr = GetMenuCurActorDataPtr()

		-- Inventory Menu
		if IsOnItemMenuList(menuID) then
			QueueItemDisplay( GetItemIDFromInventory(cursorIndex) )
		elseif IsOnItemMenuOptions(menuID) then
			QueueItemDisplay(0xFF)
		-- Equip / Relic Menus
		elseif IsOnEquipMenuEquips(menuID) then
			QueueItemDisplay( GetItemIDFromCharEquip(actorIDPtr, cursorIndex) )
		elseif IsOnRelicMenuEquips(menuID) then
			QueueItemDisplay( GetItemIDFromCharRelic(actorIDPtr, cursorIndex) )
		elseif IsOnEquipOrRelicMenuList(menuID) then
			QueueItemDisplay( GetItemIDFromEquipRelicList(cursorIndex) )
		elseif IsOnEquipMenuOptions(menuID) or IsOnRelicMenuOptions(menuID) then
			QueueItemDisplay(0xFF)
		-- Shop Sell
		elseif IsOnShopSellMenu(menuID) then
			QueueItemDisplay( GetItemIDFromInventory(cursorIndex) )
		elseif IsOnShopOptions(menuID) then
			QueueItemDisplay(0xFF)
		-- Shop Buy
		elseif IsOnShopBuyMenu(menuID) then
			shopID = GetShopID()
			numItemsOwned = GetNumItemsOwnedInShop()

			if numItemsOwned > 0 then
				QueueItemDisplay(GetItemIDFromShopBuy(shopID, cursorIndex))
			else
				QueueItemDisplay(0xFF)
			end
		-- Config Menu
		elseif IsOnConfigMenu(menuID) then 
			oldMenuBGDesign = curMenuBGDesign
			curMenuBGDesign = GetMenuBGDesignID()

			oldMenuBGColor = curMenuBGColor
			curMenuBGColor = GetMenuBGColorARGB()

			if DidMenuBGChange() then
				-- Will refresh window to updated colors
				ClearWindow()
				DrawWindow()
			end
		end

	elseif programState == c_Battle then
		-- IN BATTLE -------------------------------------------------------
		curNumEnemiesAlive = GetNumEnemiesAlive()
		battleDialogID = GetBattleDialogID()

		if IsFightingBattle() then -- In a battle
			-- Steal / Metamorphosis Display ---------------
			if curDrawStealMorphFrameDelay > 0 then
				UpdateStealMorphDrawFrameCount()

				if curDrawStealMorphFrameDelay == 0 then QueueItemDisplay(0xFF) end
			-- Check / Update Morphs ---------------------------
			elseif isMorphingItem or isStealingItem then
				-- Keep up if new item fills the index
				checkStealMorphItemID = GetStealMorphItemID()
				
				if checkStealMorphItemID ~= 0xFF then
					curStealMorphItemID = checkStealMorphItemID
				end

				-- Track Command Index changes to indicate end of multi-steal/capture/Ragnarok
				oldCommandIndex = curCommandIndex
				curCommandIndex = GetCurrentBattleCommand()

				-- After all Steals/Captures/Ragnaroks conclude (hopefully)
				if curCommandIndex ~= oldCommandIndex then
					-- Ragnaroks
					if isMorphingItem then
						morphCommandIndexChanges = morphCommandIndexChanges + 1
						if morphCommandIndexChanges == 2 then
							if curStealMorphItemID ~= 0xFF then
								--console.log("MORPH SET TO DRAW")
								QueueItemDisplay(curStealMorphItemID)
								StartStealMorphDrawFrameCount()
							end

							isMorphingItem = false
							morphCommandIndexChanges = 0
						end
					-- Steals/Captures
					elseif isStealingItem then
						if curStealMorphItemID ~= 0xFF then
							--console.log("STEAL SET TO DRAW")
							QueueItemDisplay(curStealMorphItemID)
							StartStealMorphDrawFrameCount()
						end

						isStealingItem = false
					end
				end
			
			-- Check for new Morphs
			elseif IsMorphItemDialogLoading(battleDialogID) then
				--console.log("Morph Dialog")	
				isMorphingItem = true
				curStealMorphItemID = GetStealMorphItemID() -- GetBattleMsgVariable(0, 0x0000FF) -- Only first byte of the 3 is item
				curCommandIndex = GetCurrentBattleCommand()
				oldCommandIndex = curCommandIndex
			-- Check for new Steals
			elseif IsStealItemDialogLoading(battleDialogID) then
				--console.log("Steal Dialog")	
				isStealingItem = true
				curStealMorphItemID = GetStealMorphItemID() -- GetBattleMsgVariable(0, 0x0000FF) -- Only first byte of the 3 is item
				curCommandIndex = GetCurrentBattleCommand()
				oldCommandIndex = curCommandIndex
			end

		-- Check for Drops At End Of Battle -------
		elseif IsAtEndOfBattle() then
			--Check for Captures / Morphs that ended the battle
			if isStealingItem or isMorphingItem then
				QueueItemDisplay(curStealMorphItemID)
				isStealingItem = false
				isMorphingItem = false
				morphCommandIndexChanges = 0
			end

			--console.log("Battle End")
			battleDialogID = GetBattleDialogID()
			battleVariable1 = GetBattleMsgVariable(0, 0x0000FF) -- Only first byte of the 3 is item
			--battleVariable2 = mainmemory.read_u24_le(0x2F38)

			if IsDropItemDialogLoading(battleDialogID) then
				--console.log("Drop Item Dialog")
				--curDropItemID = battleVariable1
				QueueItemDisplay(battleVariable1) --QueueItemDisplay(curDropItemID)
			elseif IsGoldDialogLoading(battleDialogID) then
				QueueItemDisplay(0xFF)
			end
		end
	elseif programState == c_Field then
		-- ON FIELD --------------------------------------------
		fieldDialogState = GetFieldDialogState()
		fieldDialogID = GetFieldDialogID()
		curTreasureID = GetFieldDialogItemID()

		if IsTreasureDialogOpen(fieldDialogState, fieldDialogID) then 
			--console.log("Treasure!")
			if curTreasureID ~= 0xFF then
				QueueItemDisplay(curTreasureID)
				treasurePosX, treasurePosY = GetPartyMapPos()
				isDrawingTreasure = true
			end
		elseif isDrawingTreasure then
			--curPosX, curPosY = GetPartyMapPos()
			if HasMovedOnMap( GetPartyMapPos() ) or WasXButtonPressed() then
				StopDrawingTreasure()
			end
		end
	end

	
	
	-- Drawing / Clearing ----------------------------
	if updateDisplayFlag then
		if queuedItemID ~= displayedItemID then
			displayedItemID = queuedItemID
			DrawItemDisplay(displayedItemID)
		end

		updateDisplayFlag = false
	end

	emu.frameadvance()
end

