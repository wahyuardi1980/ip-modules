RegisterServerEvent('3ddo:shareDisplay')
AddEventHandler('3ddo:shareDisplay', function(textdo)
    local src = source
    TriggerClientEvent('3ddo:triggerDisplay', -1, textdo, src)
end)

-- bisik
function concatenate(args)
    local str = ''
    for i = 1, #args do
        str = str .. ' ' .. args[i]
    end
    return str
end

-- RegisterCommand('bisik', function(source, args)
--     local name = GetPlayerName(source)
--     local text = 'Membisikan | '..name..' :'.. concatenate(args)

--     TriggerClientEvent('bisik:allPlayer', -1, text, source)
-- end, false)
