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


local oldItemID = 0xFF
local curItemID = 0xFF
local onEmuDisplay = false --true
-- ------------- MAIN LOOP ----------------------------------------------------
while true do
	-- Menu on Field
	local menuOnField = mainmemory.read_u8(0x59)
	--gui.text(10, 10, "menuOnField: " .. bizstring.hex(menuOnField))

	local menuState = mainmemory.read_u8(0x26)
	--gui.text(10, 10, "Menu: " .. bizstring.hex(menuState))
	local pos = mainmemory.read_u8(0x4B)

	if menuOnField ~= 0x00 then 
		if menuState == 0x08 then -- Item Menu
			oldItemID = curItemID
			curItemID = mainmemory.read_u8(0x1869 + pos)

			if curItemID ~= oldItemID then
				UpdateItemDisplay(curItemID)
				
			end
		elseif menuState == 0x55 or menuState == 0x56 then -- Equip -> Equip/Remove
			--gui.text(10, 30, "Pos: " .. pos)
			charPointer = mainmemory.read_u16_le(0x67) --mainmemory.read_u8(0x28)
			--gui.text(10, 50, "charPointer?: " .. charPointer)
			atCharPointer = mainmemory.read_u8(charPointer)
			--gui.text(10, 70, "atCharPointer?: " .. atCharPointer)
			--gui.text(10, 30, mainmemory.read_u16_le(0x67))
			oldItemID = curItemID
			curItemID = mainmemory.read_u8(0x1600 + (atCharPointer * 0x25) + 0x1F + pos)
			--curItemID = mainmemory.read_u8(atCharPointer + pos)

			if curItemID ~= oldItemID then
				UpdateItemDisplay(curItemID)
				
			end
		elseif menuState == 0x57 or menuState == 0x5B or menuState == 0x5C then -- Equip Choose or Relic Choose/Remove
			--gui.text(10, 30, "Pos: " .. pos)
			pointer = mainmemory.read_u8(0x9D8A + pos)
			--gui.text(10, 50, "pointer?: " .. pointer)
			--atCharPointer = mainmemory.read_u8(charPointer)
			--gui.text(10, 70, "atCharPointer?: " .. atCharPointer)
			--gui.text(10, 30, mainmemory.read_u16_le(0x67))
			oldItemID = curItemID
			curItemID = mainmemory.read_u8(0x1869 + pointer)
			--curItemID = mainmemory.read_u8(atCharPointer + pos)

			if curItemID ~= oldItemID then
				UpdateItemDisplay(curItemID)
				
			end
		elseif menuState == 0x5A then -- Relic Menu (Char Relics)
			--gui.text(10, 30, "Pos: " .. pos)
			charPointer = mainmemory.read_u16_le(0x67) --mainmemory.read_u8(0x28)
			--gui.text(10, 50, "charPointer?: " .. charPointer)
			atCharPointer = mainmemory.read_u8(charPointer)
			--gui.text(10, 70, "atCharPointer?: " .. atCharPointer)
			--gui.text(10, 30, mainmemory.read_u16_le(0x67))
			oldItemID = curItemID
			curItemID = mainmemory.read_u8(0x1600 + (atCharPointer * 0x25) + 0x23 + pos)
			--curItemID = mainmemory.read_u8(atCharPointer + pos)

			if curItemID ~= oldItemID then
				UpdateItemDisplay(curItemID)
				
			end
		else
			oldItemID = 0xFF
			curItemID = 0xFF
			ClearDisplay()
		end
	end
	
	if onEmuDisplay then
	
		-- Cursor Position on Item List ----------------
		
		--gui.text(20, 20, "Pos: " .. pos)

		-- Item ID -----------------
		
		--gui.text(20, 40, "Item ID: " ..  curItemID)

		
		
	end

	emu.frameadvance()
end


function RemoveItemCheck()
	
end