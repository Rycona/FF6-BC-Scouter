--[[
elemList = { "Fire", "Ice", "Bolt", "Bio", "Wind", "Pearl", "Earth", "Water" }
statusList = { 
	{ "Blind", "Zombie", "Poison", "Magitek", "Vanish", "Imp", "Petrify", "Death" },
	{ "Condemned", "Near Death", "Image", "Mute", "Berserk", "Confuse", "Seizure", "Sleep" },
	{ "Float", "Regen", "Slow", "Haste", "Stop", "Protect", "Reflect" },
	{ "Cover", "Runic", "Reraise", "Morph", "Casting", "Disappear", "Interceptor", "Floating" }
}
morphRateList = { "99%", "75%", "50%", "25%", "12.5%", "6.25%", "3.125%" }
]]--


------- SPELL FUNCTIONS ---------------------------------------------



------- ENEMY FUNCTIONS ---------------------------------------------
function GetInfoOnEnemies()
    require 'Enemy Data'
    require 'Item Data'

	--console.clear()

	for i=1, 4, 1 do
		local enemyID = mainmemory.read_u16_le(0x00200D + ((i - 1) * 2))
		
		if enemyID ~= 0xFFFF then
			console.log("EnemyID: 0x" .. bizstring.hex(enemyID)) -- DEBUG
			GetEnemyInfo(enemyID)
			console.log("-------------------------------------")
		end
	end

	console.log("-------------------------------------")

end

