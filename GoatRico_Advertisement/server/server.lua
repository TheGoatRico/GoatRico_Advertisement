ESX, QBCore = nil, nil
local Framework = ''

if Config.Framework == 'esx' then
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Framework = 'esx'
        Wait(100)
    end
elseif Config.Framework == 'qbcore' then
    while QBCore == nil do
        QBCore = exports['qb-core']:GetCoreObject()
        Framework = 'qb-core'
        Wait(100)
    end
end

local function IsPlayerAllowedToUseCommand(player)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(player)
        local playerJob = xPlayer.getJob().name 
        local allowedJobs = Config.AllowedJobs
        
        for _, job in ipairs(allowedJobs) do
            if playerJob == job then
                return true
            end
        end
    else
        local xPlayer = QBCore.Functions.GetPlayer(player)
        local playerJob = xPlayer.PlayerData.job.name
        local allowedJobs = Config.AllowedJobs
        
        for _, job in ipairs(allowedJobs) do
            if playerJob == job then
                return true
            end
        end

        return false
    end
end

local function SendNotification(xPlayer, title, duration, position, description, backgroundColor, titleColor, despColor, cost)
    if Framework == 'esx' then
        if xPlayer.getMoney() >= cost then
            TriggerClientEvent('ox_lib:notify', -1, {
                type = 'inform', 
                title = title,
                duration = duration,
                position = position,
                description = description,
                icon = Config.AdIcon,
                style = {
                    backgroundColor = backgroundColor,
                    color = titleColor,
                    ['.description'] = {
                        color = despColor
                    }
                },
            })
            xPlayer.removeMoney(cost)
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', title = 'Money', duration = 3500, position = 'center-right', description = 'You dont have enough money for that!'})
        end
    else
        if xPlayer.Functions.GetMoney('bank') >= cost then
            TriggerClientEvent('ox_lib:notify', -1, {
                type = 'inform', 
                title = title,
                duration = duration,
                position = position,
                description = description,
                icon = Config.AdIcon,
                style = {
                    backgroundColor = backgroundColor,
                    color = titleColor,
                    ['.description'] = {
                        color = despColor
                    }
                },
            })
            xPlayer.Functions.RemoveMoney('bank', cost)
        else
            TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', title = 'Money', duration = 3500, position = 'center-right', description = 'You dont have enough money for that!'})
        end
    end
end

RegisterServerEvent('GoatRico:ServerAdvertisment')
AddEventHandler('GoatRico:ServerAdvertisment', function(Time, Title, Msg, BackgroundColor, TitleColor, DespColor, Location)
    local src = source
    local xPlayer
    if Framework == 'esx' then
        xPlayer = ESX.GetPlayerFromId(src)
    else
        xPlayer = QBCore.Functions.GetPlayer(src)
    end

    if Time == 1 then
        SendNotification(xPlayer, Title, Config.ShortNotificationTime, Location, Msg, BackgroundColor, TitleColor, DespColor, Config.ShortNotificationPrice)
    elseif Time == 2 then
        SendNotification(xPlayer, Title, Config.MediumNotificationTime, Location, Msg, BackgroundColor, TitleColor, DespColor, Config.MediumNotificationPrice)
    elseif Time == 3 then
        SendNotification(xPlayer, Title, Config.LongNotificationTime, Location, Msg, BackgroundColor, TitleColor, DespColor, Config.LongNotificationPrice)
    else
        TriggerClientEvent('ox_lib:notify', src, { type = 'error', title = 'System', duration = 3500, position = 'center-right', description = 'Invalid option!'})
    end
    local discordEmbed = {
        title = "Business Advertisement",
        description = "Player: " .. GetPlayerName(src) .. "\nID: " .. src .. "\nIdentifier: " .. GetPlayerIdentifier(src) .. "\n\n**Title:** " .. Title .. "\n**Message:** " .. Msg .. "\n**Location:** " .. Location,
        color = 15158332
    }
    PerformHttpRequest("PLACE_WEBHOOK_HERE", function(err, text, headers)  --WEBHOOK GOES HERE "EMBED IS FOR INCASE SOMEONE POST SOMETHING THEY SHOULDN'T YOU CAN KNOW WHO"
        if err ~= 200 then
            print("Discord Webhook Error: " .. err)
        end
    end, 'POST', json.encode({embeds = {discordEmbed}}), { ['Content-Type'] = 'application/json' })
end)


lib.addCommand("jobad", { -- CHANGE COMMAND HERE IF YOU WANT
    help = 'Business Advertisement Menu',
}, function(source)
    local player = source
    if IsPlayerAllowedToUseCommand(player) then
        TriggerClientEvent("GoatRico:OpenAdMenu", source)
    else
        TriggerClientEvent('ox_lib:notify', source, { type = 'error', title = 'System', duration = 3500, position = 'center-right', description = 'You dont have the correct job to use this'})
    end
end)
