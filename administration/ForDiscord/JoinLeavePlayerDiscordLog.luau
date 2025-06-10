--!strict
--!selene: std = "roblox"

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local JoinLeavePlayerDiscordLogEvent = ReplicatedStorage:WaitForChild("JoinLeavePlayerDiscordLogEvent")
local DISCORD_WEBHOOK_URL = "" -- Insert your Webhook URL here!!

local function logPlayerJoin(player)
    local playerName = player.Name
    local playerId = player.UserId
    local playerDisplayName = player.DisplayName or playerName
    local playerTag = player.UserId -- or player.Name

    local logData = {
        playerId = playerId,
        playerName = playerName,
        playerDisplayName = playerDisplayName,
        playerTag = playerTag,
        action = "joined"
    }

    local jsonData = HttpService:JSONEncode(logData)

    HttpService:PostAsync(DISCORD_WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
end

Players.PlayerAdded:Connect(function(player)
    logPlayerJoin(player)
end)