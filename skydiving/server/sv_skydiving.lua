local flightinprogress = false

function flightCooldown()
    SetTimeout(ConfigSky.Cooldown, function() -- 300000 = 5 minute cooldown.
        flightinprogress = false
    end)
end

RegisterServerEvent('randol_skydive:flightcooldown', function()
    flightinprogress = true
    flightCooldown()
end)

RegisterServerEvent("randol_skydive:server:payforgroup")
AddEventHandler("randol_skydive:server:payforgroup", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local groupfee = ConfigSky.GroupFee
    local balance = xPlayer.getMoney('bank')

    if not flightinprogress then
        if balance >= groupfee then
            xPlayer.removeMoney("bank", groupfee, "skydive")
            TriggerClientEvent('mythic_notify:client:SendAlert', source,
                {
                    type = 'success',
                    text = 'You paid for a group sky dive!',
                    length = 2500,
                    style = { ['background-color'] = '#ffffff',['color'] = '#000000' }
                })
            TriggerClientEvent('randol_skydive:client:skydivetime', source)
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source,
                {
                    type = 'error',
                    text = ' Kamu tidak memiliki uang yang cukup dibank',
                    length = 2500,
                    style = { ['background-color'] = '#ffffff',['color'] = '#000000' }
                })
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source,
            {
                type = 'error',
                text = ' Flight already in progress.',
                length = 2500,
                style = { ['background-color'] = '#ffffff',['color'] = '#000000' }
            })
    end
end)

RegisterServerEvent("randol_skydive:server:solojump")
AddEventHandler("randol_skydive:server:solojump", function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local solofee = ConfigSky.SoloFee
    local balance = xPlayer.getMoney('bank')

    if not flightinprogress then
        if balance >= solofee then
            TriggerClientEvent('randol_skydive:client:skydivesolo', source)
            -- xPlayer.removeMoney("money", solofee, "skydive-solo")
            xPlayer.removeMoney(solofee)
            TriggerClientEvent('mythic_notify:client:SendAlert', source,
                {
                    type = 'success',
                    text = 'Kamu membayar Rp.' .. ConfigSky.SoloFee .. ' Untuk terjun',
                    length = 2500,
                    style = { ['background-color'] = 'green',['color'] = 'white' }
                })
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source,
                {
                    type = 'error',
                    text = 'Tidak cukup uang',
                    length = 2500,
                    style = { ['background-color'] = '#red',['color'] = 'white' }
                })
        end
    else
        TriggerClientEvent('mythic_notify:client:SendAlert', source,
            {
                type = 'error',
                text = 'Kamu baru saja terjun tunggu 5 menit lagi',
                length = 2500,
                style = { ['background-color'] = 'red',['color'] = 'white' }
            })
    end
end)
