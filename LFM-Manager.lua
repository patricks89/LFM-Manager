-- Import necessary libraries
local MyRaidAddon = LibStub("AceAddon-3.0"):NewAddon("MyRaidAddon", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceEvent = LibStub("AceEvent-3.0")

-- Raid configurations (updated with new instances and level/ilvl information)
local raidConfig = {
    -- Dungeons
    RFC = { RaidName = "Ragefire Chasm", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 13, minIlvl = 15 },
    WC = { RaidName = "Wailing Caverns", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 17, minIlvl = 15 },
    DEADMINES = { RaidName = "The Deadmines", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 17, minIlvl = 15 },
    SFK = { RaidName = "Shadowfang Keep", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 22, minIlvl = 20 },
    BFD = { RaidName = "Blackfathom Deeps", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 24, minIlvl = 20 },
    STOCKADES = { RaidName = "The Stockade", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 24, minIlvl = 20 },
    GNO = { RaidName = "Gnomeregan", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 29, minIlvl = 25 },
    RFD = { RaidName = "Razorfen Downs", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 29, minIlvl = 25 },
    SM_GRAVEYARD = { RaidName = "Scarlet Monastery - Graveyard", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 26, minIlvl = 20 },
    SM_LIBRARY = { RaidName = "Scarlet Monastery - Library", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 29, minIlvl = 25 },
    SM_ARMORY = { RaidName = "Scarlet Monastery - Armory", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 32, minIlvl = 25 },
    SM_CATHEDRAL = { RaidName = "Scarlet Monastery - Cathedral", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 35, minIlvl = 30 },
    RFD2 = { RaidName = "Razorfen Kraul", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 37, minIlvl = 30 },
    ULDAMAN = { RaidName = "Uldaman", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 41, minIlvl = 35 },
    ZF = { RaidName = "Zul'Farrak", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 44, minIlvl = 40 },
    MARAUDON = { RaidName = "Maraudon", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 46, minIlvl = 40 },
    ST = { RaidName = "The Temple of Atal'Hakkar", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 50, minIlvl = 45 },
    BRD = { RaidName = "Blackrock Depths", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 52, minIlvl = 45 },
    LBRS = { RaidName = "Lower Blackrock Spire", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 55, minIlvl = 50 },
    UBRS = { RaidName = "Upper Blackrock Spire", RaidSize = 10, NeedTanks = 2, NeedHealers = 2, NeedDPS = 6, minLevel = 55, minIlvl = 50 },
    DM_EAST = { RaidName = "Dire Maul East", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 55, minIlvl = 50 },
    DM_WEST = { RaidName = "Dire Maul West", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 58, minIlvl = 50 },
    DM_NORTH = { RaidName = "Dire Maul North", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 58, minIlvl = 55 },
    STRATH = { RaidName = "Stratholme", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 58, minIlvl = 55 },
    SCHOLO = { RaidName = "Scholomance", RaidSize = 5, NeedTanks = 1, NeedHealers = 1, NeedDPS = 3, minLevel = 58, minIlvl = 55 },
    -- Raids
    ZG = { RaidName = "Zul'Gurub", RaidSize = 20, NeedTanks = 2, NeedHealers = 5, NeedDPS = 13, minLevel = 55, minIlvl = 50 },
    AQ20 = { RaidName = "Ruins of Ahn'Qiraj", RaidSize = 20, NeedTanks = 2, NeedHealers = 5, NeedDPS = 13, minLevel = 55, minIlvl = 55 },
    MC = { RaidName = "Molten Core", RaidSize = 40, NeedTanks = 4, NeedHealers = 10, NeedDPS = 26, minLevel = 55, minIlvl = 55 },
    ONY = { RaidName = "Onyxia's Lair", RaidSize = 40, NeedTanks = 2, NeedHealers = 5, NeedDPS = 13, minLevel = 58, minIlvl = 55 },
    BWL = { RaidName = "Blackwing Lair", RaidSize = 40, NeedTanks = 4, NeedHealers = 10, NeedDPS = 26, minLevel = 58, minIlvl = 60 },
    AQ40 = { RaidName = "Temple of Ahn'Qiraj", RaidSize = 40, NeedTanks = 4, NeedHealers = 10, NeedDPS = 26, minLevel = 58, minIlvl = 60 },
    NAXX = { RaidName = "Naxxramas", RaidSize = 40, NeedTanks = 4, NeedHealers = 10, NeedDPS = 26, minLevel = 58, minIlvl = 65 },
}

local selectedRaid = "SCHOLO"
local autoInviteEnabled = false
local autoReplyEnabled = false
local selectedChannels = {}
-- Removed minimalIlvl and minimumLevel as per user request

-- Active player lists (in the raid)
local activeTank = {}
local activeHealer = {}
local activeRange = {}
local activeMelee = {}

-- Players without assigned roles
local playersWithoutRole = {}

-- Conversation list (requests)
local conversationList = {}

-- GearScore storage
local playerItemLevels = {}

-- Player level storage
local playerLevels = {}

-- Stored invited players
local invitedPlayers = {}

local channelOptions = {
    "YELL",
    "GUILD",
    "SAY",
    "CHANNEL 1",
    "CHANNEL 2",
    "CHANNEL 3",
    "CHANNEL 4",
    "CHANNEL 5",
    "CHANNEL 6",
    "CHANNEL 7",
    "CHANNEL 8",
}

local mainFrame -- Declare mainFrame globally
local invitedPlayersFrame -- Declare invitedPlayersFrame globally

-- Function to update selected channels
local function updateSelectedChannel(channel, isChecked)
    if isChecked then
        selectedChannels[channel] = true
    else
        selectedChannels[channel] = nil
    end
    MyRaidAddon.db.profile.selectedChannels = selectedChannels
end

-- Function to initialize selected channels
local function initializeSelectedChannels()
    if not MyRaidAddon.db.profile.selectedChannels then
        MyRaidAddon.db.profile.selectedChannels = {}
    end
    selectedChannels = MyRaidAddon.db.profile.selectedChannels
end

-- Function to display selected channels (Debug)
function MyRaidAddon:PrintSelectedChannels()
    print("Selected Channels:")
    for channel, isSelected in pairs(selectedChannels) do
        if isSelected then
            print(channel)
        end
    end
end

-- Ensure player names always include the realm
local function getFullPlayerName(name)
    if not name:find("-") then
        name = name .. "-" .. GetRealmName()
    end
    return name
end

-- Ensure consistent player names
local function getShortName(fullName)
    return fullName:match("^(.-)%-.+") or fullName
end

-- Utility function to check if a player is already in an active list
local function isPlayerInActiveList(nameWithRealm)
    return tContains(activeTank, nameWithRealm) or tContains(activeHealer, nameWithRealm) or tContains(activeRange, nameWithRealm) or tContains(activeMelee, nameWithRealm)
end

-- Utility function to check if a player is in the group
local function isPlayerInGroup(nameWithRealm)
    local numGroupMembers = GetNumGroupMembers()
    local isRaid = IsInRaid()

    for i = 1, numGroupMembers do
        local unit
        if isRaid then
            unit = "raid" .. i
        else
            if i == numGroupMembers then
                unit = "player"
            else
                unit = "party" .. i
            end
        end
        local name = GetUnitName(unit, true)
        if name then
            name = getFullPlayerName(name)
            if name == nameWithRealm then
                return true
            end
        end
    end
    return false
end

-- Utility function to remove a player from pending lists
local function removeFromPendingLists(nameWithRealm)
    local function removeFromList(list)
        for i, name in ipairs(list) do
            if name == nameWithRealm then
                table.remove(list, i)
                return true
            end
        end
        return false
    end

    removeFromList(conversationList)
    removeFromList(playersWithoutRole)
end

-- Utility function to remove a player from all active lists
local function removeFromAllActiveLists(nameWithRealm)
    local function removeFromList(list)
        for i, name in ipairs(list) do
            if name == nameWithRealm then
                table.remove(list, i)
                return true
            end
        end
        return false
    end

    removeFromList(activeTank)
    removeFromList(activeHealer)
    removeFromList(activeRange)
    removeFromList(activeMelee)
    removeFromList(conversationList)
    removeFromList(playersWithoutRole)
end

-- Utility function to check if a player can be added to a specific role list
local function canAddToRole(role)
    local config = raidConfig[selectedRaid]
    if role == "tank" and #activeTank >= config.NeedTanks then
        return false
    elseif role == "healer" and #activeHealer >= config.NeedHealers then
        return false
    elseif (role == "range" or role == "melee") and (#activeRange + #activeMelee) >= config.NeedDPS then
        return false
    end
    return true
end

-- Function to update the list of players without assigned roles
local function updatePlayersWithoutRole()
    playersWithoutRole = {}

    -- Add group members without assigned roles
    local numGroupMembers = GetNumGroupMembers()
    local isRaid = IsInRaid()

    for i = 1, numGroupMembers do
        local unit
        if isRaid then
            unit = "raid" .. i
        else
            if i == numGroupMembers then
                unit = "player"
            else
                unit = "party" .. i
            end
        end

        local name = GetUnitName(unit, true) -- true to get the realm name
        if name and name:find("-") then
            name = getFullPlayerName(name)
            -- Check if the player is already assigned to a role
            if not isPlayerInActiveList(name) then
                if not tContains(playersWithoutRole, name) then
                    table.insert(playersWithoutRole, name)
                end
            end
        end
    end

    -- Add players from the conversation list
    for _, playerName in ipairs(conversationList) do
        if playerName:find("-") then
            if not tContains(playersWithoutRole, playerName) and not isPlayerInActiveList(playerName) then
                table.insert(playersWithoutRole, playerName)
            end
        end
    end

    -- Add players from invitedPlayers without assigned roles, only if they are still in the group
    for playerName, data in pairs(MyRaidAddon.db.profile.invitedPlayers) do
        if playerName:find("-") then
            if not isPlayerInActiveList(playerName) and data.status ~= "Excluded" and isPlayerInGroup(playerName) then
                if not tContains(playersWithoutRole, playerName) then
                    table.insert(playersWithoutRole, playerName)
                end
            end
        end
    end

    -- Ensure that the Raid Leader is included in "playersWithoutRole" if not assigned a role
    local raidLeaderName = GetUnitName("player", true)
    if raidLeaderName then
        raidLeaderName = getFullPlayerName(raidLeaderName)
        if raidLeaderName:find("-") then
            if not isPlayerInActiveList(raidLeaderName) and not tContains(playersWithoutRole, raidLeaderName) then
                table.insert(playersWithoutRole, raidLeaderName)
            end
        end
    end
end

-- Function to check roles and update playersWithoutRole
local function CheckRole()
    updatePlayersWithoutRole()
    MyRaidAddon:UpdateRoleManagementPage()
end

-- Function to get the class color for a player
local function getClassColor(playerName)
    local classColor = "ffffffff" -- Default to white
    local class

    -- Try to get the class from group members
    for i = 1, GetNumGroupMembers() do
        local unit
        if IsInRaid() then
            unit = "raid" .. i
        else
            if i == GetNumGroupMembers() then
                unit = "player"
            else
                unit = "party" .. i
            end
        end
        local name = GetUnitName(unit, true)
        name = getFullPlayerName(name)
        if name == playerName then
            _, class = UnitClass(unit)
            break
        end
    end

    -- If class was found, get color
    if class then
        local color = RAID_CLASS_COLORS[class]
        if color then
            classColor = string.format("%02x%02x%02x%02x", 255, color.r * 255, color.g * 255, color.b * 255)
        end
    else
        -- Try to get the class from the invitedPlayers database
        if MyRaidAddon.db.profile.invitedPlayers[playerName] and MyRaidAddon.db.profile.invitedPlayers[playerName].class then
            class = MyRaidAddon.db.profile.invitedPlayers[playerName].class
            local color = RAID_CLASS_COLORS[class]
            if color then
                classColor = string.format("%02x%02x%02x%02x", 255, color.r * 255, color.g * 255, color.b * 255)
            end
        end
    end

    return classColor
end

-- Adjusted extractRole function
local function extractRole(msg)
    local lowerMsg = string.lower(msg)
    if string.find(lowerMsg, "tank") then
        return "tank"
    elseif string.find(lowerMsg, "heal") then
        return "healer"
    elseif string.find(lowerMsg, "melee") or string.find(lowerMsg, "rog") or string.find(lowerMsg, "rogue") then
        return "melee"
    elseif string.find(lowerMsg, "range") or string.find(lowerMsg, "mage") or string.find(lowerMsg, "lock") or string.find(lowerMsg, "shadow") or string.find(lowerMsg, "hunt") or string.find(lowerMsg, "ele") or string.find(lowerMsg, "owl") then
        return "range"
    else
        return nil
    end
end

-- Function to assign player roles based on their whispers
local function onWhisper(event, msg, sender)
    local role = extractRole(msg)
    local nameWithRealm = getFullPlayerName(sender)

    -- Ensure we have the name in the format name-realm
    if not nameWithRealm:find("-") then
        -- No realm found, do not process
        return
    end

    -- Check if the player is excluded
    if MyRaidAddon.db.profile.invitedPlayers and MyRaidAddon.db.profile.invitedPlayers[nameWithRealm] and MyRaidAddon.db.profile.invitedPlayers[nameWithRealm].status == "Excluded" then
        if autoReplyEnabled then
            SendChatMessage("You are excluded from this raid.", "WHISPER", nil, sender)
        end
        return
    end

    if not role then
        -- If no role was found, add player to conversation list
        if not tContains(conversationList, nameWithRealm) then
            table.insert(conversationList, nameWithRealm)
            -- Update status in invitedPlayers
            MyRaidAddon:AddToInvitedPlayers(nameWithRealm, nil, "request")
            if autoReplyEnabled then
                SendChatMessage("Please specify your role (tank / heal / range / melee) for automatic invitation.", "WHISPER", nil, sender)
            end
            MyRaidAddon:UpdateRoleManagementPage()
        end
        return
    end

    -- Check if a slot is available for the role
    if not canAddToRole(role) then
        if autoReplyEnabled then
            SendChatMessage("Sorry, all slots for your role are already filled.", "WHISPER", nil, sender)
        end
        return
    end

    -- Add player to the corresponding role list
    if role == "tank" then
        table.insert(activeTank, nameWithRealm)
    elseif role == "healer" then
        table.insert(activeHealer, nameWithRealm)
    elseif role == "range" then
        table.insert(activeRange, nameWithRealm)
    elseif role == "melee" then
        table.insert(activeMelee, nameWithRealm)
    end

    -- Remove from pending lists if present
    removeFromPendingLists(nameWithRealm)

    if autoReplyEnabled then
        SendChatMessage("You have been registered as " .. role .. ".", "WHISPER", nil, sender)
    end

    if autoInviteEnabled then
        InviteUnit(nameWithRealm) -- Use full name for invitation
        -- Update status to "invited"
        MyRaidAddon:AddToInvitedPlayers(nameWithRealm, role, "invited")
    else
        -- Update status to "active" if already in the group
        MyRaidAddon:AddToInvitedPlayers(nameWithRealm, role, "active")
    end

    -- Update role management page
    MyRaidAddon:UpdateRoleManagementPage()
end

-- Function to add a player to the invited players list
function MyRaidAddon:AddToInvitedPlayers(playerName, role, status)
    if not self.db.profile.invitedPlayers then
        self.db.profile.invitedPlayers = {}
    end
    -- Get class if possible
    local class
    for i = 1, GetNumGroupMembers() do
        local unit
        if IsInRaid() then
            unit = "raid" .. i
        else
            if i == GetNumGroupMembers() then
                unit = "player"
            else
                unit = "party" .. i
            end
        end
        local name = GetUnitName(unit, true)
        name = getFullPlayerName(name)
        if name == playerName then
            _, class = UnitClass(unit)
            break
        end
    end

    -- Update existing entry or create new one
    self.db.profile.invitedPlayers[playerName] = self.db.profile.invitedPlayers[playerName] or {}
    local playerData = self.db.profile.invitedPlayers[playerName]
    playerData.lastRole = role or playerData.lastRole
    playerData.ilvl = playerItemLevels[playerName] or playerData.ilvl or 0
    playerData.status = status or playerData.status or "request"
    playerData.class = class or playerData.class
end

-- Function to announce active lists in raid or group chat
local function announceActiveLists()
    local chatType = "PARTY" -- Default to party chat

    if IsInRaid() then
        chatType = "RAID"
    elseif IsInGroup() then
        chatType = "PARTY"
    end

    SendChatMessage("Role assignments:", chatType)
    SendChatMessage("Tanks: " .. table.concat(activeTank, ", "), chatType)
    SendChatMessage("Healers: " .. table.concat(activeHealer, ", "), chatType)
    SendChatMessage("Melee DPS: " .. table.concat(activeMelee, ", "), chatType)
    SendChatMessage("Range DPS: " .. table.concat(activeRange, ", "), chatType)
end

-- Function to initiate gear inspection of group members
local function inspectGroupMembers()
    for i = 1, GetNumGroupMembers() do
        local unit
        if IsInRaid() then
            unit = "raid" .. i
        else
            if i == GetNumGroupMembers() then
                unit = "player"
            else
                unit = "party" .. i
            end
        end

        if UnitIsConnected(unit) and CheckInteractDistance(unit, 1) then
            NotifyInspect(unit)
        end
    end
end

-- Event handler for INSPECT_READY
local function onInspectReady(event, guid)
    for i = 1, GetNumGroupMembers() do
        local unit
        if IsInRaid() then
            unit = "raid" .. i
        else
            if i == GetNumGroupMembers() then
                unit = "player"
            else
                unit = "party" .. i
            end
        end

        if UnitGUID(unit) == guid then
            local totalItemLevel = 0
            local itemCount = 0

            for slot = 1, 17 do
                if slot ~= 4 then -- Skip shirt slot
                    local itemLink = GetInventoryItemLink(unit, slot)
                    if itemLink then
                        local _, _, _, itemLevel = GetItemInfo(itemLink)
                        if itemLevel then
                            totalItemLevel = totalItemLevel + itemLevel
                            itemCount = itemCount + 1
                        end
                    end
                end
            end

            if itemCount > 0 then
                local avgItemLevel = totalItemLevel / itemCount
                local name = GetUnitName(unit, true)
                name = getFullPlayerName(name)
                playerItemLevels[name] = math.floor(avgItemLevel + 0.5) -- Round to the nearest whole number
                -- Update ilvl in invitedPlayers if present
                if MyRaidAddon.db.profile.invitedPlayers[name] then
                    MyRaidAddon.db.profile.invitedPlayers[name].ilvl = playerItemLevels[name]
                end
                MyRaidAddon:UpdateRoleManagementPage()
            end
            break
        end
    end
end

-- Function to update the role management page
function MyRaidAddon:UpdateRoleManagementPage()
    if mainFrame and mainFrame:IsVisible() and mainFrame.currentPage == "RoleManagement" then
        self:CreateRoleManagementPage()
    end
end

-- Funktion zur Aktualisierung des Status aller Spieler basierend auf den definierten Regeln
local function updatePlayerStatuses()
    local numGroupMembers = GetNumGroupMembers()
    local isRaid = IsInRaid()

    -- Erstelle eine Tabelle zur Zuordnung von Spielernamen zu Einheiten
    local groupMembers = {}
    for i = 1, numGroupMembers do
        local unit
        if isRaid then
            unit = "raid" .. i
        else
            if i == numGroupMembers then
                unit = "player"
            else
                unit = "party" .. i
            end
        end
        local name = GetUnitName(unit, true)
        if name then
            name = getFullPlayerName(name)
            groupMembers[name] = unit
        end
    end

    -- Durchlaufe alle eingeladenen Spieler und setze deren Status
    for playerName, data in pairs(MyRaidAddon.db.profile.invitedPlayers) do
        if groupMembers[playerName] then
            -- Spieler ist in der Gruppe
            local unit = groupMembers[playerName]
            if isPlayerInActiveList(playerName) then
                if UnitIsConnected(unit) then
                    -- Spieler ist in der Gruppe, hat eine Rolle und ist online
                    data.status = "active"
                else
                    -- Spieler ist in der Gruppe, hat eine Rolle aber ist offline
                    data.status = "offline"
                end
            else
                if UnitIsConnected(unit) then
                    -- Spieler ist in der Gruppe, hat keine Rolle
                    data.status = "no Role selected"
                else
                    -- Spieler ist in der Gruppe, hat keine Rolle und ist offline
                    data.status = "offline"
                end
            end
        else
            -- Spieler ist nicht in der Gruppe
            if data.status == "invited" or data.status == "active" or data.status == "offline" or data.status == "no Role selected" then
                -- Spieler ist nicht in der Gruppe, aber eine Einladung wurde gesendet
                data.status = "invited"
            elseif data.status == "request" then
                -- Spieler ist nicht in der Gruppe und hat eine Anfrage gestellt
                -- Status bleibt "request"
            end
        end
    end
end

-- Update the role management page on group changes
local function onRosterUpdate()
    updatePlayersWithoutRole()
    updatePlayerStatuses()
    MyRaidAddon:UpdateRoleManagementPage()
    inspectGroupMembers() -- Attempt to inspect group members
end

-- Function to post raid messages
local function postRaid(raidName)
    local config = raidConfig[raidName]
    if not config then
        print("Invalid raid name specified.")
        return
    end

    local currentTanks = #activeTank
    local currentHealers = #activeHealer
    local currentRange = #activeRange
    local currentMelee = #activeMelee
    local currentDPS = currentRange + currentMelee

    local raidOptionText = config.raidOption and (config.raidOption .. " - ") or ""

    local message = string.format(
        "LFM %s - %sTank: %d/%d, Heal: %d/%d, DPS: %d/%d (Range: %d, Melee: %d)",
        config.RaidName,
        raidOptionText,
        currentTanks, config.NeedTanks,
        currentHealers, config.NeedHealers,
        currentDPS, config.NeedDPS,
        currentRange,
        currentMelee
    )

    local sentChannels = {}

    for channel, enabled in pairs(selectedChannels) do
        if enabled and not sentChannels[channel] then
            if string.sub(channel, 1, 7) == "CHANNEL" then
                local channelNumber = tonumber(string.sub(channel, 9))
                if channelNumber and GetChannelName(channelNumber) ~= 0 then
                    SendChatMessage(message, "CHANNEL", nil, channelNumber)
                    print("Message sent to channel number:", channelNumber)
                    sentChannels[channel] = true
                else
                    print("Invalid or non-existent channel number:", channelNumber)
                end
            else
                if channel == "GUILD" or channel == "SAY" or channel == "YELL" or channel == "RAID" or channel == "PARTY" then
                    SendChatMessage(message, channel)
                    print("Message sent to " .. channel)
                    sentChannels[channel] = true
                else
                    print("Unknown chat type:", channel)
                end
            end
        end
    end

    if not next(sentChannels) then
        print("No valid channel selected for LFM message.")
    end
end

-- Event handler registration for whispers and group/raid updates
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("CHAT_MSG_WHISPER")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("INSPECT_READY")
eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "CHAT_MSG_WHISPER" then
        onWhisper(event, ...)
    elseif event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ENTERING_WORLD" then
        onRosterUpdate()
    elseif event == "INSPECT_READY" then
        onInspectReady(event, ...)
    end
end)

-- Function to reset the raid
local function resetRaid()
    activeTank = {}
    activeHealer = {}
    activeRange = {}
    activeMelee = {}
    playersWithoutRole = {}
    conversationList = {}
    playerItemLevels = {}
    playerLevels = {}
    -- Do not delete invitedPlayers to retain history
    MyRaidAddon:UpdateRoleManagementPage()
end

-- Function to display player options
local function ShowPlayerOptions(playerName)
    local frame = AceGUI:Create("Window")
    frame:SetTitle("Assign Role")
    frame:SetLayout("Flow")
    frame:SetWidth(200)
    frame:SetHeight(300)
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)

    local label = AceGUI:Create("Label")
    label:SetText("Assign a role to " .. playerName .. ":")
    label:SetFullWidth(true)
    frame:AddChild(label)

    local roles = {
        { key = "tank", label = "Tank" },
        { key = "healer", label = "Healer" },
        { key = "range", label = "Range DPS" },
        { key = "melee", label = "Melee DPS" },
    }

    for _, roleData in ipairs(roles) do
        local button = AceGUI:Create("Button")
        button:SetText(roleData.label)
        button:SetWidth(150)
        button:SetCallback("OnClick", function()
            -- Remove the player from all active lists
            removeFromAllActiveLists(playerName)
            -- Add the player to the selected role list
            if roleData.key == "tank" then
                table.insert(activeTank, playerName)
            elseif roleData.key == "healer" then
                table.insert(activeHealer, playerName)
            elseif roleData.key == "range" then
                table.insert(activeRange, playerName)
            elseif roleData.key == "melee" then
                table.insert(activeMelee, playerName)
            end
            -- Invite with PlayerName-RealmName
            InviteUnit(playerName) -- Use full name for invitation
            -- Set status to "active" if in group
            if isPlayerInGroup(playerName) then
                MyRaidAddon:AddToInvitedPlayers(playerName, roleData.key, "active")
            else
                MyRaidAddon:AddToInvitedPlayers(playerName, roleData.key, "invited")
            end
            -- Update role management page
            MyRaidAddon:UpdateRoleManagementPage()
            frame:Hide()
        end)
        frame:AddChild(button)
    end

    local removeButton = AceGUI:Create("Button")
    removeButton:SetText("Remove")
    removeButton:SetWidth(150)
    removeButton:SetCallback("OnClick", function()
        -- Remove player from active lists without changing status
        removeFromAllActiveLists(playerName)
        -- Update status basierend auf aktuellen Bedingungen
        updatePlayerStatuses()
        -- Update role management page
        MyRaidAddon:UpdateRoleManagementPage()
        frame:Hide()
    end)
    frame:AddChild(removeButton)
end

-- Function to display options for an invited player
local function ShowInvitedPlayerOptions(playerName)
    local frame = AceGUI:Create("Window")
    frame:SetTitle("Player Options")
    frame:SetLayout("List")
    frame:SetWidth(200)
    frame:SetHeight(200)
    frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)

    local refreshButton = AceGUI:Create("Button")
    refreshButton:SetText("Refresh")
    refreshButton:SetWidth(150)
    refreshButton:SetCallback("OnClick", function()
        -- Manual refresh of ilvl could be implemented here
        inspectGroupMembers()
        print("Initiated gear inspection for refresh.")
        frame:Hide()
    end)
    frame:AddChild(refreshButton)

    local removeButton = AceGUI:Create("Button")
    removeButton:SetText("Remove")
    removeButton:SetWidth(150)
    removeButton:SetCallback("OnClick", function()
        -- Remove player from invitedPlayers list without setting status to "Excluded"
        MyRaidAddon.db.profile.invitedPlayers[playerName] = nil
        frame:Hide()
        -- Update player history if displayed
        if invitedPlayersFrame and invitedPlayersFrame:IsShown() then
            ShowInvitedPlayers()
        end
    end)
    frame:AddChild(removeButton)

    local excludeButton = AceGUI:Create("Button")
    excludeButton:SetText("Exclude")
    excludeButton:SetWidth(150)
    excludeButton:SetCallback("OnClick", function()
        -- Mark player as excluded
        if MyRaidAddon.db.profile.invitedPlayers[playerName] then
            MyRaidAddon.db.profile.invitedPlayers[playerName].status = "Excluded"
        end
        frame:Hide()
        -- Update player history if displayed
        if invitedPlayersFrame and invitedPlayersFrame:IsShown() then
            ShowInvitedPlayers()
        end
    end)
    frame:AddChild(excludeButton)
end

-- Function to display the invited players history
local function ShowInvitedPlayers()
    if invitedPlayersFrame and invitedPlayersFrame:IsShown() then
        AceGUI:Release(invitedPlayersFrame)
    end

    invitedPlayersFrame = AceGUI:Create("Window")
    local frame = invitedPlayersFrame
    frame:SetTitle("Player History")
    frame:SetLayout("Fill")
    frame:SetWidth(500)
    frame:SetHeight(400)
    frame:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
        invitedPlayersFrame = nil
    end)

    local scrollFrame = AceGUI:Create("ScrollFrame")
    scrollFrame:SetLayout("Flow")
    frame:AddChild(scrollFrame)

    if MyRaidAddon.db.profile.invitedPlayers and next(MyRaidAddon.db.profile.invitedPlayers) then
        -- Table headers
        local headersGroup = AceGUI:Create("SimpleGroup")
        headersGroup:SetFullWidth(true)
        headersGroup:SetLayout("Flow")
        scrollFrame:AddChild(headersGroup)

        local nameHeader = AceGUI:Create("Label")
        nameHeader:SetText("Name")
        nameHeader:SetWidth(150)
        headersGroup:AddChild(nameHeader)

        local roleHeader = AceGUI:Create("Label")
        roleHeader:SetText("Last Role")
        roleHeader:SetWidth(80)
        headersGroup:AddChild(roleHeader)

        local ilvlHeader = AceGUI:Create("Label")
        ilvlHeader:SetText("ilvl")
        ilvlHeader:SetWidth(50)
        headersGroup:AddChild(ilvlHeader)

        local statusHeader = AceGUI:Create("Label")
        statusHeader:SetText("Status")
        statusHeader:SetWidth(100)
        headersGroup:AddChild(statusHeader)

        -- List of players
        for playerName, data in pairs(MyRaidAddon.db.profile.invitedPlayers) do
            local playerGroup = AceGUI:Create("SimpleGroup")
            playerGroup:SetFullWidth(true)
            playerGroup:SetLayout("Flow")
            scrollFrame:AddChild(playerGroup)

            local displayName = "|c" .. getClassColor(playerName) .. playerName .. "|r"

            local nameLabel = AceGUI:Create("InteractiveLabel")
            nameLabel:SetText(displayName)
            nameLabel:SetWidth(150)
            nameLabel:SetCallback("OnClick", function()
                -- Open options for the player
                ShowInvitedPlayerOptions(playerName)
            end)
            playerGroup:AddChild(nameLabel)

            local roleLabel = AceGUI:Create("Label")
            roleLabel:SetText(data.lastRole or "")
            roleLabel:SetWidth(80)
            playerGroup:AddChild(roleLabel)

            local ilvlLabel = AceGUI:Create("Label")
            ilvlLabel:SetText(data.ilvl or "")
            ilvlLabel:SetWidth(50)
            playerGroup:AddChild(ilvlLabel)

            local statusLabel = AceGUI:Create("Label")
            statusLabel:SetText(data.status or "")
            statusLabel:SetWidth(100)
            playerGroup:AddChild(statusLabel)
        end
    else
        local noPlayersLabel = AceGUI:Create("Label")
        noPlayersLabel:SetText("No players have been invited yet.")
        noPlayersLabel:SetFullWidth(true)
        scrollFrame:AddChild(noPlayersLabel)
    end
end

-- Function to create the main window (Raid Manager)
function MyRaidAddon:CreateMainWindow()
    initializeSelectedChannels()

    mainFrame:SetTitle("LFM-Manager")
    mainFrame:SetStatusText("") -- Initially empty
    mainFrame:Show()
    mainFrame:ReleaseChildren()
    mainFrame:SetLayout("Fill")
    mainFrame.currentPage = "Main"

    -- Create a ScrollFrame to hold the content
    local scrollFrame = AceGUI:Create("ScrollFrame")
    scrollFrame:SetLayout("Flow")
    mainFrame:AddChild(scrollFrame)

    -- Group 1: Next, Auto-Invite, Auto-Reply
    local buttonGroup = AceGUI:Create("SimpleGroup")
    buttonGroup:SetFullWidth(true)
    buttonGroup:SetLayout("Flow")
    scrollFrame:AddChild(buttonGroup)

    local forwardButton = AceGUI:Create("Button")
    forwardButton:SetText("Next")
    forwardButton:SetWidth(100)
    forwardButton:SetCallback("OnClick", function()
        self:CreateRoleManagementPage()
    end)
    buttonGroup:AddChild(forwardButton)

    local autoInviteCheckbox = AceGUI:Create("CheckBox")
    autoInviteCheckbox:SetLabel("Auto-Invite")
    autoInviteCheckbox:SetValue(autoInviteEnabled)
    autoInviteCheckbox:SetWidth(100)
    autoInviteCheckbox:SetCallback("OnValueChanged", function(_, _, value)
        autoInviteEnabled = value
        self.db.profile.autoInviteEnabled = autoInviteEnabled
    end)
    buttonGroup:AddChild(autoInviteCheckbox)

    local autoReplyCheckbox = AceGUI:Create("CheckBox")
    autoReplyCheckbox:SetLabel("Auto-Reply")
    autoReplyCheckbox:SetValue(autoReplyEnabled)
    autoReplyCheckbox:SetWidth(100)
    autoReplyCheckbox:SetCallback("OnValueChanged", function(_, _, value)
        autoReplyEnabled = value
        self.db.profile.autoReplyEnabled = autoReplyEnabled
    end)
    buttonGroup:AddChild(autoReplyCheckbox)

    -- Group 2: Select Raid, Raid Option, Raid Size, Tanks, Healers, DPS
    local raidSettingsGroup = AceGUI:Create("InlineGroup")
    raidSettingsGroup:SetTitle("Raid Settings")
    raidSettingsGroup:SetLayout("Flow")
    raidSettingsGroup:SetFullWidth(true)
    scrollFrame:AddChild(raidSettingsGroup)

    local raidDropdown = AceGUI:Create("Dropdown")
    raidDropdown:SetLabel("Select Raid")
    --raidDropdown:SetWidth(300)
    raidDropdown:SetFullWidth(true)
    local raidList = {}
    for k, v in pairs(raidConfig) do
        raidList[k] = v.RaidName
    end
    raidDropdown:SetList(raidList)
    raidDropdown:SetValue(selectedRaid)
    raidSettingsGroup:AddChild(raidDropdown)

    local raidOptionEditBox = AceGUI:Create("EditBox")
    raidOptionEditBox:SetLabel("Raid Option")
    raidOptionEditBox:SetText(raidConfig[selectedRaid].raidOption or "")
    --raidOptionEditBox:SetWidth(180)
    raidOptionEditBox:SetFullWidth(true)
    raidOptionEditBox:SetCallback("OnTextChanged", function(widget, event, text)
        raidConfig[selectedRaid].raidOption = text
        MyRaidAddon.db.profile.raidConfig = raidConfig
    end)
    raidSettingsGroup:AddChild(raidOptionEditBox)

    local raidSizeField = AceGUI:Create("EditBox")
    raidSizeField:SetLabel("Raid Size")
    raidSizeField:SetText(tostring(raidConfig[selectedRaid].RaidSize))
    raidSizeField:SetWidth(80)
    raidSizeField:SetCallback("OnTextChanged", function(widget, event, text)
        local newValue = tonumber(text)
        if newValue then
            raidConfig[selectedRaid].RaidSize = newValue
        else
            widget:SetText(tostring(raidConfig[selectedRaid].RaidSize))
        end
        MyRaidAddon.db.profile.raidConfig = raidConfig
    end)
    raidSettingsGroup:AddChild(raidSizeField)

    local needTanksField = AceGUI:Create("EditBox")
    needTanksField:SetLabel("Tanks")
    needTanksField:SetText(tostring(raidConfig[selectedRaid].NeedTanks))
    needTanksField:SetWidth(60)
    needTanksField:SetCallback("OnTextChanged", function(widget, event, text)
        local newValue = tonumber(text)
        if newValue then
            raidConfig[selectedRaid].NeedTanks = newValue
        else
            widget:SetText(tostring(raidConfig[selectedRaid].NeedTanks))
        end
        MyRaidAddon.db.profile.raidConfig = raidConfig
    end)
    raidSettingsGroup:AddChild(needTanksField)

    local needHealersField = AceGUI:Create("EditBox")
    needHealersField:SetLabel("Healers")
    needHealersField:SetText(tostring(raidConfig[selectedRaid].NeedHealers))
    needHealersField:SetWidth(60)
    needHealersField:SetCallback("OnTextChanged", function(widget, event, text)
        local newValue = tonumber(text)
        if newValue then
            raidConfig[selectedRaid].NeedHealers = newValue
        else
            widget:SetText(tostring(raidConfig[selectedRaid].NeedHealers))
        end
        MyRaidAddon.db.profile.raidConfig = raidConfig
    end)
    raidSettingsGroup:AddChild(needHealersField)

    local needDPSField = AceGUI:Create("EditBox")
    needDPSField:SetLabel("DPS")
    needDPSField:SetText(tostring(raidConfig[selectedRaid].NeedDPS))
    needDPSField:SetWidth(60)
    needDPSField:SetCallback("OnTextChanged", function(widget, event, text)
        local newValue = tonumber(text)
        if newValue then
            raidConfig[selectedRaid].NeedDPS = newValue
        else
            widget:SetText(tostring(raidConfig[selectedRaid].NeedDPS))
        end
        MyRaidAddon.db.profile.raidConfig = raidConfig
    end)
    raidSettingsGroup:AddChild(needDPSField)

    raidDropdown:SetCallback("OnValueChanged", function(_, _, key)
        selectedRaid = key
        raidSizeField:SetText(tostring(raidConfig[key].RaidSize))
        needTanksField:SetText(tostring(raidConfig[key].NeedTanks))
        needHealersField:SetText(tostring(raidConfig[key].NeedHealers))
        needDPSField:SetText(tostring(raidConfig[key].NeedDPS))
        raidOptionEditBox:SetText(raidConfig[key].raidOption or "")
    end)

    -- Group 3: Select Channels
    local channelsGroup = AceGUI:Create("InlineGroup")
    channelsGroup:SetTitle("Select Channels")
    channelsGroup:SetLayout("Flow")
    channelsGroup:SetFullWidth(true)
    scrollFrame:AddChild(channelsGroup)

    local column1 = AceGUI:Create("SimpleGroup")
    column1:SetWidth(150) -- Half width
    column1:SetLayout("List")
    channelsGroup:AddChild(column1)

    local column2 = AceGUI:Create("SimpleGroup")
    column2:SetWidth(150) -- Half width
    column2:SetLayout("List")
    channelsGroup:AddChild(column2)

    for i, channel in ipairs(channelOptions) do
        local channelCheckbox = AceGUI:Create("CheckBox")
        channelCheckbox:SetLabel(channel)
        channelCheckbox:SetValue(selectedChannels[channel] or false)
        channelCheckbox:SetCallback("OnValueChanged", function(_, _, value)
            updateSelectedChannel(channel, value)
        end)
        if i % 2 == 1 then
            column1:AddChild(channelCheckbox)
        else
            column2:AddChild(channelCheckbox)
        end
    end
end

-- Adjustments in the Role Management page
function MyRaidAddon:CreateRoleManagementPage()
    mainFrame:SetTitle("Role Management - " .. raidConfig[selectedRaid].RaidName)
    mainFrame:ReleaseChildren()
    mainFrame:SetLayout("Fill")
    mainFrame.currentPage = "RoleManagement"

    -- Create a ScrollFrame to hold the content
    local scrollFrame = AceGUI:Create("ScrollFrame")
    scrollFrame:SetLayout("Flow")
    mainFrame:AddChild(scrollFrame)

    -- Group 1: Back, InfoRaid, CheckRole, LFM, Player History, Reset Raid
    local buttonGroup = AceGUI:Create("SimpleGroup")
    buttonGroup:SetFullWidth(true)
    buttonGroup:SetLayout("Flow")
    scrollFrame:AddChild(buttonGroup)

    local backButton = AceGUI:Create("Button")
    backButton:SetText("Back")
    backButton:SetWidth(100)
    backButton:SetCallback("OnClick", function()
        self:CreateMainWindow()
    end)
    buttonGroup:AddChild(backButton)

    local infoRaidButton = AceGUI:Create("Button")
    infoRaidButton:SetText("InfoRaid")
    infoRaidButton:SetWidth(100)
    infoRaidButton:SetCallback("OnClick", function()
        announceActiveLists()
    end)
    buttonGroup:AddChild(infoRaidButton)

    local checkRoleButton = AceGUI:Create("Button")
    checkRoleButton:SetText("CheckRole")
    checkRoleButton:SetWidth(100)
    checkRoleButton:SetCallback("OnClick", function()
        CheckRole()
    end)
    buttonGroup:AddChild(checkRoleButton)

    local lfmButton = AceGUI:Create("Button")
    lfmButton:SetText("LFM")
    lfmButton:SetWidth(100)
    lfmButton:SetCallback("OnClick", function()
        postRaid(selectedRaid)
    end)
    buttonGroup:AddChild(lfmButton)

    local playerHistoryButton = AceGUI:Create("Button")
    playerHistoryButton:SetText("Player History")
    playerHistoryButton:SetWidth(100)
    playerHistoryButton:SetCallback("OnClick", function()
        ShowInvitedPlayers()
    end)
    buttonGroup:AddChild(playerHistoryButton)

    local resetButton = AceGUI:Create("Button")
    resetButton:SetText("Reset Raid")
    resetButton:SetWidth(100)
    resetButton:SetCallback("OnClick", function()
        resetRaid()
    end)
    buttonGroup:AddChild(resetButton)

    -- Group 2: Role display (using tables)
    local rolesGroup = AceGUI:Create("SimpleGroup")
    rolesGroup:SetLayout("Flow")
    rolesGroup:SetFullWidth(true)
    scrollFrame:AddChild(rolesGroup)

    local roles = {
        { label = "Tanks", list = activeTank },
        { label = "Healers", list = activeHealer },
        { label = "Range DPS", list = activeRange },
        { label = "Melee DPS", list = activeMelee },
    }

    -- Calculate total ilvl and raid progress
    local function calculateTotalIlvl()
        local totalIlvl = 0
        for _, roleData in ipairs(roles) do
            for _, playerName in ipairs(roleData.list) do
                local ilvl = playerItemLevels[playerName] or (MyRaidAddon.db.profile.invitedPlayers[playerName] and MyRaidAddon.db.profile.invitedPlayers[playerName].ilvl) or 0
                totalIlvl = totalIlvl + ilvl
            end
        end
        return totalIlvl
    end

    local function calculateRaidProgress()
        local config = raidConfig[selectedRaid]
        local currentPlayers = #activeTank + #activeHealer + #activeRange + #activeMelee
        local progress = (currentPlayers / config.RaidSize) * 100
        return math.floor(progress + 0.5) -- Round to nearest whole number
    end

    -- Info Bar for Total ilvl and Raid Progress in the status text
    local infoText = string.format("LFM Progress: %d%% - Total ilvl: %d", calculateRaidProgress(), calculateTotalIlvl())
    mainFrame:SetStatusText(infoText)

    for _, roleData in ipairs(roles) do
        local totalIlvl = 0
        for _, playerName in ipairs(roleData.list) do
            local ilvl = playerItemLevels[playerName] or (MyRaidAddon.db.profile.invitedPlayers[playerName] and MyRaidAddon.db.profile.invitedPlayers[playerName].ilvl) or 0
            totalIlvl = totalIlvl + ilvl
        end
        local roleTitle = roleData.label .. " (" .. totalIlvl .. ")"

        local roleGroup = AceGUI:Create("InlineGroup")
        roleGroup:SetTitle(roleTitle)
        roleGroup:SetLayout("Flow")
        roleGroup:SetWidth(500)
        rolesGroup:AddChild(roleGroup)

        -- Table headers
        local headersGroup = AceGUI:Create("SimpleGroup")
        headersGroup:SetFullWidth(true)
        headersGroup:SetLayout("Flow")
        roleGroup:AddChild(headersGroup)

        local nameHeader = AceGUI:Create("Label")
        nameHeader:SetText("Name")
        nameHeader:SetWidth(150)
        headersGroup:AddChild(nameHeader)

        local ilvlHeader = AceGUI:Create("Label")
        ilvlHeader:SetText("ilvl")
        ilvlHeader:SetWidth(50)
        headersGroup:AddChild(ilvlHeader)

        local statusHeader = AceGUI:Create("Label")
        statusHeader:SetText("Status")
        statusHeader:SetWidth(100)
        headersGroup:AddChild(statusHeader)

        -- List of players
        for _, playerName in ipairs(roleData.list) do
            if playerName:find("-") then -- Ensure the player includes the realm
                local playerGroup = AceGUI:Create("SimpleGroup")
                playerGroup:SetFullWidth(true)
                playerGroup:SetLayout("Flow")
                roleGroup:AddChild(playerGroup)

                local displayName = "|c" .. getClassColor(playerName) .. playerName .. "|r"
                local ilvlText = playerItemLevels[playerName] or (MyRaidAddon.db.profile.invitedPlayers[playerName] and MyRaidAddon.db.profile.invitedPlayers[playerName].ilvl) or ""
                local statusText = MyRaidAddon.db.profile.invitedPlayers[playerName] and MyRaidAddon.db.profile.invitedPlayers[playerName].status or ""

                local nameLabel = AceGUI:Create("InteractiveLabel")
                nameLabel:SetText(displayName)
                nameLabel:SetWidth(150)
                nameLabel:SetCallback("OnClick", function()
                    ShowPlayerOptions(playerName)
                end)
                playerGroup:AddChild(nameLabel)

                local ilvlLabel = AceGUI:Create("Label")
                ilvlLabel:SetText(ilvlText)
                ilvlLabel:SetWidth(50)
                playerGroup:AddChild(ilvlLabel)

                local statusLabel = AceGUI:Create("Label")
                statusLabel:SetText(statusText)
                statusLabel:SetWidth(100)
                playerGroup:AddChild(statusLabel)
            end
        end
    end

    -- Group 3: Without Role and Requests
    local othersGroup = AceGUI:Create("InlineGroup")
    othersGroup:SetTitle("Without Role and Requests")
    othersGroup:SetLayout("Flow")
    othersGroup:SetFullWidth(true)
    scrollFrame:AddChild(othersGroup)

    -- Table headers
    local headersGroup = AceGUI:Create("SimpleGroup")
    headersGroup:SetFullWidth(true)
    headersGroup:SetLayout("Flow")
    othersGroup:AddChild(headersGroup)

    local nameHeader = AceGUI:Create("Label")
    nameHeader:SetText("Name")
    nameHeader:SetWidth(150)
    headersGroup:AddChild(nameHeader)

    local ilvlHeader = AceGUI:Create("Label")
    ilvlHeader:SetText("ilvl")
    ilvlHeader:SetWidth(50)
    headersGroup:AddChild(ilvlHeader)

    local statusHeader = AceGUI:Create("Label")
    statusHeader:SetText("Status")
    statusHeader:SetWidth(100)
    headersGroup:AddChild(statusHeader)

    -- Display players without roles
    for _, playerName in ipairs(playersWithoutRole) do
        if playerName:find("-") and not isPlayerInActiveList(playerName) then -- Ensure the player includes the realm and is not in an active list
            local playerGroup = AceGUI:Create("SimpleGroup")
            playerGroup:SetFullWidth(true)
            playerGroup:SetLayout("Flow")
            othersGroup:AddChild(playerGroup)

            local displayName = "|c" .. getClassColor(playerName) .. playerName .. "|r"
            local ilvlText = playerItemLevels[playerName] or (MyRaidAddon.db.profile.invitedPlayers[playerName] and MyRaidAddon.db.profile.invitedPlayers[playerName].ilvl) or ""
            local statusText = MyRaidAddon.db.profile.invitedPlayers[playerName] and MyRaidAddon.db.profile.invitedPlayers[playerName].status or ""

            local playerLabel = AceGUI:Create("InteractiveLabel")
            playerLabel:SetText(displayName)
            playerLabel:SetWidth(150)
            playerLabel:SetCallback("OnClick", function()
                ShowPlayerOptions(playerName)
            end)
            playerGroup:AddChild(playerLabel)

            local ilvlLabel = AceGUI:Create("Label")
            ilvlLabel:SetText(ilvlText)
            ilvlLabel:SetWidth(50)
            playerGroup:AddChild(ilvlLabel)

            local statusLabel = AceGUI:Create("Label")
            statusLabel:SetText(statusText)
            statusLabel:SetWidth(100)
            playerGroup:AddChild(statusLabel)
        end
    end
end

-- Initialize the database and main window
function MyRaidAddon:OnInitialize()
    self.db = AceDB:New("MyRaidAddonDB", {
        profile = {
            autoInviteEnabled = false,
            autoReplyEnabled = false,
            raidConfig = raidConfig,
            selectedChannels = {},
            invitedPlayers = {}, -- Add invitedPlayers to saved variables
        },
    }, true)

    autoInviteEnabled = self.db.profile.autoInviteEnabled
    autoReplyEnabled = self.db.profile.autoReplyEnabled
    raidConfig = self.db.profile.raidConfig
    initializeSelectedChannels() -- Ensure selectedChannels is initialized

    self:RegisterChatCommand("myraidaddon", "CreateMainWindow")
    self:RegisterChatCommand("lfm", function()
        postRaid(selectedRaid)
    end)

    -- Debug command for selected channels
    self:RegisterChatCommand("selectedchannels", "PrintSelectedChannels")

    -- Create main window
    mainFrame = AceGUI:Create("Frame")
    mainFrame:SetTitle("LFM-Manager")
    mainFrame:SetStatusText("") -- Initially empty
    mainFrame:SetWidth(600)
    mainFrame:SetHeight(500)
    mainFrame:SetLayout("Fill")
    mainFrame:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
    end)
    mainFrame:Hide() -- Initially hidden
    mainFrame.currentPage = "Main"

    -- Minimap button
    local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("LFM-Manager", {
        type = "launcher",
        text = "LFM-Manager",
        icon = "Interface\\AddOns\\LFM-Manager\\lib\\Icon\\Logo.png",
        OnClick = function(_, button)
            if button == "LeftButton" then
                MyRaidAddon:CreateMainWindow()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:AddLine("LFM-Manager")
            tooltip:AddLine("Left-click to open the addon.")
        end,
    })

    local icon = LibStub("LibDBIcon-1.0")
    icon:Register("LFM-Manager", LDB, {})
end
