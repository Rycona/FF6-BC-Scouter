local actorCurDataAddress = 0x1600
local actorCurDataLength = 0x25
local actorNameLength = 0x06
-- party data: verbbppp v:Visible, e:Actor Enabled, r:BackRow?, b:BattleOrder, p:Party
local actorAvailabilityDataAddress = 0x1EDC


-- GetActorName
function GetActorName(actorID, rawValues)
    local rawValues = rawValues or false
    
    local address = actorCurDataAddress + (actorID * actorCurDataLength) + 0x02
    if rawValues == true then
        local charValues = {}
        for i=0, actorNameLength - 1, 1 do
            charValues[i + 1] = mainmemory.read_u8(address + i)
        end

        return charValues
    end

    require 'Utils'
    local name = ""
    for i=0, actorNameLength - 1, 1 do
        name = name .. HexToChar(mainmemory.read_u8(address + i))
    end
    
    return name
end

-- Meaning characters are available to add to party (I think)
function IsActorEnabled(actorID)
    local address = actorCurDataAddress + (actorID * actorCurDataLength)
    if (mainmemory.read_u8(address)) == 0xFF then return false end

    address = actorAvailabilityDataAddress

    if actorID < 8 then
        return bit.check(mainmemory.read_u8(address), actorID)
    end
    
    return bit.check(mainmemory.read_u8(address + 1), actorID - 8)
end
