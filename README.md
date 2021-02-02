# FF6 BC Scouter

Version:    0.3b  |  Date:       2021-02-02

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
- Install the FF6Menu.ttf in the Fonts folder to your Font directory
- Keep the Images folder inside the FF6BC Scouter folder
- Use with the BizHawk SNES Emulator (Tested with BizHawk v2.5.2/v2.6)
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
        - NOTE: Steals will display once next character/enemy perform an action
    
- Graphics
    - Uses the Menu font from FF6 for display
    - Text Color and Approximate Menu Window Background Colors chosen by player will be used

WHAT DOES X SYMBOL/TEXT MEAN?
-------------------------------------------
There is an accompanying image that explains custom symbols and names (Symbol and Text Descriptions.png). Sorry if the
symbols/texts aren't super-intuitive, but I didn't want to spend a ton of time on them for this update.

TO DO
-------------------------------------------
- Option for "More Adaptive" Layout, i.e, being able to resize the window. (Questionable now, given the window space)
- Script for the Esper Menu, so one can have an overview of their Espers, Spells, and Learn Percentages At a glance (or at
    least a scroll)
- Display Esper equipability for Esper Allocator seeds ('dancingmaduin' code)
- Script for the Rage Menu to give info from the cursor without selecting, and maybe being able to sort/highlight by Elemental
    Affinities, Statuses, or Highest Multiplier
- Access item information while in battle
- Stat and Command overview for all party members from main manu

TO TEST
------------------------------------------
- Using W-/?- Ragnarok/Steal/Capture with multiple gets and seeing if the proper item displays
- Seeing if there are other battle dialog IDs used when getting an item

CHANGE LOG
------------------------------------------
v0.3b - 2021-02-02:
    
    - Created images of game and custom symbols
    - Created TrueType font of the FF6 Menu Font
    - Uses text/BG colors chosen in the game
    - Fixed error with reading morph/steal item ID
    - Layout changed to display data in the same place in the window

v0.2b - 2021-01-18:

    - Shows item info from chests, steals, morphs, and drops
    - Shows item info highlight in shop sell menu
    - Flickering hopefully removed
    
v0.1b - 2020-12-21

    - Shows item info highlighted in party menus
    
TO CONTACT
------------------------------------------
Post any problems or suggestions you have in the Issues section of GitHub. All constructive critcism, feedback, and salty limericks welcome.
