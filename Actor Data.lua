local actorCurDataAddress = 0x1600
local actorCurDataLength = 0x25
local actorNameLength = 0x06
-- party data: verbbppp v:Visible, e:Actor Enabled, r:BackRow?, b:BattleOrder, p:Party
local actorAvailabilityDataAddress = 0x1EDC
local party

-- GetActorName
function GetActorName(actorID)
    local address = actorCurDataAddress + (actorID * actorCurDataLength) + 0x02
    --[[if rawValues == true then
        local charValues = {}
        for i=0, actorNameLength - 1, 1 do
            charValues[i + 1] = mainmemory.read_u8(address + i)
        end

        return charValues
    end]]

    require 'Utils'
    local name = ""
    for i=0, actorNameLength - 1, 1 do
        name = name .. HexToChar(mainmemory.read_u8(address + i))
    end
    
    return name
end

function GetActorEsperID(actorID)
    return mainmemory.read_u8(actorCurDataAddress + (actorID * actorCurDataLength) + 0x1E)
end

--0x00 = Not learned, 0xFF = Learned, Else = Learn %
function GetActorSpell(actorID, spellID)
    return mainmemory.read_u8(0x1A6E + (actorID * 0x36) + spellID)
end

-- Returns a 54 value table, 0x00 = Not learned, 0xFF = Learned, Else = Learn %
function GetAllActorSpells(actorID) 
    local address = 0x1A6E + (actorID * 0x36)

    local values = {}
    for i=0, 0x36, 1 do
        values[i+1] = mainmemory.read_u8(address + i)
    end
    
    return values
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

function GetActorEquipByID(actorID, equipSlot)
    --Modify ActorID for Vicks and Wedge (and Leo?)
    if actorID == 32 then actorID = 14 end
    if actorID == 33 then actorID = 15 end
    
    local address = actorCurDataAddress + (actorID * actorCurDataLength) + 0x1F + equipSlot
    local value = mainmemory.read_u8(address)

    return value
end

function GetActorEquipByPtr(ptr, equipSlot)
    --Modify ActorID for Vicks and Wedge (and Leo?)
    if actorID == 32 then actorID = 14 end
    if actorID == 33 then actorID = 15 end
    
    local address = ptr + 0x1F + equipSlot
    local value = mainmemory.read_u8(address)

    return value
end

function GetCurrentPartyActorIDs()
    local values = {}
    local actorVar
    local partyOrder
    local isActorFound
    --Check if members are in current party
    for i=0, 15, 1 do
        actorVar = mainmemory.read_u8(0x1850 + i)
        -- 0x1850, chars 1-16 party member info; 0x1A6D is current party ID 
        if bit.band(actorVar, 0x03) == mainmemory.read_u8(0x1A6D) then
            -- Get party order bits
            partyOrder = bit.band(bit.rshift(actorVar, 0x03), 0x03)
            values[partyOrder+1] = i
        end
    end

    -- Stick 0xFF in for empty slots
    for i=1, 4, 1 do
        if values[i] == nil then values[i] = 0xFF end
    end

    --console.log("values:")
    --console.log(values)
    return values
end

