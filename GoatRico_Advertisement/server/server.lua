ESX = exports['es_extended']:getSharedObject()

local function IsPlayerAllowedToUseCommand(player)
    local xPlayer = ESX.GetPlayerFromId(player)
    local playerJob = xPlayer.getJob().name -- You need to implement this function
    local allowedJobs = Config.AllowedJobs
    
    for _, job in ipairs(allowedJobs) do
        if playerJob == job then
            return true
        end
    end

    return false
end

local function SendNotification(xPlayer, title, duration, position, description, backgroundColor, despColor, cost)
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
                ['.description'] = {
                    color = despColor
                }
            },
        })
        xPlayer.removeMoney(cost)
    else
        TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', title = 'Money', duration = 3500, position = 'center-right', description = 'You dont have enough money for that!'})
    end
end

RegisterServerEvent('GoatRico:ServerAdvertisment')
AddEventHandler('GoatRico:ServerAdvertisment', function(Time, Title, Msg, BackgroundColor, DespColor, Location)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if Time == 1 then
        SendNotification(xPlayer, Title, Config.ShortNotificationTime, Location, Msg, BackgroundColor, DespColor, Config.ShortNotificationPrice)
    elseif Time == 2 then
        SendNotification(xPlayer, Title, Config.MediumNotificationTime, Location, Msg, BackgroundColor, DespColor, Config.MediumNotificationPrice)
    elseif Time == 3 then
        SendNotification(xPlayer, Title, Config.LongNotificationTime, Location, Msg, BackgroundColor, DespColor, Config.LongNotificationPrice)
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


lib.addCommand("jobad", {
    help = 'Business Advertisement Menu',
}, function(source)
    local player = source
    if IsPlayerAllowedToUseCommand(player) then
        TriggerClientEvent("GoatRico:OpenAdMenu", source)
    else
        TriggerClientEvent('ox_lib:notify', source, { type = 'error', title = 'System', duration = 3500, position = 'center-right', description = 'You dont have the correct job to use this'})
    end
end)
