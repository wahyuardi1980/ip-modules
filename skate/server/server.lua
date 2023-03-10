ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('skate', function(source)
	local src = source
	TriggerClientEvent('longboard:start', src)
end)

RegisterServerEvent('shareImOnSkate')
AddEventHandler('shareImOnSkate', function(source) 
    local src = source
    TriggerClientEvent('shareHeIsOnSkate', -1, src)
end)
