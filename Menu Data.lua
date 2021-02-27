function GetMenuActorID(partySlot)
    return mainmemory.read_u8(0x69 + partySlot)
end

function GetMenuID()
	return mainmemory.read_u8(0x26)
end

function GetMenuCursorIndex()
	return mainmemory.read_u8(0x4B)
end

function GetMenuCurActorDataPtr()
	return mainmemory.read_u16_le(0x67)
end

function GetMenuAllCurrentActorDataPtrs()
    local values = {}

    for i=0, 3, 1 do
        values[i+1] = mainmemory.read_u16_le(0x6D + (i * 2))
        --console.log("values[" .. tostring(i+1) .. "]: " .. bizstring.hex(values[i+1]))
    end

    return values
end

function GetMenuTextRawColor()
    --console.log("hre: ")
    --console.log({ mainmemory.read_u8(0x1D55), mainmemory.read_u8(0x1D56) })
    return { mainmemory.read_u8(0x1D55), mainmemory.read_u8(0x1D56) }
end

function GetMenuBGDesignID()
    return bit.band(mainmemory.read_u8(0x1D4E), 0x07)
end

function GetMenuBGRawColor(menuBGID, colorID) -- 7 colors per palette, 2 bytes per color
    local baseAddress = 0x1D57 + (menuBGID * 14) + (colorID * 2)
    return { mainmemory.read_u8(baseAddress) , mainmemory.read_u8(baseAddress + 1) }
end

function GetMenuBGRawColorSubset(menuBGID, colorIDs) -- 7 colors per palette, 2 bytes per color
    local baseAddress = 0x1D57 + (menuBGID * 14)
    local colorAddress
    local colors = {}
    for i=0, #colorIDs-1, 1 do
        colorAddress = baseAddress + (colorIDs[i+1] * 2)
        colors[i+1] = { 
            mainmemory.read_u8(colorAddress), mainmemory.read_u8(colorAddress + 1)
        }
        --console.log("colors[i+1]:")
        --console.log(colors[i+1])
    end

    return colors
end

function GetShopID()
    return mainmemory.read_u8(0x0201)
end

function GetNumItemsOwnedInShop()
    return mainmemory.read_u8(0x64) 
end
