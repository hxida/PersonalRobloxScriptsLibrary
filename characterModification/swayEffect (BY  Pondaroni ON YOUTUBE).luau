--[=[ THIS SCRIPT IS NOT MADE BY ME, Pondaroni ON YOUTUBE.
                                          Sway Effect when Moving the Camera
                                         | - - - - - - - - - - - - - - - - - |
    This script makes the player's camera sway when moving the mouse.
	You can find the similiar system in the game "Doors" by LSPLASH.
]=]

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Turn = 0

local Lerp = function(a, b, t)
	return a + (b - a) * t
end;

RunService:BindToRenderStep("CameraSway", Enum.RenderPriority.Camera.Value + 1, function(deltaTime)
	local MouseDelta = UserInputService:GetMouseDelta()

	Turn = Lerp(Turn, math.clamp(MouseDelta.X, -7.5, 7.5), (7 * deltaTime))

	Camera.CFrame = Camera.CFrame * CFrame.Angles(0, 0, math.rad(Turn))
end)