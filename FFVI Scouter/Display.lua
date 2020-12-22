canvasID = 0
descLabels = {}
valueLabels = {}
curLine = 1
maxLines = 20

function CloseCanvas()
	forms.destroy(canvasID)
end

function CreateDisplay()
    local x1 = 5
    local x2 = 150
    local y = 10
    local dy = 18
    local w1 = 145
    local w2 = 450
    local h = 20

    canvasID = forms.newform(600, 400, "FF6BC Scouter")

    event.onexit(CloseCanvas)

    
    for i=1, maxLines, 1 do
        descLabels[i] = forms.label(canvasID, "", x1, y + ((i-1)*dy), w1, h, true)
        valueLabels[i] = forms.label(canvasID, "", x2, y + ((i-1)*dy), w2, h, true)
    end
    

end

function ClearDisplay()
    for i=1, maxLines, 1 do
        forms.settext(descLabels[i], "")
        forms.settext(valueLabels[i], "")
    end

    curLine = 1
end


function SetItemDataLine(desc, value)
    if curLine > maxLines then console.log("ERR!: Too Many Lines!") end
    --console.log("desc= " .. desc)
    --console.log("value= " .. value)

    forms.settext(descLabels[curLine], desc)
    forms.settext(valueLabels[curLine], value)
    curLine = curLine + 1
end

function SetMultiLines(desc, table, itemsPerLine, joiningChar)
    if table == nil then return "ERR!: NO TABLE" end
    
    if #table <= itemsPerLine then
        SetItemDataLine(desc, TableToString(table, joiningChar))
    else
        local strings = { unpack(table, 1, #table) }
        local bigString = ""
        local numLines = 1
        local numStrings = 0

        for i=1, #strings, 1 do
            -- Build String
            bigString = bigString .. strings[i]
            if i ~= #strings then bigString = bigString .. joiningChar end
            numStrings = numStrings + 1

            -- Write Line
            if numStrings == itemsPerLine then 
                --console.log(bigString)
                if numLines == 1 then
                    SetItemDataLine(desc, bigString)
                else
                    SetItemDataLine("", bigString)
                end

                numStrings = 0
                numLines = numLines + 1
                bigString = ""
            end

            if i == #strings then SetItemDataLine("", bigString) end
        end
    end
end

function UpdateItemDisplay(itemID)
    --console.log("ItemID to Display: " .. itemID)
    ClearDisplay()
    if (itemID == 0xFF) then return end

    SetItemDataLine("Item Name:", GetItemName(itemID))
    local itemType = GetItemType(itemID, true)
    
    --Weapon Properties ----------------------
    if itemType == 0x01 then 
        -- Attack Proc --------------------------
        if DoesItemProc(itemID) then
            SetItemDataLine("Proc Spell:", GetItemProcSpell(itemID))
        end

        -- Weapon Special ---------------------
        local wSpecial = GetWeaponSpecialAbility(itemID)
        if wSpecial ~= "" then SetItemDataLine("Weapon Special:", wSpecial) end

        -- General Properties --------------------------
        local wProps = GetItemWeaponProperties(itemID)
        if next(wProps) ~= nil then SetItemDataLine("Weapon Properties:", TableToString(wProps)) end
        
    end

    -- Armor/Relic Properties (Elements)--------------------------
    if itemType >= 0x02 and itemType <= 0x06 then
        local elemAbs = GetItemAbsorbElements(itemID)
        if next(elemAbs) ~= nil then SetItemDataLine("Absorb:", TableToString(elemAbs)) end

        local elemNull = GetItemNullElements(itemID)
        if next(elemNull) ~= nil then SetItemDataLine("Null:", TableToString(elemNull)) end

        local elemHalf = GetItemHalvedElements(itemID)
        if next(elemHalf) ~= nil then SetItemDataLine("1/2 Dmg:", TableToString(elemHalf)) end

        local elemWeak = GetItemWeakElements(itemID)
        if next(elemWeak) ~= nil then SetItemDataLine("Weak:", TableToString(elemWeak)) end
    end
    
    -- Any Equips ----------------------
    if itemType >= 0x01 and itemType <= 0x05 then
        -- Protections ----------------------
        local protections = GetItemStatusProtection(itemID)
        if next(protections)  then
            SetMultiLines("Protects From: ", protections, 7, ", ")
        end

        -- Statuses ------------------------------
        local statuses = GetItemStatusEffects(itemID)
        if next(statuses) then
            SetMultiLines("Statuses Granted: ", statuses, 7, ", ")
        end

        -- Special Effects ------------------------------
        local specEffects = GetItemSpecialEffects(itemID)
        if next(specEffects) then
            SetMultiLines("Special Effects: ", specEffects, 3, ", ")
        end

        -- Learn Spell ---------------------------
        if DoesItemTeachSpell(itemID) then
            SetItemDataLine("Learn Spell:", GetItemSpellLearned(itemID))
        end

        local equips = GetItemEquipableActors(itemID, true)
        --console.log(equips)
        SetMultiLines("Who Can Equip: ", equips, 7, "  ")
    end
end
