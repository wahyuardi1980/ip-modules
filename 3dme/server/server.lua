RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source)
end)

-- bisik
function concatenate(args)
    local str = ''
    for i=1, #args do
        str = str..' '..args[i]
    end
    return str
end

-- RegisterCommand('bisik', function(source, args)
--     local name = GetPlayerName(source)
--     local text = 'Membisikan | '..name..' :'.. concatenate(args)

--     TriggerClientEvent('bisik:allPlayer', -1, text, source)
-- end, false)

