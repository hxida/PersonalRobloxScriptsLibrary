--[=[
                                               Hold R to Open Emote Frame
                                         | - - - - - - - - - - - - - - - - - |
    This script allows the player to open the Emote Frame by holding the R key.
]=]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")
local EmoteFrame = ScreenGui:WaitForChild("EmoteFrame") -- I put my own GUI name here, you can change it to your own GUI name.

local toggleEmoteKeyCode = Enum.KeyCode.R -- CHANGE THIS TO YOUR DESIRED KEY, EXAMPLE: FOR E KEY ==> "Enum.KeyCode.E"

if EmoteFrame then
    EmoteFrame.Visible = false
end -- You can remove this line if you want the EmoteFrame to be visible by default.

local function onInputBegan(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end -- Keep this line to prevent the script from running if the key is already processed by another UI.

    if input.KeyCode == toggleEmoteKeyCode then
        if EmoteFrame then -- If you want to add anything else
            EmoteFrame.Visible = true
        end
    end
end

local function onInputEnded(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end -- Keep this line to prevent the script from running if the key is already processed by another UI.

    if input.KeyCode == toggleEmoteKeyCode then
        if EmoteFrame then
            EmoteFrame.Visible = false
        end
    end
end

UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputEnded:Connect(onInputEnded)