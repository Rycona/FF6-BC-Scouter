--[[ Input is 2 bytes
    axlr---- Low Byte
    a: A button down
    x: X button down
    l: L button down
    r: R button down

    byetudlr High Byte
    b: B button down
    y: Y button down
    e: Select button down
    t: Start button down
    u: Up direction down
    d: Down direction down
    l: Left direction down
    r: Right direction down
]]
-- Low Byte
local AButton = 0x0080
local XButton = 0x0040
local LButton = 0x0020
local RButton = 0x0010

-- High Byte
local BButton = 0x8000
local YButton = 0x4000
local SelectButton = 0x2000
local StartButton = 0x1000
local UpButton = 0x0800
local DownButton = 0x0400
local LeftButton = 0x0200
local RightButton = 0x0100

-- Input Addresses
local buttonsPressedThisFrame = 0x08 -- Pressed this frame, but NOT last frame

function WasAButtonPressed()
    if bit.band(mainmemory.read_u16_le(buttonsPressedThisFrame), AButton) == AButton then
        return true
    end

    return false
end

function WasXButtonPressed()
    if bit.band(mainmemory.read_u16_le(buttonsPressedThisFrame), XButton) == XButton then
        return true
    end

    return false
end
