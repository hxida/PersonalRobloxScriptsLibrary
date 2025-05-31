--[=[
                                      Ban the player & log it to Discord System
                                         | - - - - - - - - - - - - - - - - - |
    This script basically integrates with Discord Webhooks to log bans and unbans, and updates the client with the current ban list.
    Features are:
       - Logs the banned player's UserId, name, reason, and admins username that banned them to a Discord channel.
       - It also logs unbans with the same info.
    I'm quiet surprised that this integration works well, since Roblox has a heavy censorship on Discord links n texts, I guess developers luck.
]=]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")

local BanUserRequestEvent = ReplicatedStorage:WaitForChild("BanUserRequestEvent")
local UnbanUserRequestEvent = ReplicatedStorage:WaitForChild("UnbanUserRequestEvent")
local UpdateClientBanListEvent = ReplicatedStorage:WaitForChild("UpdateClientBanListEvent")
local RequestFullBanListEvent = ReplicatedStorage:WaitForChild("RequestFullBanListEvent")

local DISCORD_WEBHOOK_URL = "" -- Insert your Webhook URL here!!

local bannedUsersCache = {} -- Example: { [userIdString] = {reason = "Exploiting", admin = "AdminPlayerName", timestamp = os.time()} }

-- BAN
local function sendToDiscordBanLog(bannedUserName, adminUserName, reason)
    if not DISCORD_WEBHOOK_URL or DISCORD_WEBHOOK_URL == "" then
        warn("Discord webhook URL is not set. Cannot send ban log.")
        return
    end

    local embed = { -- The main log message for Banning.
        title = "Player Banned",
        description = string.format("**User:** %s\n**Banned By:** %s\n**Reason:** %s",
                                    bannedUserName or "N/A",
                                    adminUserName or "N/A",
                                    reason or "No reason provided."),
        color = 15158332, -- Red color (decimal)
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), -- ISO8601 timestamp for Discord
        footer = {
            text = "somethin Moderation Logs"
        }
    }

    local payload = {
        embeds = {embed}
    }

    local success, err = pcall(function()
        local jsonData = HttpService:JSONEncode(payload)
        HttpService:PostAsync(DISCORD_WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        warn("Failed to send ban log to Discord: " .. tostring(err))
    else
        print("Ban log sent to Discord successfully for user: " .. (bannedUserName or "N/A"))
    end
end

-- UNBAN
local function sendToDiscordUnbanLog(unbannedUserName, adminUserName)
    if not DISCORD_WEBHOOK_URL or DISCORD_WEBHOOK_URL == "" then
        warn("Discord webhook URL is not set. Cannot send unban log.")
        return
    end

    local embed = { -- The main log message for Unbanning.
        title = "Player Unbanned",
        description = string.format("**User:** %s\n**Unbanned By:** %s",
                                    unbannedUserName or "N/A",
                                    adminUserName or "N/A"),
        color = 3066993, -- Green color (decimal)
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), -- ISO8601 timestamp for Discord
        footer = {
            text = "somethin Moderation Logs"
        }
    }

    local payload = {
        embeds = {embed}
    }

    local success, err = pcall(function()
        local jsonData = HttpService:JSONEncode(payload)
        HttpService:PostAsync(DISCORD_WEBHOOK_URL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if not success then
        warn("Failed to send unban log to Discord: " .. tostring(err))
    else
        print("Unban log sent to Discord successfully for user: " .. (unbannedUserName or "N/A"))
    end
end

local function onBanUserRequest(adminPlayer, targetUserId, reason)
    if not adminPlayer or not targetUserId then
        warn("Ban request received with invalid parameters.")
        return
    end

    local adminName = adminPlayer.Name
    local targetUserIdStr = tostring(targetUserId)

    print(string.format("Ban request: Admin '%s' banning UserID '%s' for reason: '%s'", adminName, targetUserIdStr, reason or "N/A"))

    if bannedUsersCache[targetUserIdStr] then
        print(string.format("UserID '%s' is already banned. Reason: %s", targetUserIdStr, bannedUsersCache[targetUserIdStr].reason))
        return
    end

    local targetUserName = "UserID: " .. targetUserIdStr
    local targetPlayer = Players:GetPlayerByUserId(tonumber(targetUserId))

    if targetPlayer then
        targetUserName = targetPlayer.Name
        print(string.format("Target player '%s' (ID: %s) is online.", targetUserName, targetUserIdStr))
    else
        print(string.format("Target UserID '%s' is offline. Attempting to fetch name...", targetUserIdStr))
        local success, nameOrError = pcall(function()
            return Players:GetNameFromUserIdAsync(tonumber(targetUserId))
        end)
        if success and nameOrError then
            targetUserName = nameOrError
            print(string.format("Successfully fetched offline player name: '%s' for UserID '%s'", targetUserName, targetUserIdStr))
        else
            warn(string.format("Could not fetch name for offline UserID '%s'. Error: %s", targetUserIdStr, tostring(nameOrError)))
        end
    end

    bannedUsersCache[targetUserIdStr] = {
        reason = reason or "No reason provided.",
        admin = adminName,
        timestamp = os.time()
    }
    print(string.format("UserID '%s' (%s) has been banned by '%s'. Reason: %s", targetUserIdStr, targetUserName, adminName, reason or "N/A"))

    if targetPlayer then
        targetPlayer:Kick("You have been banned from this game. Reason: " .. (reason or "No reason provided."))
    end

    sendToDiscordBanLog(targetUserName, adminName, reason)
    UpdateClientBanListEvent:FireAllClients(bannedUsersCache)
end

RequestFullBanListEvent.OnServerEvent:Connect(function(player)
    if player then
        UpdateClientBanListEvent:FireClient(player, bannedUsersCache)
    end
end)

UnbanUserRequestEvent.OnServerEvent:Connect(function(adminPlayer, targetUserIdToUnban)
    local targetUserIdStrToUnban = tostring(targetUserIdToUnban)
    if bannedUsersCache[targetUserIdStrToUnban] then
        local unbannedUserName = "UserID: " .. targetUserIdStrToUnban
        local success, nameOrError = pcall(function()
            return Players:GetNameFromUserIdAsync(tonumber(targetUserIdToUnban))
        end)
        if success and nameOrError then
            unbannedUserName = nameOrError
        end

        bannedUsersCache[targetUserIdStrToUnban] = nil
        print(string.format("UserID '%s' (%s) has been unbanned by '%s'.", targetUserIdStrToUnban, unbannedUserName, adminPlayer.Name))
        
        sendToDiscordUnbanLog(unbannedUserName, adminPlayer.Name)
        
        UpdateClientBanListEvent:FireAllClients(bannedUsersCache)
    else
        print(string.format("UserID '%s' was not found in the ban cache.", targetUserIdStrToUnban)) -- Optionally notify admin that user wasn't banned
    end
end)

BanUserRequestEvent.OnServerEvent:Connect(onBanUserRequest)

print("BanSystemServer with Discord logging and client updates has been initialized.")

