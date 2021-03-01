elemList = { "Fire", "Ice", "Bolt", "Bio", "Wind", "Pearl", "Earth", "Water" }
itemStatusList = { 
	{ "Blind", "Zombie", "Poison", "Magitek", "Vanish", "Imp", "Petrify", "Death" },
	{ "Condemned", "Near-Death", "Image", "Mute", "Berserk", "Confuse", "Seizure", "Sleep" },
	{ "Float", "Regen", "Slow", "Haste", "Stop", "Shell", "Protect", "Reflect" },
	{ "Cover", "Runic", "Reraise", "Morph", "Casting", "Disappear", "Interceptor", "Floating" }
}

battleStatusList = { 
	{ "Blind", "Zombie", "Poison", "Magitek", "Vanish", "Imp", "Petrify", "Death" },
	{ "Condemned", "Near-Death", "Image", "Mute", "Berserk", "Confuse", "Seizure", "Sleep" },
	{ "Dance", "Regen", "Slow", "Haste", "Stop", "Shell", "Protect", "Reflect" },
	{ "Rage", "Frozen", "ID Prot", "Morph", "Casting", "Disappear", "Interceptor", "Float" }
}
morphRateList = { "99%", "75%", "50%", "25%", "12.5%", "6.25%", "3.125%" }
weaponPropertiesList = { "WP 0x01", "SwdTech", "Can Proc", "Breaks", "WP 0x10", "BackRow", "2-Hand", "Runic" }
equipmentStatusList = { "Condemned", "Near-Death", "Image", "Mute", "Berserk", "Confuse", "Seizure", "Sleep" }

--[[itemSpecialEffectsList = { -- Same name conventions as BC, except Unused
    { "Bat.Pwr +1/4", "Mag.Pwr +1/4", "HP +1/4", "HP +1/2", "HP +1/8", "MP +1/4", "MP +1/2", "MP +1/8" },
    { "Initiative", "Vigilance", "Fight > Jump", "Magic > X-Magic", "Sketch > Control", "Slot > GP Rain", "Steal > Capture", "Super Jump" },
    { "Better Steal", "SpE 3 0x02", "Better Sketch", "Better Ctrl", "100% Hit Rate", "1/2 MP Cost", "1 MP Cost", "Vigor +50%" },
    { "> X-Fight", "Can Counter", "Random Evade", "Gauntlet", "Dual Wield", "Equip Anything", "Cover", "Step Regen" },
    { "Low HP Shell", "Low HP Safe", "Low HP Reflect", "Double Exp.", "Double GP", "SpE 5 0x20", "SpE 5 0x40", "Reverse Cures"}
}
]]

itemSpecialEffectsList = { 
    { "PA+1/4", "MA+1/4", "HP+1/4", "HP+1/2", "HP+1/8", "MP+1/4", "MP+1/2", "MP+1/8" },
    { "Init  ", "Vigil ", "Fight > Jump", "Magic > X-Magic", "Sketch > Control", "Slot > GP Rain", "Steal > Capture", "Jump+ " },
    { "Steal+", "3 0x02", "Sktch+", "Ctrl+ ", "100%Ht", "1/2 MP", "1 MP  ", "Vg+1/2" },
    { "XFight", "Countr", "RndEv.", "Gntlet", "2*Weap", "AnyEq.", "Cover ", "StepHP" },
    { "vHPShl", "vHPSfe", "vHPWal", "2* Exp", "2* GP ", "5 0x20", "5 0x40", "RevCur"}
}

itemFieldEffectsList = { "1/2 Enc", "No Enc", "FE 0x04", "FE 0x08", "FE 0x10", "Sprint", "FE 0x40", "FE 0x80" }

weaponSpecials = {
    "Can Steal", "Atma", "X Kill", "Man Eater", "Drain HP", "Drain MP", "Uses Some MP", "Random Throw", 
    "Dice", "Valiant", "Wind Attack", "Heals Target", "Slice Kill", "Fragile Wpn",  "Uses More MP"
}

blockTypeList = { "Dg", "Sw", "Sh", "Cp" }

--[[ Esper Level Up Bonuses
    0: "HP + 10%",
    1: "HP + 30%",
    2: "HP + 50%",
    3: "MP + 10%",
    4: "MP + 30%",
    5: "MP + 50%",
    6: "HP + 100%",
    7: "LV - 1",
    8: "LV + 50%",
    9: "STR + 1",
    0xA: "STR + 2",
    0xB: "SPD + 1",
    0xC: "SPD + 2",
    0xD: "STA + 1",
    0xE: "STA + 2",
    0xF: "MAG + 1",
    0x10: "MAG + 2"}
]]

esperLevelBonusList = {
    "HP + 10%", "HP + 30%", "HP + 50%",  "MP + 10%",
    "MP + 30%", "MP + 50%", "HP + 100%", "LV - 1",
    "LV + 50%", "STR + 1",  "STR + 2",   "SPD + 1",
    "SPD + 2",  "STA + 1",  "STA + 2",   "MAG + 1",
    "MAG + 2"
}

esperListToIndexList = {
    0x00, 0x11, 0x03, 0x08, 0x01, 0x02, 0x17, 0x06,
    0x05, 0x14, 0x13, 0x07, 0x16, 0x12, 0x15, 0x09,
    0x18, 0x0A, 0x04, 0x19, 0x0E, 0x1A, 0x0B, 0x0D,
    0x10, 0x0F, 0x0C
}

