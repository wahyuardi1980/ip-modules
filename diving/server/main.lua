RegisterNetEvent('qb-diving:server:removeItemAfterFill', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.removeInventoryItem("diving_fill", 1)
end)

-- Items
ESX.RegisterUsableItem("diving_gear", function(source)
    TriggerClientEvent("qb-diving:client:UseGear", source)
end)

ESX.RegisterUsableItem("diving_fill", function(source)
    TriggerClientEvent("qb-diving:client:setoxygenlevel", source)
end)
