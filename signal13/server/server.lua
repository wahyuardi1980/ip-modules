-- print('Loaded signal-13 by skrub')
RegisterCommand("s13", function(source, args, rawCommand)
	TriggerClientEvent('s13', source, {})
end)



-- TriggerEvent('es:addCommand', 's13', function(source, args, user)
-- 	TriggerClientEvent('s13', source, {})
-- end, {help = "ACTIVATE SIGNAL 13"})

-- TriggerEvent('es:addCommand', 'S13', function(source, args, user)
-- 	TriggerClientEvent('s13', source, {})
-- end, {help = "ACTIVATE SIGNAL 13"})