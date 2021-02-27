local fontName = "FF6 Menu"

-- File Paths/Names ----------------------------------------
local imagePath = "Images\\"
local elemFileName = "elems.png"
local itemStatusFileName = "itemStatuses.png"
local itemSymbolFileName = "itemTypes.png"
local spellSymbolFileName = "spellTypes.png"
local battleStatusFileName = "battleStatuses.png"

-- Colors (0xAARRGGBB) -------------------------------------
white = 0xFFFFFFFF -- Default Text
black = 0xFF000000
darkBlue = 0xFF3A3A94 -- Default Background
lightBlue = 0xFF00DEDE -- Description Text
darkGray = 0xFF7B7B7B -- Unusable Item Text
yellow = 0xFFFFEE00 -- Proc Text
transparent = 0x00000000 

local menuBGColor = darkBlue
local menuTextColor = white

---------------------------------------------------------------------------
-- Canvas Base Commands ---------------------------------------------------
local mainCanvas

--local dy = 20

-- Window --
function CreateWindow(windowName, w, h)
    
    mainCanvas = gui.createcanvas(w, h)
    mainCanvas.SetTitle(windowName)
    mainCanvas.SetDefaultBackgroundColor(darkBlue)
    mainCanvas.SetDefaultForegroundColor(white)
    mainCanvas.SetDefaultTextBackground(transparent)
    
    ClearWindow()
    DrawWindow()

    event.onexit(CloseCanvas)    
end

function DrawWindow()
    mainCanvas.Refresh()
end

function ClearWindow()
    menuBGColor = GetMenuBGColorARGB()
    menuTextColor = GetMenuTextColorARGB()
    mainCanvas.Clear(menuBGColor)
end

function GetMenuTextColorARGB()
    return ConvertRawColorToARGB( GetMenuTextRawColor() )
end

function GetMenuBGColorARGB()
    local menuBGID = GetMenuBGDesignID()
    --console.log("menuBGID: " .. menuBGID)

    -- Choose color source(s) based on window design
    local colorSourceIDs
    if menuBGID == 0 then
        colorSourceIDs = { 6 }
    elseif menuBGID == 1 then
        colorSourceIDs = { 4 }
    elseif menuBGID == 2 then
        colorSourceIDs = { 2, 3, 4 }
    elseif menuBGID == 3 then
        colorSourceIDs = { 1, 2, 3 }
    elseif menuBGID == 4 then
        colorSourceIDs = { 1, 2, 3 }
    elseif menuBGID == 5 then
        colorSourceIDs = { 3, 4 }
    elseif menuBGID == 6 then
        colorSourceIDs = { 4 }
    elseif menuBGID == 7 then
        colorSourceIDs = { 0 }
    else
        console.log("ERR!: menuBGID > 7")
    end
    --console.log("colorSourceIDs:")
    --console.log(colorSourceIDs)

    -- Get Colors
    local sourceColors
    local color = 0x00000000
    local r = 0
    local g = 0
    local b = 0

    if #colorSourceIDs > 1 then
        sourceColors = {}
        local rawColorValues = GetMenuBGRawColorSubset(menuBGID, colorSourceIDs)
        
        for i=1, #rawColorValues, 1 do --
            --console.log("rawColorValues[i]:")
            --console.log(rawColorValues[i])
            --console.log("Address: " .. bizstring.hex((address + (colorSourceIDs[i+1] * 2))))
            sourceColors[i] = ConvertRawColorToARGB(
                { rawColorValues[i][1], rawColorValues[i][2] }
            )
        end

        -- Extract RGB
        for i=1, #colorSourceIDs, 1 do
            if sourceColors[i] == nil then console.log(i .. " = nil") end
            --console.log(sourceColors[i])
            r = r + bit.band(bit.rshift(sourceColors[i], 16), 0xFF)
            g = g + bit.band(bit.rshift(sourceColors[i], 8), 0xFF)
            b = b + bit.band(sourceColors[i], 0xFF)
        end

        -- Average RGBs Among Sources (Round Up)
        r = math.ceil(r / #colorSourceIDs)
        g = math.ceil(g / #colorSourceIDs)
        b = math.ceil(b / #colorSourceIDs)
        
    else -- only 1 color source
        --console.log("hr")
        color = ConvertRawColorToARGB( GetMenuBGRawColor(menuBGID, colorSourceIDs[1]) )
        --console.log("hr2")
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

--For OnExit() 
function CloseCanvas()
    mainCanvas.Close()
end



-- Input --
function GetMouseXY()
    return mainCanvas.GetMouseX(), mainCanvas.GetMouseY()
end

-- Text --
function DrawText(text, x, y, textColor, shadowColor)
    if text == "" then return end
    local textColor = textColor or menuTextColor
    local shadowColor = shadowColor or black
    
    mainCanvas.DrawText(x + 2, y + 2, text, shadowColor, nil, 16, fontName, nil)
    mainCanvas.DrawText(x, y, text, textColor, nil, 16, fontName, nil)
end

function DrawTableAsTextLine(table, x, y, spacingChar, textColor, shadowColor)
    --if table == nil then console.log("RET") return end
    local textColor = textColor or menuTextColor
    local shadowColor = shadowColor or black

    local bigString = ""
    for i=1, #table, 1 do
        --console.log("Table:")
        --console.log(i .. ": " .. table[i])
        bigString = bigString .. table[i]
        if i ~= #table then bigString = bigString .. spacingChar end
    end

    DrawText(bigString, x, y, textColor, shadowColor)
end

-- Images --
function DrawItemSymbol(symbolID, x, y)
    mainCanvas.DrawImageRegion(imagePath .. itemSymbolFileName,
            16 * symbolID, 0, 16, 16,
            x, y
        )
end

function DrawMagicSymbol(symbolID, x, y)
    mainCanvas.DrawImageRegion(imagePath .. spellSymbolFileName,
        16 * symbolID, 0, 16, 16,
        x, y
    )
end

function DrawElementSymbol(symbolID, x, y)
    mainCanvas.DrawImageRegion(imagePath .. elemFileName,
        symbolID * 24, 0, 24, 24,
        x, y
    )
end

function DrawItemStatusSymbol(symbolByte, symbolBit, x, y)
    mainCanvas.DrawImageRegion(imagePath .. itemStatusFileName,
        symbolBit * 24, symbolByte * 24, 24, 24,
        x, y
    )
end

-- Buttons { x, y, w, h, text } ---------
--local buttons = {}

function CreateButton(x, y, w, h, text)
    return { x, y, w, h, text }
end

function DrawButton(button)
    mainCanvas.DrawRectangle(x - 1, y - 1, width + 2, height + 2, black, menuBGColor)
    mainCanvas.DrawRectangle(x, y, width, height, white, menuBGColor)
    
    local textX = x + ((width / 2) - (string.len(text) * 8))
    local textY = y + (height / 2 - 8) + 1
    DrawText(textX, textY, text, menuTextColor, black)
end




