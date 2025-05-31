--[=[
                                                    Admin Check Script
                                         | - - - - - - - - - - - - - - - - - |
    This script checks if the player is an admin and makes the Admin button visible if they are.
    The admin button is only visible for the players that are defined in the `adminUserIds` table which is the 20th line!!!!!!!
]=]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local adminButton = script.Parent
local localPlayer = Players.LocalPlayer

-- The part to identify the admin menu n it's button
local menuButtonsFrame = adminButton.Parent
local menusFolder = menuButtonsFrame:WaitForChild("Menus")
local adminMenu = menusFolder:WaitForChild("AdminMenu") -- Change this to the actual name of your admin menu!

local adminUserIds = { -- Change this to the actual UserIds of your admins!
	[1518893691] = true, -- Owner - Doe_JohnRBLX
	[1440984798] = true, -- Admin - K6SQ
	[1372754255] = true, -- Admin - Wh1itleeYT
	[1900080788] = true  -- Admin - Wolf4Champ
	[261] = true -- Admin (Special) - Shedletsky Telamon
} -- I love tables

local openPosition = UDim2.new(1.566, 0, -0.731, 0)
local closedPosition = UDim2.new(1.554, 0, 2.4, 0)
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) -- The animation

local isAdminMenuOpen = false

adminMenu.Position = closedPosition
adminMenu.Visible = false

if adminUserIds[localPlayer.UserId] then
	adminButton.Visible = true

	adminButton.MouseButton1Click:Connect(function()
		isAdminMenuOpen = not isAdminMenuOpen

		if isAdminMenuOpen then
			adminMenu.Visible = true
			local openTween = TweenService:Create(adminMenu, tweenInfo, {Position = openPosition}) -- Feel free removing the tween if you want it to open instantly or just keep it.
			openTween:Play()
		else
			local closeTween = TweenService:Create(adminMenu, tweenInfo, {Position = closedPosition})
			closeTween:Play()
			closeTween.Completed:Connect(function(plybackState)
				if plybackState == Enum.PlaybackState.Completed and not isAdminMenuOpen then
					adminMenu.Visible = false
				end
			end)
		end
	end)
else
	adminButton.Visible = false
	adminMenu.Visible = false
	adminMenu.Position = closedPosition
end

