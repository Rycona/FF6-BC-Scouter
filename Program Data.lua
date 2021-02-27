c_World = 0
c_Field = 1
c_Menu = 2
c_Battle = 3

local programStateNames = { "World", "Field", "Menu", "Battle" }

function IsInMenu()
    -- Does NOT work for Save Menu (ends up as "World" Program)

	-- if party member ptrs in menu = those is data saved to SRAM
    local curPartyIDs = GetCurrentPartyActorIDs()
    --console.log(curPartyIDs)
    local menuPartyVars = GetMenuAllCurrentActorDataPtrs()
    --console.log(menuPartyVars)
    local idFromPtr
    for i=0, 3, 1 do 
        if menuPartyVars[i+1] == 0x00 then
            idFromPtr = 0xFF
        else
            idFromPtr = (menuPartyVars[i+1] - 0x1600) / 0x25
        end
        --console.log("i = " .. i .. "  idFromPtr = " .. idFromPtr)

        if curPartyIDs[i+1] == 0xFF and idFromPtr ~= 0xFF then
            return false
		--console.log("Mem: " .. mainmemory.read_u8(0x69 + i))
        --console.log("CurPartyID: " .. curPartyIDs[i+1])
        elseif idFromPtr ~= curPartyIDs[i+1] then
            return false
        end
    end
    
    --[[ Does not work on shop menu after selecting item to buy
        Something overwrites some of the member IDs 
	for i=0, 3, 1 do 
		--console.log("Mem: " .. mainmemory.read_u8(0x69 + i))
		--console.log("CurPartyID: " .. curPartyIDs[i+1])
		if GetMenuActorID(i) ~= curPartyIDs[i+1] then return false end
	end
    ]]


	return true
end

function IsInBattle()
    local curPartyIDs = GetCurrentPartyActorIDs()
    local battlePartyID
	for i=0, 3, 1 do
        -- if party member IDs in battle = those is data saved to SRAM
        battlePartyID = GetBattleActorID(i)
		if battlePartyID ~= curPartyIDs[i+1] then
			return false
		end

		return true
	end
end

function IsInField()
	-- If map ID in data written to SRAM > 2 (WoB World = 0, WoR World = 1)
	if GetCurrentMap() > 0x0002 then
		return true
	end

	return false
end

function GetCurrentProgram()
	-- Check for Menu ------------------
	if IsInMenu() then return c_Menu end
	-- Check for Battle ----------------
	if IsInBattle() then return c_Battle end
	-- Check for Field -----------------
	if IsInField() then return c_Field end
	
	return c_World
end

function GetProgramName(value)
    return programStateNames[value+1]
end
