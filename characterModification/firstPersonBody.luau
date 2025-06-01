--[=[
                                            Body Parts in First Person View
                                         | - - - - - - - - - - - - - - - - - |
    This script makes the player's body parts visible in first person view, while keeping the head invisible.
]=]

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    for _, part in character:GetChildren() do
        if part:IsA("BasePart") then
            if part.Name == "Head" then
                part.LocalTransparencyModifier = 1 -- Makes head invisible.
            else
                part.LocalTransparencyModifier = 0 -- Makes other body parts visible.
            end
        end
    end
    
    humanoid.CameraOffset = Vector3.new(0, 0, -1) -- Sets the camera offset for first person view.
end)