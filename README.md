# FF6 BC Scouter

Version:    0.1?

Date:       2020-12-21

Beyond Chaos Randomizer URL:    https://github.com/subtractionsoup/beyondchaos/releases/latest

Beyond Chaos Discord:           https://discord.gg/S3G3UXy

TO INTRODUCE
-------------
This repository holds a set of Lua scripts to aid in playing Beyond Chaos, a FF6 randomizer. My goal with this is primarly to
cut down on what I consider metagaming, the tracking of the variance of known variables during playthroughs which pulls me out
of the game and reduces my flow and enjoyment. This is to aid that hopefully, and I thought I may as well share it with others.

TO USE
-----------------------------------------
Keep all the scripts in the same folder. Only the 'FF6BC Scouter.lua' file needs to be run. A separate window will pop up when
the script is run and will display equipment information on the Equip and Relic menus that is normally only displayed in the
item menu after selecting an item. Ideally, this will make changing equipment less arduous.

I've only tested this with the BizHawk-2.5.2 Emulator with the BSNES core. I don't know if different cores will affect
anything. I'm assuming there are no guarantees this will work on another emulator as I do use some of the BizHawk Lua functions
and I imagine I'd have to code around that for SNES9x or another emulator that runs Lua Scripts. I'm not certain of this, feel
free to correct me if I'm wrong.

TO DO
-------------------------------------------
- Decent Graphics/Layout for nicer look and increased readability
- Option for Less "Adaptive" Layout, so Item Characteristics are always in the same part of the window
- Option for "More Adaptive" Layout, i.e, being able to resize the window.
- Script for the Esper Menu, so one can have an overview of their Espers, Spells, and Learn Percentages At a glance (or at
    least a scroll)
- Script for the Rage Menu to give info from the cursor without selecting, and maybe being able to sort/highlight by Elemental
    Affinities, Statuses, or Highest Multiplier
- Access the aforementioned information while in battle
- Access item information from shop sell menu
- Stat and Command overview for all party members from main manu

TO FIX
------------------------------------------
- The display flickers during battle, and possibly elsewhere (but it shouldn't affect anything)

TO CONTACT
------------------------------------------
If you want to contact me, message me on Discord. All critcism, feedback, and salty limericks welcome.
