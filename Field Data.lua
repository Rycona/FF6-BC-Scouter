function GetFieldDialogState()
    return mainmemory.read_u8(0xBA)
end

function GetFieldDialogID()
    return mainmemory.read_u16_le(0xD0)
end

function GetFieldDialogItemID()
    return mainmemory.read_u8(0x0583)
end

function GetCurrentMap()
    return bit.band(mainmemory.read_u16_le(0x1F64), 0x01FF)
end

function GetPartyMapPos()
    return mainmemory.read_u8(0x00AF), mainmemory.read_u8(0x00B0)
end