local drawCanvas

local descLabels = {}
local descLabelPosX = {}
local descLabelPosY = {}
local valueLabels = {}
local valueLabelPosX = {}
local valueLabelPosY = {}
local curLine = 1
local maxLines = 0
local dy = 20

local imagePath = "Images\\"
local elemFileName = "elems.png"
local statusFileName = "statuses.png"
local itemSymbolFileName = "itemTypes.png"
local spellSymbolFileName = "spellTypes.png"

local fontName = "FF6 Menu"

-- Colors (0xAARRGGBB) --------------------
local white = 0xFFFFFFFF -- Default Text
local black = 0xFF000000
local darkBlue = 0xFF3A3A94 -- Default Background
local lightBlue = 0xFF00DEDE -- Description Text
local darkGray = 0xFF7B7B7B -- Unusable Item Text
local yellow = 0xFFFFEE00 -- Proc Text
local transparent = 0x00000000 

local bGColor = darkBlue
local textColor = white

-- For OnExit() ----------------------------------------------
function CloseCanvas()
    drawCanvas.Close()
end

-- Canvas Base Commands ---------------------------------------------------
function ConvertRawColorToARGB(colorValues)
    local r = 0
    local g = 0
    local b = 0
    local colorPoints = 0

    -- red
    colorPoints = bit.band(colorValues[1], 0x1F)
    r = colorPoints * 8 + math.floor(colorPoints / 4)

    --green
    colorPoints = bit.band(colorValues[2], 0x03) * 8 + (bit.band(colorValues[1], 0xE0) / 0x20)
    g = colorPoints * 8 + math.floor(colorPoints / 4)

    --blue
    colorPoints = bit.band(colorValues[2], 0x7C) / 4
    b = colorPoints * 8 + math.floor(colorPoints / 4)

    --console.log("RGB: " .. bizstring.hex(r) .. " " .. bizstring.hex(g) .. " " .. bizstring.hex(b))
    return 0xFF000000 + r * 0x010000 + g * 0x000100 + b * 0x000001
end

function GetMenuTextColor()
    return ConvertRawColorToARGB( { mainmemory.read_u8(0x1D55), mainmemory.read_u8(0x1D56) } )
end

function GetMenuBGColor(rawValue)
    local rawValue = rawValue or false

    local windowChoiceID = bit.band(mainmemory.read_u8(0x1D4E), 0x07)
    --console.log("Window: " .. windowChoiceID)

    -- Choose color source(s) based on window design
    local colorSourceIDs
    if windowChoiceID == 0 then
        colorSourceIDs = { 6 }
    elseif windowChoiceID == 1 then
        colorSourceIDs = { 4 }
    elseif windowChoiceID == 2 then
        colorSourceIDs = { 2, 3, 4 }
    elseif windowChoiceID == 3 then
        colorSourceIDs = { 1, 2, 3 }
    elseif windowChoiceID == 4 then
        colorSourceIDs = { 1, 2, 3 }
    elseif windowChoiceID == 5 then
        colorSourceIDs = { 3, 4 }
    elseif windowChoiceID == 6 then
        colorSourceIDs = { 4 }
    elseif windowChoiceID == 7 then
        colorSourceIDs = { 0 }
    end

    local address = 0x1D57 + (windowChoiceID * 14) --+ 6 * 2

    -- Avg Colors (Rounded Up)
    local sourceColors
    local color = 0x00000000
    local r = 0
    local g = 0
    local b = 0

    if #colorSourceIDs > 1 then
        sourceColors = {}
        for i=1, #colorSourceIDs, 1 do --
            --console.log("Address: " .. bizstring.hex((address + (colorSourceIDs[i+1] * 2))))
            sourceColors[i] = ConvertRawColorToARGB(
                { mainmemory.read_u8(address + (colorSourceIDs[i] * 2)),
                mainmemory.read_u8(address + (colorSourceIDs[i] * 2) + 1) }
            )
        end

        
        for i=1, #colorSourceIDs, 1 do
            r = r + bit.band(bit.rshift(sourceColors[i], 16), 0xFF)
            g = g + bit.band(bit.rshift(sourceColors[i], 8), 0xFF)
            b = b + bit.band(sourceColors[i], 0xFF)
        end

        -- Average
        r = math.ceil(r / #colorSourceIDs)
        g = math.ceil(g / #colorSourceIDs)
        b = math.ceil(b / #colorSourceIDs)
        
    else -- only 1 color source
        color = ConvertRawColorToARGB(
            { mainmemory.read_u8(address + (colorSourceIDs[1] * 2)),
            mainmemory.read_u8(address + (colorSourceIDs[1] * 2) + 1) }
        )

        r = bit.band(bit.rshift(color, 16), 0xFF)
        g = bit.band(bit.rshift(color, 8), 0xFF)
        b = bit.band(color, 0xFF)
    end

    -- Brighten color
    r = r + 0x30
    if r > 0xFF then r = 0xFF end
    g = g + 0x30
    if g > 0xFF then g = 0xFF end
    b = b + 0x30
    if b > 0xFF then b = 0xFF end
    
    color = 0xFF000000 + r * 0x010000 + g * 0x000100 + b * 0x000001

    return color
end

function CreateDrawWindow()
    
    drawCanvas = gui.createcanvas(512, 448)
    drawCanvas.SetTitle("FF6BC Scouter - v0.3b")
    drawCanvas.Clear(GetMenuBGColor())
    drawCanvas.SetDefaultBackgroundColor(darkBlue)
    drawCanvas.SetDefaultForegroundColor(white)
    drawCanvas.SetDefaultTextBackground(transparent)
    
    ClearDisplay()

    event.onexit(CloseCanvas)    
end

function ClearDisplay()
    for i=1, maxLines, 1 do
        descLabels[i] = ""
        descLabelPosX[i] = 0
        descLabelPosY[i] = 0
        valueLabels[i] = ""
        valueLabelPosX[i] = 0
        valueLabelPosY[i] = 0
    end

    curLine = 1
    maxLines = 0
    
    bGColor = GetMenuBGColor()
    textColor = GetMenuTextColor()
    drawCanvas.Clear(bGColor)
    drawCanvas.Refresh()
end


-- Base Text Drawing Commands --------------------------------------------
function DrawText(x, y, text, color)
    if text == "" then return end

    drawCanvas.DrawText(x, y, text, color, nil, 16, fontName, nil)
end

function SetItemDataLine(desc, descX, descY, value, valueX, valueY)
    descLabels[curLine] = desc
    descLabelPosX[curLine] = descX
    descLabelPosY[curLine] = descY
    valueLabels[curLine] = value
    valueLabelPosX[curLine] = valueX
    valueLabelPosY[curLine] = valueY
    
    curLine = curLine + 1
    maxLines = maxLines + 1
end

function SetMultiLines(desc, descX, descY, table, valueX, valueY, itemsPerLine, joiningChar)
    if table == nil then return "ERR!: NO TABLE" end
    
    -- Set One Line if >1 lines aren't needed
    if #table <= itemsPerLine then
        SetItemDataLine(desc, descX, descY, TableToString(table, joiningChar), valueX, valueY)
    else
        local strings = { unpack(table, 1, #table) }
        local bigString = ""
        local numLines = 1
        local numStrings = 0

        for i=1, #strings, 1 do
            -- Build String
            bigString = bigString .. strings[i]

            -- Add Joining Char if not last string
            if i ~= #strings then bigString = bigString .. joiningChar end
            numStrings = numStrings + 1

            -- Set Last Line
            if i == #strings then
                SetItemDataLine("", descX, descY + dy * (numLines - 1),
                    bigString, valueX, valueY + dy * (numLines - 1)) 
            -- Else Set Non-Last Line
            elseif numStrings == itemsPerLine then 
                if numLines == 1 then
                    SetItemDataLine(desc, descX, descY, bigString, valueX, valueY)
                else
                    SetItemDataLine("", descX, descY + dy * (numLines - 1),
                        bigString, valueX, valueY + dy * (numLines - 1))
                end

                numStrings = 0
                numLines = numLines + 1
                bigString = ""
            end
        end
    end
end

function DrawLines(procLine)
    local procLine = procLine or -1

    for i=1, maxLines, 1 do
        if descLabels[i] ~= "" then
            DrawText(descLabelPosX[i] + 2, descLabelPosY[i] + 2, descLabels[i], black, true) -- Shadow
            DrawText(descLabelPosX[i], descLabelPosY[i], descLabels[i], lightBlue, true)
        end 

        if valueLabels[i] ~= "" then
            local valueColor = textColor
            if procLine == i then valueColor = yellow end 
            DrawText(valueLabelPosX[i] + 2, valueLabelPosY[i] + 2, valueLabels[i], black) -- Shadow
            DrawText(valueLabelPosX[i], valueLabelPosY[i], valueLabels[i], valueColor)
        end
    end

    drawCanvas.Refresh()
end

-- Specific Draw Commands -----------------
function DrawItemName(itemID, x, y)
    local symbolValue = GetItemSymbolValue(itemID)
    -- Draw Symbol and Offset X for Text
    if symbolValue >= 0xD8 and symbolValue <= 0xE7 then
        local XOffset = symbolValue - 0xD8
        drawCanvas.DrawImageRegion(imagePath .. itemSymbolFileName,
            16 * XOffset, 0, 16, 16,
            x, y
        )

        x = x + 14
    end

    SetItemDataLine("", 0, 0, GetItemName(itemID), x, y)
end

function DrawItemSpellLearned(itemID, x, y)
    local spellID, spellRate = GetItemSpellLearned(itemID, true)
    local rateText = " *" .. PadLeft(tostring(spellRate), 2, " ")

    local symbolValue = GetSpellSymbolValue(spellID)
    if symbolValue >= 0xE8 and symbolValue <= 0xEA then
        local XOffset = symbolValue - 0xE8
        drawCanvas.DrawImageRegion(imagePath .. spellSymbolFileName,
            16 * XOffset, 0, 16, 16,
            x, y
        )

        x = x + 14
    end

    SetItemDataLine("", 0, 0, GetSpellName(spellID) .. rateText, x, y)
end

function DrawItemProc(itemID, x, y)
    local spellID = GetItemProcSpell(itemID, true)
    local spellText = GetItemProcSpell(itemID)

     -- Draw Spell Symbol
    if spellID < 0x36 then
        local symbolValue = GetSpellSymbolValue(spellID)
        if symbolValue >= 0xE8 and symbolValue <= 0xEA then
            local XOffset = symbolValue - 0xE8
            drawCanvas.DrawImageRegion(imagePath .. spellSymbolFileName,
                16 * XOffset, 0, 16, 16,
                x, y
            )

            x = x + 14
        end
    end

    SetItemDataLine("", 0, 0, spellText, x, y)
end

function DrawElements(elems, x, y)
    local moveX = 24

    for i=8, 0, -1 do 
        if bit.check(elems, i) then
            drawCanvas.DrawImageRegion(imagePath .. elemFileName,
                i * 24, 0, 24, 24,
                x + ((7 - i) * moveX), y
            )
        end
    end
end

function DrawWeaponElement(elem, x, y)
    local moveX = 24

    for i=8, 0, -1 do 
        if bit.check(elem, i) then
            drawCanvas.DrawImageRegion(imagePath .. elemFileName,
                i * 24, 0, 24, 24,
                x + ((7 - i) + moveX), y
            )

            moveX = moveX + 24
        end
    end
end

function DrawProtections(prots, x, y)
    for iSet=0, 1, 1 do 
        for iStatus=0, 7, 1 do
            if bit.check(prots[iSet+1], iStatus) then
                drawCanvas.DrawImageRegion(imagePath .. statusFileName,
                    iStatus * 24, 0 + (24 * iSet), 24, 24,
                    x + (iStatus * 28) + (iSet * (8 * 28)), y
                )
            end
        end
    end
end

function DrawAutoStatuses(auto, x, y)
    for iStatus=0, 7, 1 do
        if bit.check(auto, iStatus) then
            drawCanvas.DrawImageRegion(imagePath .. statusFileName,
                iStatus * 24, 48, 24, 24,
                x + (iStatus * 48), y
            )
        end
    end
end

function DrawSpecialStatuses(special, x, y)
    for iStatus=0, 7, 1 do
        if bit.check(special, iStatus) then
            drawCanvas.DrawImageRegion(imagePath .. statusFileName,
                iStatus * 24, 24, 24, 24,
                x + (iStatus * 48), y
            )
        end
    end
end

function ReorganizeEffectStrings(effectStrings)
    local returnStrings = {}
    for i=1, 4, 1 do
        returnStrings[i] = {}
    end

    returnStrings[1][1] = effectStrings[1][1] --PA/HP
    returnStrings[1][5] = effectStrings[1][5]
    returnStrings[2][1] = effectStrings[1][3]
    returnStrings[2][5] = effectStrings[1][4]

    returnStrings[1][2] = effectStrings[1][2] --MA/MP
    returnStrings[1][6] = effectStrings[1][8]
    returnStrings[2][2] = effectStrings[1][6]
    returnStrings[2][6] = effectStrings[1][7]

    returnStrings[1][3] = effectStrings[3][1] -- Better Steal/Control/Sketch, Super Jump
    returnStrings[1][7] = effectStrings[2][8]
    returnStrings[2][3] = effectStrings[3][3]
    returnStrings[2][7] = effectStrings[3][4]
    
    returnStrings[1][4] = effectStrings[3][8] -- Phys
    returnStrings[1][8] = effectStrings[3][5]
    returnStrings[2][4] = effectStrings[4][2]
    returnStrings[2][8] = effectStrings[4][3]

    returnStrings[3][1] = effectStrings[3][6] -- MP Cost/Step Regen/Rev Cure
    returnStrings[3][5] = effectStrings[3][7]
    returnStrings[4][1] = effectStrings[4][8]
    returnStrings[4][5] = effectStrings[5][8]
    
    returnStrings[3][2] = effectStrings[4][4] -- Equip/X-Fight
    returnStrings[3][6] = effectStrings[4][5]
    returnStrings[4][2] = effectStrings[4][6]
    returnStrings[4][6] = effectStrings[4][1]

    returnStrings[3][3] = effectStrings[2][1] -- Battle
    returnStrings[3][7] = effectStrings[2][2]
    returnStrings[4][3] = effectStrings[5][4]
    returnStrings[4][7] = effectStrings[5][5]
    
    returnStrings[3][4] = effectStrings[4][7] -- Status
    returnStrings[3][8] = effectStrings[5][2]
    returnStrings[4][4] = effectStrings[5][1]
    returnStrings[4][8] = effectStrings[5][3]

    local returnTable = {}
    for x=1, 4, 1 do
        for y=1, 8, 1 do
            returnTable[y + ((x - 1) * 8)] = returnStrings[x][y]
        end
    end

    return returnTable
end

-- Update Canvas Command(s) -------------------------------------
function UpdateItemDisplay(itemID)
    local procLine = -1
    
    ClearDisplay()

    -- Draw Nothing if Empty
    if (itemID == 0xFF) then return end

    DrawItemName(itemID, 8, 8)

    local itemType = GetItemType(itemID, true)

    -- DEBUG - Draw Raw Data -----------
    --SetMultiLines("Raw Data:", GetAllItemRawData(itemID), 16, " ")

    -- Learn Spell ---------------------------
    if DoesItemTeachSpell(itemID) then
        DrawItemSpellLearned(itemID, 304, 8) --SetItemDataLine("", 0, 0, GetItemSpellLearned(itemID), 304, 8)
    end

    -- Weapon Properties ---------------------
    if itemType == 0x01 then 
        -- Weapon Element -------------
        local elem = GetWeaponElements(itemID, true)
        DrawWeaponElement(elem, 216, 4)

        -- Attack Proc ----------------
        if DoesItemProc(itemID) then
            procLine = curLine
            DrawItemProc(itemID, 24, 32)
        end

        -- Weapon Special -------------
        local wSpecial = GetWeaponSpecialAbility(itemID)
        if wSpecial ~= "" then SetItemDataLine("", 0, 0, wSpecial, 272, 32) end

        -- General Properties ---------
        local wProps = GetItemWeaponProperties(itemID)
        if next(wProps) ~= nil then SetMultiLines("", 0, 0, wProps, 8, 56, 8, " ") end
    end

    -- Armor/Relic Properties (Elements)--------------------------
    if itemType >= 0x02 and itemType <= 0x05 then
        local elemAbs = GetItemAbsorbElements(itemID, true)
        SetItemDataLine("Abs", 8, 32, "", 0, 0)
        if elemAbs ~= 0x00 then
            DrawElements(elemAbs, 64, 28)
        end

        local elemNull = GetItemNullElements(itemID, true)
        SetItemDataLine("Nul", 260, 32, "", 0, 0)
        if elemNull ~= 0x00 then
            DrawElements(elemNull, 316, 28)
        end

        local elemHalf = GetItemHalvedElements(itemID, true)
        SetItemDataLine("1/2", 8, 56, "", 0, 0)
        if elemHalf ~= 0x00 then
            DrawElements(elemHalf, 64, 52)
        end

        SetItemDataLine("Wek", 260, 56, "", 0, 0)
        local elemWeak = GetItemWeakElements(itemID, true)
        if elemWeak ~= 0x00 then
            DrawElements(elemWeak, 316, 52)
        end
    end
    
    -- Any Equips ----------------------
    if itemType >= 0x01 and itemType <= 0x05 then
        -- Field Effects -------------------------
        local fieldEffects = GetItemFieldEffects(itemID)
        SetMultiLines("Field:", 8, 80, fieldEffects, 128, 80, 4, " ")

        -- Protections ----------------------
        local protections = GetItemStatusProtection(itemID, true)
        SetMultiLines("No:", 8, 104, "", 0, 0, 0, "0")
        if protections[1] + protections[2] ~= 0x00 then
            DrawProtections(protections, 60, 100)
        end

        -- Statuses ------------------------------
        local statuses = GetItemStatusEffects(itemID, true)
        SetMultiLines("Auto:", 8, 128, "", 0, 0, 0, "")
        if statuses ~= 0x00 then
            DrawAutoStatuses(statuses, 120, 124)
        end

        -- Special Statuses ---------------------------
        local specStatuses = GetItemSpecialStatus(itemID, true)
        SetMultiLines("Other:", 8, 152, "", 0, 0, 0, "")
        if specStatuses ~= 0x00 then
            DrawSpecialStatuses(specStatuses, 120, 148)
        end

        -- Special Effects ------------------------------
        local specEffects = GetItemSpecialEffects(itemID, true)
        local allEffectWords = GetItemSpecialEffects(itemID)
        local sortedEffectWords = ReorganizeEffectStrings(allEffectWords)
        effectTotal = specEffects[1] + specEffects[2] + specEffects[3] + specEffects[4] + specEffects[5]
        if effectTotal ~= 0x00 then
            SetMultiLines("", 0, 0, sortedEffectWords, 8, 176, 4, "  ")

            -- Command Change
            local cc = ""
            for i=0, 4, 1 do
                if allEffectWords[2][3 + i] ~= "      " then
                    cc = allEffectWords[2][3 + i]
                end
            end
            SetItemDataLine("", 0, 0, cc, 8, 342)
        end

        -- Equipped by ---------------------------------
        local equips = GetItemEquipableActors(itemID, true)
        SetItemDataLine("Can be used by:", 8, 368, equips[1] .. "  " .. equips[2], 271, 368)
        table.remove(equips, 1)
        table.remove(equips, 1)
        SetMultiLines("", 0, 0, equips, 8, 388, 4, "  ")
    end

    ---------------------------------------------------
    -- Draw to Window ---------------------------------
    DrawLines(procLine)
    
end
