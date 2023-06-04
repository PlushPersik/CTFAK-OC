-- CTFAK 2.0 by Kostya and Yunivers
-- Ported on MineOS by CackeMC & PlushPersik
-- Version 2.3

local system = require("system")
local GUI = require("gui")
local filesystem = require("filesystem")
local event = require("Event")
local alreadySelected = false
local Paths = require("Paths")
local resized = false

local workspace, window, main = system.addWindow(GUI.filledWindow(1, 1, 120, 40, 0x1f1f1f))

local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

local developers = window:addChild(GUI.layout(3, 20, window.width, window.height, 4, 1))

layout:addChild(GUI.text(1, 1, 0xd48a00, "---------------"))
layout:addChild(GUI.text(1, 1, 0xd48a00, "CTFAK 2.0"))
layout:addChild(GUI.text(1, 1, 0xd48a00, "---------------"))
local label = developers:addChild(GUI.label(1, 1, 25, 1, 0xFFFFFF, "Developers: PlushPersik, CackeMC"))

local function open(path)
	local filesystemDialog = GUI.addFilesystemDialog(workspace, true, 50, math.floor(window.height * 0.8), "Open", "Cancel", "Filename", "/")
	filesystemDialog:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
	filesystemDialog:addExtensionFilter(".lua")
	filesystemDialog:show()

	filesystemDialog.onSubmit = function(path)
        file = filesystem.read(path) 
        alreadySelected = true
        print("Game path: " .. path)
        if file ~= nil then           
            print("Detected MineOS application/screensaver!")
        else
            error("The MineOS app could not be found.")
        end
        print("Close this window to contiune.")
        
    end
end



local selectFile = layout:addChild(GUI.button(1, 1, 25, 3, 0x4B4B4B, 0xFFFFFF, 0x0, 0xFFFFFF, "Select Game"))

selectFile.onTouch = function()
    if alreadySelected == false then
        open()  
    else
        GUI.alert("File already has been loaded!")
    end
end

local Decompile = layout:addChild(GUI.button(1, 1, 25, 3, 0x4B4B4B, 0xFFFFFF, 0x0, 0xFFFFFF, "Decompile"))

Decompile.onTouch = function()
    local newDump = filesystem.read("/Applications/CTFAK 2.0.app/Dumps/Main.lua")     
    newDump = file
    local dumpedFile = filesystem.write("/Applications/CTFAK 2.0.app/Dumps/Main.lua", newDump)
    if dumpedFile ~= nil then
        system.execute(Paths.system.applicationFinder, "-o", "/Applications/CTFAK 2.0.app/Dumps/")
        window:remove()
    end
end

window.onResize = function(newWidth, newHeight)
    window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
    layout.width, layout.height = newWidth, newHeight
    developers.width, developers.height = newWidth, newHeight
end

workspace:draw()