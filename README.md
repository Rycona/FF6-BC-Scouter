# FF6 BC Scouter

Version:    0.4b  |  Date:       2021-02-28

FF6 BC Scouter: https://github.com/Rycona/FF6-BC-Scouter

Beyond Chaos EX Randomizer URL:    https://github.com/subtractionsoup/beyondchaos/releases/latest

Beyond Chaos Discord:           https://discord.gg/S3G3UXy

TO INTRODUCE
-------------
This repository holds a set of Lua scripts to aid in playing Beyond Chaos, a FF6 randomizer. This code will make a separate
window that will display extra contextual information about the game. This includes item info in places other than inventory (helpful
with 'masseffect' seeds) and spell/esper info in the Skills menu. The scope of this is to ease access of already viewable information.

TO USE
-----------------------------------------
- Install the FF6Menu.ttf in the Fonts folder to your Font directory
- Keep the Images folder inside the FF6BC Scouter folder
- Use with the BizHawk SNES Emulator (Tested with BizHawk v2.5.2/v2.6)
- Load only 'FF6BC Scouter v0.4.lua' from the folder

NOTE: Does not work with other emulators that support Lua scripts due to use of BizHawk-specific Lua Functions

FEATURES
-------------------------------------------
- Espers/Magic (v0.4)
    - compare equipped esper to cursored esper
    - see all espers that teach cursored spell and their rates in esper details menu
    - see all espers that have bonus that affects the same stat as the cursored bonus
    
- View info of equipment (v0.1 / v0.2)
    - under cursor in Item, Equip, and Relic Menus
    - under cursor info on the Shop Sell screen
    - under cursor info on the Shop Buy Screen, if at least 1 is owned (v0.31)
    - taken from chests
    - stolen, morphed, or dropped from enemies
        - NOTE: Steals/Morphs will display once next character/enemy perform an action
    
- Graphics (v0.3)
    - Uses the Menu font from FF6 for display
    - Text Color and Approximate Menu Window Background Colors chosen by player will be used

WHAT DOES X SYMBOL/TEXT MEAN?
-------------------------------------------
There is an accompanying image that explains custom symbols and names (Symbol and Text Descriptions.png). Sorry if the
symbols/texts aren't super-intuitive, but I haven't spent a ton of time on them.

TO DO
-------------------------------------------
- Display Esper equipability for Esper Allocator seeds ('dancingmaduin' code)
- Script for the Rage Menu to give info from the cursor without selecting, and maybe being able to sort/highlight by Elemental
    Affinities, Statuses, or Highest Multiplier
- Access item information while in battle
- Stat and Command overview for all party members from main manu

TO TEST
------------------------------------------
- Morph Item display with W+Ragnarok

CHANGE LOG
------------------------------------------
v0.4 - 2021-02-07:

    - Added Magic List, Esper/Spell/Level Bonus Comparison Displays
        for Skills menu and relevant submenus

v0.31b - 2021-02-27:

    - Bunches o' refactoring/restructuring
    - More advanced algorithm for primary program state detection
        (If in menu/battle/field/world)
    - Shows item info in shop buy menu if at least 1 of the
        highlighted item is currently owned

v0.3b - 2021-02-02:
    
    - Created images of game and custom symbols
    - Created TrueType font of the FF6 Menu Font
    - Uses text/BG colors chosen in the game
    - Fixed error with reading morph/steal item ID
    - Layout changed to display data in the same place in the window

v0.2b - 2021-01-18:

    - Shows item info from chests, steals, morphs, and drops
    - Shows item info highlighted in shop sell menu
    - Flickering hopefully removed
    
v0.1b - 2020-12-21

    - Shows item info highlighted in party menus
    
TO CONTACT
------------------------------------------
Post any problems or suggestions you have in the Issues section of GitHub. All constructive critcism, feedback, and salty limericks welcome.

SPECIAL THANKS
------------------------------------------
- Abyssonym for creating the original Beyond Chaos
- Beyond Chaos developers, graphic artists, music artists, and testers
- Beyond Chaos Barracks Discord community
- FF6Hacking.com
- And YOU (Even if you don't use this. Thanks for reading!)
