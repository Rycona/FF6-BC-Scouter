# FF6 BC Scouter

Version:    0.2b  |  Date:       2021-01-18

FF6 BC Scouter: https://github.com/Rycona/FF6-BC-Scouter

Beyond Chaos Randomizer URL:    https://github.com/subtractionsoup/beyondchaos/releases/latest

Beyond Chaos Discord:           https://discord.gg/S3G3UXy

TO INTRODUCE
-------------
This repository holds a set of Lua scripts to aid in playing Beyond Chaos, a FF6 randomizer. This code will make a separate
window that will display highlighted equipment information while in Menus that is normally only displayed in the Item Menu 
after selecting an item. Ideally, this will ease changing and viewing equipment, particularly for seeds with the
'masseffect' code.

TO USE
-----------------------------------------
- Use with the BizHawk SNES Emulator (Tested with BizHawk v2.5.2)
- Keep all scripts together in the same folder
- Load only 'FF6BC Scouter.lua' from the folder

NOTE: Does not work with other emulators that support Lua scripts due to use of BizHawk-specific Lua Functions

FEATURES
-------------------------------------------
- View info of equipment
    - under cursor in Item, Equip, and Relic Menus
    - under cursor info on the Shop Sell screen
    - taken from chests
    - stolen, morphed, or dropped from enemies

TO DO
-------------------------------------------
- ~~A couple of effects are NOT displayed: 1/2 enc, No enc, and maybe some others~~
- Decent Graphics/Layout for nicer look and increased readability
- Option for Less "Adaptive" Layout, so Item Characteristics are always in the same part of the window
- Option for "More Adaptive" Layout, i.e, being able to resize the window.
- Script for the Esper Menu, so one can have an overview of their Espers, Spells, and Learn Percentages At a glance (or at
    least a scroll)
- Script for the Rage Menu to give info from the cursor without selecting, and maybe being able to sort/highlight by Elemental
    Affinities, Statuses, or Highest Multiplier
- Access the aforementioned information while in battle
- ~~Access item information from shop sell menu~~
- Stat and Command overview for all party members from main manu
- ~~Pop up with info about when picking up treasures or getting enemy drops/steals/morphs~~

TO FIX
------------------------------------------
- ~~The window may flicker with text during battle, and possibly elsewhere (but it shouldn't affect anything)~~

TO TEST
------------------------------------------
- Using W-/?- Ragnarok/Steal/Capture with multiple gets and seeing if the proper item displays
- Seeing if there are other battle dialog IDs used when getting an item

CHANGE LOG
------------------------------------------
v0.1b - 2020-12-21

    - Shows item info highlighted in party menus
    
v0.2b - 2021-01-18:

    - Shows item info from chests, steals, morphs, and drops
    - Shows item info highlight in shop sell menu
    - Flickering hopefully removed

TO CONTACT
------------------------------------------
Post any problems or suggestions you have in the Issues section of GitHub. All constructive critcism, feedback, and salty limericks welcome.
