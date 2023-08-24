local isCooldownActive = false

RegisterNetEvent('GoatRico:OpenAdMenu', function(AdMenu)
    if not isCooldownActive then
        isCooldownActive = true
        local input = lib.inputDialog('Bussniess Ad Menu', {
            {type = 'number', label = 'Display Time', description = '1 = 5 Sec, 2 = 10 Sec, or 3 = 15 Sec Display Time', required = true, icon = 'stopwatch', min = 1, max = 3},
            {type = 'input', label = 'Title', description = 'Enter the title for the advertisement', icon = 'pencil', required = true},
            {type = 'input', label = 'Message', description = 'Enter the message you want to convey', icon = 'keyboard', required = true},
            {type = 'color', label = 'Background Color', description = 'Choose the background color', icon = 'palette', default = '#eb4034', required = true,},
            {type = 'color', label = 'Title Color', description = 'Choose the title color', icon = 'paintbrush', default = '#909296', required = true,},
            {type = 'color', label = 'Description Color', description = 'Choose the message color', icon = 'paintbrush', default = '#ffffff', required = true,},
            {type = 'select', label = 'Ad Display Location', description = 'Select where the Ad will be displayed', options = {
                { value = 'top', label = 'Top' },
                { value = 'top-right', label = 'Top Right' },
                { value = 'top-left', label = 'Top Left' },
                { value = 'bottom', label = 'Bottom' },
                { value = 'bottom-right', label = 'Bottom Right' },
                { value = 'bottom-left', label = 'Bottom Left' },
                { value = 'center-right', label = 'Center Right' },
                { value = 'center-left', label = 'Center Left' }
            }, required = true, icon = 'desktop'}
        })

        if input ~= nil then
            local Time, Title, Msg, BackgroundColor, TitleColor, DespColor, Location = input[1], input[2], input[3], input[4], input[5], input[6], input[7]
            TriggerServerEvent("GoatRico:ServerAdvertisment", Time, Title, Msg, BackgroundColor, TitleColor, DespColor, Location)
        end
        Citizen.Wait(Config.CoolDownTime)
        isCooldownActive = false
    else
        lib.notify({
            title = 'System',
            description = 'There is a cooldown between uses please try again in a few',
            duration = 3500,
            position = 'center-right',
            type = 'error'
        })
    end
end)
