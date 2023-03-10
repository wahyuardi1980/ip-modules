-----------
-- 3D ME --
-----------

-- Citizen.CreateThread(function()
-- 	TriggerEvent('chat:addSuggestion', '/me', 'Can show personal actions, face expressions & much more.')
-- end)

local nbrDisplaying = 1

RegisterCommand('do', function(source, args, raw)
    local textdo = string.sub(raw, 4)
    TriggerServerEvent('3ddo:shareDisplay', textdo)
end)

RegisterNetEvent('3ddo:triggerDisplay')
AddEventHandler('3ddo:triggerDisplay', function(textdo, source)
    local offset = 1 + (nbrDisplaying * 0.30)
    Display(GetPlayerFromServerId(source), textdo, offset)
end)

function Display(doPlayer, textdo, offset)
    local displaying = true

    Citizen.CreateThread(function()
        Wait(5000)
        displaying = false
    end)

    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        while displaying do
            Wait(0)
            local coordsDo = GetEntityCoords(GetPlayerPed(doPlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsDo, coords)
            if dist < 500 then
                DrawText3D(coordsDo['x'], coordsDo['y'], coordsDo['z'] + offset - 1.500, textdo)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x, y, z, textdo)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(textdo)
        DrawText(_x, _y)
        local factor = (string.len(textdo)) / 400
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 59, 8, 49, 68)
    end
end

-- bisik

-- RegisterNetEvent('bisik:allPlayer')
-- AddEventHandler('bisik:allPlayer', function(text, sourceId)
--     local source = GetPlayerFromServerId(sourceId)
--     local sourcePed = GetPlayerPed(source)
--     local targetPed = PlayerPedId()

--     local sourceCoords = GetEntityCoords(sourcePed)
--     local targetCoords = GetEntityCoords(targetPed)
--     local distance = #(targetCoords - sourceCoords)

--     if distance < 25.0 then
--         TriggerEvent('chat:addMessage', {
--             template = '<div class="chat-message-bisik">{0}</div>',
--             args = {text}
--           })
--     end
-- end)
