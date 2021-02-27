local globalsButton

function DrawNavButtons()
    DrawButton(32, 404, "Global", 112, 32)
    DrawButton(176, 404, "Items", 96, 32)
    DrawButton(304, 404, "1", 32, 32)
    DrawButton(352, 404, "2", 32, 32) -------
    DrawButton(398, 404, "3", 32, 32)
    DrawButton(446, 404, "4", 32, 32)
end

function DrawItemListButtons()
    DrawButton(20, 356, "<", 32, 32)
    DrawButton(68, 356, ">", 32, 32)
end

--------------------------------------------------------------------
-- Item Data Draw Commands -----------------------------------------
function DrawItemName(itemID, x, y, color)
    local symbolValue = GetItemSymbolValue(itemID)
    -- Draw Symbol and Offset X for Text
    if symbolValue >= 0xD8 and symbolValue <= 0xE7 then
        DrawItemSymbol(symbolValue - 0xD8, x, y)
        x = x + 14
    end

    DrawText(GetItemName(itemID), x, y, color)
end

function DrawItemSpellLearned(itemID, x, y)
    local spellID, spellRate = GetItemSpellLearned(itemID, true)
    local rateText = " *" .. PadLeft(tostring(spellRate), 2, " ")

    local symbolValue = GetSpellSymbolValue(spellID)
    if symbolValue >= 0xE8 and symbolValue <= 0xEA then
        DrawMagicSymbol(symbolValue - 0xE8, x, y)

        x = x + 14
    end

    DrawText(GetSpellName(spellID) .. rateText, x, y)
end

function DrawItemProc(itemID, x, y)
    local spellID = GetItemProcSpell(itemID, true)
    local spellText = GetItemProcSpell(itemID)

    -- Draw Spell Symbol
    if spellID < 0x36 then
        local symbolValue = GetSpellSymbolValue(spellID)
        if symbolValue >= 0xE8 and symbolValue <= 0xEA then
            DrawMagicSymbol(symbolValue - 0xE8, x, y)

            x = x + 14
        end
    end

    DrawText(spellText, x, y, yellow)
end

function DrawElements(elems, x, y)
    local moveX = 24

    for i=8, 0, -1 do 
        if bit.check(elems, i) then
            DrawElementSymbol(i, x + ((7 - i) * moveX), y)
        end
    end
end

function DrawWeaponElement(elem, x, y)
    local moveX = 24

    for i=8, 0, -1 do 
        if bit.check(elem, i) then
            DrawElementSymbol(i, x + ((7 - i) + moveX), y)

            moveX = moveX + 24
        end
    end
end

function DrawProtections(prots, x, y)
    for iSet=0, 1, 1 do 
        for iStatus=0, 7, 1 do
            if bit.check(prots[iSet+1], iStatus) then
                DrawItemStatusSymbol(
                    iSet, iStatus,
                    x + (iStatus * 28) + (iSet * (8 * 28)), y
                )
            end
        end
    end
end

function DrawAutoStatuses(auto, x, y)
    for iStatus=0, 7, 1 do
        if bit.check(auto, iStatus) then
            DrawItemStatusSymbol(2, iStatus, x + (iStatus * 48), y)
        end
    end
end

function DrawSpecialStatuses(special, x, y)
    for iStatus=0, 7, 1 do
        if bit.check(special, iStatus) then
            DrawItemStatusSymbol(1, iStatus, x + (iStatus * 48), y)
        end
    end
end

function ReorganizeEffectStrings(effectStrings)
    CheckCommandChangeNames()

    local returnStrings = {}
    for i=1, 8, 1 do
        returnStrings[i] = {}
    end

    returnStrings[1][1] = effectStrings[1][1] --PA/HP
    returnStrings[1][2] = effectStrings[1][5]
    returnStrings[1][3] = effectStrings[1][3]
    returnStrings[1][4] = effectStrings[1][4]

    returnStrings[2][1] = effectStrings[1][2] --MA/MP
    returnStrings[2][2] = effectStrings[1][8]
    returnStrings[2][3] = effectStrings[1][6]
    returnStrings[2][4] = effectStrings[1][7]

    returnStrings[3][1] = effectStrings[3][1] -- Better Steal/Control/Sketch, Super Jump
    returnStrings[3][2] = effectStrings[2][8]
    returnStrings[3][3] = effectStrings[3][3]
    returnStrings[3][4] = effectStrings[3][4]
    
    returnStrings[4][1] = effectStrings[3][8] -- Phys
    returnStrings[4][2] = effectStrings[3][5]
    returnStrings[4][3] = effectStrings[4][2]
    returnStrings[4][4] = effectStrings[4][3]

    returnStrings[5][1] = effectStrings[3][6] -- MP Cost/Step Regen/Rev Cure
    returnStrings[5][2] = effectStrings[3][7]
    returnStrings[5][3] = effectStrings[4][8]
    returnStrings[5][4] = effectStrings[5][8]
    
    returnStrings[6][1] = effectStrings[4][4] -- Equip/X-Fight
    returnStrings[6][2] = effectStrings[4][5]
    returnStrings[6][3] = effectStrings[4][6]
    returnStrings[6][4] = effectStrings[4][1]

    returnStrings[7][1] = effectStrings[2][1] -- Battle
    returnStrings[7][2] = effectStrings[2][2]
    returnStrings[7][3] = effectStrings[5][4]
    returnStrings[7][4] = effectStrings[5][5]
    
    returnStrings[8][1] = effectStrings[4][7] -- Status
    returnStrings[8][2] = effectStrings[5][2]
    returnStrings[8][3] = effectStrings[5][1]
    returnStrings[8][4] = effectStrings[5][3]

    --[[
    local returnTable = {}
    for x=1, 8, 1 do
        returnTable[x] = {}
        for y=1, 4, 1 do
            returnTable[x][y] = returnStrings[y][x]
        end
    end
    

    return returnTable
    ]]
    return returnStrings
end

function DrawBlockTypeSymbols(blockType, x, y, xPadding)
    local xPadding = xPadding or 16
    local drawX = x
    --local drawY = y

    for i=0, 4, 1 do
        if bit.check(blockType, i) then
            local symbolID = i
            if i == 2 then --Shield
                symbolID = 10
            elseif i == 3 then --Cape (Relic Icon)
                symbolID = 15
            end
            DrawItemSymbol(symbolID, drawX, y)
        end

        drawX = drawX + xPadding
    end
end


-----------------------------------------------------------------

function DrawItemDisplay(itemID)
    --console.log("Item Display Drawn: " .. bizstring.hex(itemID))

    ClearWindow()

    -- Draw Nothing if No Item
    if itemID == 0xFF then
        DrawWindow()
        return
    end

    DrawItemName(itemID, 8, 8, lightBlue)

    local itemType = GetItemType(itemID, true)

    -- DEBUG - Draw Raw Data -----------
    --SetMultiLines("Raw Data:", GetAllItemRawData(itemID), 16, " ")

    -- Learn Spell ---------------------------
    if DoesItemTeachSpell(itemID) then
        DrawItemSpellLearned(itemID, 304, 8)
    end

    -- Weapon Properties ---------------------
    if itemType == 0x01 then 
        -- Weapon Element -------------
        local elem = GetWeaponElements(itemID, true)
        DrawWeaponElement(elem, 216, 4)

        -- Attack Proc ----------------
        if DoesItemProc(itemID) then
            DrawItemProc(itemID, 24, 32)
        end

        -- Weapon Special -------------
        local wSpecial = GetWeaponSpecialAbility(itemID)
        if wSpecial ~= "" then DrawText(wSpecial, 272, 32) end

        -- General Properties ---------
        local wProps = GetItemWeaponProperties(itemID)
        if next(wProps) ~= nil then DrawTableAsTextLine(wProps, 8, 56, " ") end
    end

    -- Armor/Relic Properties (Elements)--------------------------
    if itemType >= 0x02 and itemType <= 0x05 then
        local elemAbs = GetItemAbsorbElements(itemID, true)
        DrawText("Abs", 8, 32, lightBlue)
        if elemAbs ~= 0x00 then
            DrawElements(elemAbs, 64, 28)
        end

        local elemNull = GetItemNullElements(itemID, true)
        DrawText("Nul", 260, 32, lightBlue)
        if elemNull ~= 0x00 then
            DrawElements(elemNull, 316, 28)
        end

        local elemHalf = GetItemHalvedElements(itemID, true)
        DrawText("1/2", 8, 56, lightBlue)
        if elemHalf ~= 0x00 then
            DrawElements(elemHalf, 64, 52)
        end

        DrawText("Wek", 260, 56, lightBlue)
        local elemWeak = GetItemWeakElements(itemID, true)
        if elemWeak ~= 0x00 then
            DrawElements(elemWeak, 316, 52)
        end
    end
    
    -- Any Equips ----------------------
    if itemType >= 0x01 and itemType <= 0x05 then
        -- Field Effects -------------------------
        local fieldEffects = GetItemFieldEffects(itemID)
        DrawText("Field:", 8, 80, lightBlue)
        DrawTableAsTextLine(fieldEffects, 128, 80, " ")

        -- Protections ----------------------
        local protections = GetItemStatusProtection(itemID, true)
        DrawText("No:", 8, 104, lightBlue)
        if protections[1] + protections[2] ~= 0x00 then
            DrawProtections(protections, 60, 100)
        end

        -- Statuses ------------------------------
        local statuses = GetItemStatusEffects(itemID, true)
        DrawText("Auto:", 8, 128, lightBlue)
        if statuses ~= 0x00 then
            DrawAutoStatuses(statuses, 120, 124)
        end

        -- Special Statuses ---------------------------
        local specStatuses = GetItemSpecialStatus(itemID, true)
        DrawText("Other:", 8, 152, lightBlue)
        if specStatuses ~= 0x00 then
            DrawSpecialStatuses(specStatuses, 120, 148)
        end

        -- Special Effects ------------------------------
        local specEffects = GetItemSpecialEffects(itemID, true)
        local allEffectWords = GetItemSpecialEffects(itemID)
        local sortedEffectWords = ReorganizeEffectStrings(allEffectWords)
        effectTotal = specEffects[1] + specEffects[2] + specEffects[3] + specEffects[4] + specEffects[5]
        if effectTotal ~= 0x00 then
            for i=1, #sortedEffectWords, 1 do
                --console.log("sorted table[i] (len = " .. #sortedEffectWords .. "):")
                --console.log(sortedEffectWords[i])
                DrawTableAsTextLine(sortedEffectWords[i], 8, 156 + i * 20, "  ")
            end

            -- Command Change
            local cc = ""
            for i=0, 4, 1 do
                if allEffectWords[2][3 + i] ~= "      " then
                    cc = allEffectWords[2][3 + i] 
                end
            end
            DrawText(cc, 8, 342)
        end

        -- Equipped by ---------------------------------
        local equips = GetItemEquipableActors(itemID, true)
        DrawText("Can be used by:", 8, 368, lightBlue)
        DrawText(equips[1] .. "  " .. equips[2], 271, 368)
        for iRow=0, 2, 1 do
            local equipRow = {}
            for iEquip=0, 3, 1 do
                equipRow[iEquip+1] = equips[3 + iRow * 4 + iEquip]
            end

            DrawTableAsTextLine(equipRow, 8, 388 + (iRow * 20), "  ")
        end
    end

    DrawWindow()
end

---- STILL NEED TO UPDATE v -----------------------------------------------------------
-- Party Info Draw Commands ----------------------------------------------
function DrawActorStatuses(statuses, x, y)
    for iByte=0, 3, 1 do
        for iBit=0, 7, 1 do
            if bit.check(statuses[iByte + 1], iBit) then
                drawCanvas.DrawImageRegion(
                    imagePath .. battleStatusFileName,
                    iBit * 24, iByte * 24, 24, 24,
                    x + (iBit * 28), y + (iByte * 32)
                )
            end
        end
    end
end

function DrawActorElements(elems, x, y)
    for i=8, 0, -1 do 
        if bit.check(elems, i) then
            drawCanvas.DrawImageRegion(imagePath .. elemFileName,
                i * 24, 0, 24, 24,
                x + ((7 - i) * 26), y
            )
        end
    end
end

function GetActorBlockString(blockTypeValue)
    local bigString = ""
    for i=0, 4, 1 do
        if bit.check(blockTypeValue, i) then
            bigString = bigString .. blockTypeList[i+1] .. " "
        else
            bigString = bigString .. "   "
        end
    end

    return bigString
end

--------------------------------------------------------------------------
--[[ 
function DrawBattleActorDisplay(partySlot, stats, statuses, elems, equipment, blockTypes)
    --console.log("DRAW ACTOR IN SLOT " .. tostring(partySlot + 1))

    ClearWindow()

    -- Name
    SetItemDataLine(GetBattleActorName(partySlot), 8, 8, "", 0, 0) --

    -- Slot
    SetItemDataLine("", 0, 0, partySlot + 1, 128, 8)

    -- Block Types (Ev/MEv)

    DrawItemSymbol(10, 168, 8) 
    SetItemDataLine("P:", 184, 8, "", 0, 0)
    DrawBlockTypeSymbols(blockTypes[1], 224, 8, 24) --
    DrawItemSymbol(10, 344, 8) 
    SetItemDataLine("M:", 360, 8, "", 0, 0)
    DrawBlockTypeSymbols(blockTypes[2], 400, 8, 24)

    -- Stats ---------------------------------------------------
    SetItemDataLine("Lv", 8, 32, PadLeft(stats[1], 2, " "), 52, 32)
    SetItemDataLine("HP", 100, 32,
        PadLeft(stats[2], 4, " ") .. "/" .. PadLeft(stats[3], 4, " "), 148, 32)
    SetItemDataLine("MP", 308, 32,
    PadLeft(stats[4], 4, " ") .. "/" .. PadLeft(stats[5], 4, " "), 356, 32)

    SetItemDataLine("Vigor", 8, 80, PadLeft(stats[6], 3, " "), 168, 80)
    SetItemDataLine("Speed", 8, 104, PadLeft(stats[7], 3, " "), 168, 104)
    SetItemDataLine("Stamina", 8, 128, PadLeft(stats[8], 3, " "), 168, 128)
    SetItemDataLine("Mag.Pwr", 8, 152, PadLeft(stats[9], 3, " "), 168, 152)
    
    SetItemDataLine("Bat.Pwr", 248, 56, PadLeft(stats[10], 3, " "), 408, 56)
    SetItemDataLine("Defense", 248, 80, PadLeft(stats[11], 3, " "), 408, 80)
    SetItemDataLine("Evade %", 248, 104, PadLeft(stats[12], 3, " "), 408, 104)
    SetItemDataLine("Mag.Def", 248, 128, PadLeft(stats[13], 3, " "), 408, 128)
    SetItemDataLine("MBlock %", 248, 152, PadLeft(stats[14], 3, " "), 408, 152)
    
    -- Statuses ---------------------------------------------------
    DrawActorStatuses(statuses, 8, 176)
    
    -- Elems ---------------------------------------------------
    SetItemDataLine("Abs", 248, 180, "", 0, 0)
    DrawActorElements(elems[1], 302, 176)
    SetItemDataLine("Nul", 248, 212, "", 0, 0)
    DrawActorElements(elems[2], 302, 208)
    SetItemDataLine("1/2", 248, 244, "", 0, 0)
    DrawActorElements(elems[3], 302, 240)
    SetItemDataLine("Wek", 248, 276, "", 0, 0)
    DrawActorElements(elems[4], 302, 272)
    
    -- Equipment -------------------------------------------------
    SetItemDataLine("Equipment", 8, 300, "", 0, 0)
    DrawItemName(equipment[1], 8, 324)
    DrawItemName(equipment[2], 284, 324)
    DrawItemName(equipment[3], 8, 348)
    DrawItemName(equipment[4], 284, 348)
    DrawItemName(equipment[5], 8, 372)
    DrawItemName(equipment[6], 284, 372)

    -- Buttons ---------------------------------------------------
    DrawNavButtons()

    DrawLines()




end

function DrawBattleGlobalsDisplay(cantRunFlag, golemHP, forcefieldNulls)
    ClearWindow()

    SetItemDataLine("GLOBALS", 8, 8, "", 0, 0)
    
    -- Can Run? -----------------------------------------------
    local runText = "Yes"
    if cantRunFlag then runText = " No" end
    SetItemDataLine("Can Run?:", 8, 56, runText, 168, 56) --

    -- Golem HP -----------------------------------------------
    SetItemDataLine("Golem HP:", 8, 80, PadLeft(tostring(golemHP), 4, " "), 168, 80) --

    -- Forcefield Nulls ------------------------------------------
    SetItemDataLine("Elems Nullified:", 8, 104, "", 0, 0)
    DrawElements(forcefieldNulls, 280, 102) -- 

    -- Buttons ---------------------------------------------------
    DrawNavButtons()

    DrawLines()
end

local page = 1
local pageMax = 1
local maxItemsDrawn = 15

function DrawBattleInventory(items, quantities)
    ClearWindow()

    pageMax = math.ceil((#items + 1) / maxItemsDrawn) -- + 1 so empty space is guaranteed
    if pageMax > 17 then pageMax = 17 end --17 pages = 255 items
    if page > pageMax then page = pageMax end --in case # of items/pages change between battles

    SetItemDataLine("ITEMS", 8, 8, "", 0, 0)
    SetItemDataLine(
        "Pg:", 184, 8,
        PadLeft(tostring(page), 2, " ") .. "/" .. PadLeft(tostring(pageMax), 2, " ") , 246, 8
    )
    SetItemDataLine("", 0, 0, PadLeft(tostring(#items), 3, " "), 456, 8) --

    local listX = 124
    local listY = 36
    local spacingY = 24
    local drawX = listX
    local drawY = listY
    local numItemsToDraw = maxItemsDrawn
    if numItemsToDraw > #items then numItemsToDraw = #items end
    local itemIndexToDraw
    local itemName
    local symbolCharValue
    for i=1, numItemsToDraw, 1 do
        itemIndexToDraw = (page-1) * numItemsToDraw + i
        if itemIndexToDraw <= #items then
            
            itemName = GetItemName(items[itemIndexToDraw])
            -- Take initial space off item names that have it
            if string.sub(itemName, 1, 1) == " " then
                itemName = string.sub(itemName, 2)
            else -- Items has a symbol
                symbolCharValue = GetItemSymbolValue(items[itemIndexToDraw])
                if symbolCharValue >= 0xD8 then
                    DrawItemSymbol(symbolCharValue - 0xD8, drawX, drawY)
                    drawX = drawX + 14
                end
            end

            SetItemDataLine("", 0, 0,
                PadRight(GetItemName(items[itemIndexToDraw]), 12, " ") .. ":" ..
                    PadLeft(quantities[itemIndexToDraw], 2, " "),
                drawX, drawY
            )

            drawX = listX
            drawY = drawY + spacingY
        end
    end
    

    -- Buttons ---------------------------------------------------
    DrawNavButtons()
    DrawItemListButtons()

    DrawLines()
end

function ChangeInventoryPage(amount)
    page = page + amount

    if page < 1 then page = pageMax end
    if page > pageMax then page = 1 end
end

]]

