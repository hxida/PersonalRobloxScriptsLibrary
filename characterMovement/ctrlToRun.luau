--[=[
                                              CTRL to Run with FOV Change
                                         | - - - - - - - - - - - - - - - - - |
    This script allows the player to run +6 speed faster and change the FOV smoothly when holding the CTRL key.
]=]

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local function changeFOV(targetFOV, duration) -- You can remove this function if you don't want the FOV change.
    local camera = workspace.CurrentCamera
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear) -- The thing that makes the change smooth. Edit or delete it however y want.
    local goal = {FieldOfView = targetFOV}
    local tween = TweenService:Create(camera, info, goal)
    tween:Play()
end

LocalPlayer.CharacterAdded:Connect(function(Character)
    local Humanoid = Character:WaitForChild("Humanoid")

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.LeftControl and not gameProcessed then
            Humanoid.WalkSpeed = 18
            changeFOV(96, 0.5)  -- Change FOV to 96 over 0.5 seconds // Remove this line if you don't want the FOV change.
        end
    end)

    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.LeftControl and not gameProcessed then
            Humanoid.WalkSpeed = 12
            changeFOV(80, 0.5)  -- Change FOV to 80 over 0.5 seconds // Remove this line if you don't want the FOV change.
        end
    end)
end)

-- STARTERPLAYERSCRIPTS