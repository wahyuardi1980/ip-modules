ESX = nil
local InhuntingZone = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(AOD.Strings.ESXClient, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local baitexists, baitLocation, HuntedAnimalTable, busy = 0, nil, {}, false
DecorRegister('MyAnimal', 2) -- don't touch it

-- isValidZone = function()
--     local zoneInH = GetNameOfZone(GetEntityCoords(PlayerPedId()))
--     for k, v in pairs(AOD.HuntingZones) do
--         if zoneInH == v or AOD.HuntAnyWhere == true then
--             return true
--         end
--     end
-- end



-- zones
CreateThread(function()
    -- blip and radius
    local blip = AddBlipForCoord(AOD.HuntingArea)
    SetBlipSprite(blip, 141)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 33)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Area Pemburuan')
    EndTextCommandSetBlipName(blip)
    local RadiusBlip = AddBlipForRadius(AOD.HuntingArea, 300.00)
    SetBlipRotation(RadiusBlip, 0)
    SetBlipColour(RadiusBlip, 33)
    SetBlipAlpha(RadiusBlip, 64)
    -- end blips
    local huntingZone = CircleZone:Create(AOD.HuntingArea, 300.0, {
        name = 'huntingZone',
        heading = 0,
        debugPoly = false,
        minZ = 70.21 - 1.0,
        maxZ = 70.21 + 5.0
    })

    huntingZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            InhuntingZone = true
            lib.showTextUI('Area Pemburuan', {
                position = "left-center",
                icon = 'fas fa-hands',
                style = {
                    borderRadius = 0,
                    backgroundColor = 'rgba(33, 35, 48, 0.9)',
                    color = 'white'
                }
            })
        else
            InhuntingZone = false
            lib.hideTextUI()
        end
    end)
end)



SetSpawn = function(baitLocation)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local spawnCoords = nil
    while spawnCoords == nil do
        local spawnX = math.random(-AOD.SpawnDistanceRadius, AOD.SpawnDistanceRadius)
        local spawnY = math.random(-AOD.SpawnDistanceRadius, AOD.SpawnDistanceRadius)
        local spawnZ = baitLocation.z
        local vec = vector3(baitLocation.x + spawnX, baitLocation.y + spawnY, spawnZ)
        if #(playerCoords - vec) > AOD.SpawnDistanceRadius then
            spawnCoords = vec
        end
    end
    local worked, groundZ, normal = GetGroundZAndNormalFor_3dCoord(spawnCoords.x, spawnCoords.y, 1023.9)
    spawnCoords = vector3(spawnCoords.x, spawnCoords.y, groundZ)
    return spawnCoords
end

baitDown = function(baitLocation)
    Citizen.CreateThread(function()
        while baitLocation ~= nil do
            local coords = GetEntityCoords(PlayerPedId())
            if #(baitLocation - coords) > AOD.DistanceFromBait then
                if math.random() < AOD.SpawnChance then
                    SpawnAnimal(baitLocation)
                    baitLocation = nil
                end
            end
            Citizen.Wait(1000)
        end
    end)
end

SpawnAnimal = function(location)
    local spawn = SetSpawn(location)
    local model = GetHashKey(AOD.HuntAnimals[math.random(1, #AOD.HuntAnimals)])
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end
    local prey = CreatePed(28, model, spawn, true, true, true)
    DecorSetBool(prey, 'MyAnimal', true)
    TaskGoToCoordAnyMeans(prey, location, 1.0, 0, 0, 786603, 1.0) --added fix for animal getting stuck sometimes
    table.insert(HuntedAnimalTable, { id = prey, animal = model })
    SetModelAsNoLongerNeeded(model)
    if AOD.UseBlip then
        local blip = AddBlipForEntity(prey)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, 0.85)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(AOD.BlipText)
        EndTextCommandSetBlipName(blip)
    end
    Citizen.CreateThread(function()
        local destination = false
        while not IsPedDeadOrDying(prey) and not destination do
            local preyCoords = GetEntityCoords(prey)
            local distance = #(location - preyCoords)
            local guy = PlayerPedId()
            if distance < 0.35 then
                ClearPedTasks(prey)
                Citizen.Wait(1500)
                TaskStartScenarioInPlace(prey, 'WORLD_DEER_GRAZING', 0, true)
                Citizen.SetTimeout(8000, function()
                    destination = true
                end)
            end
            if #(preyCoords - GetEntityCoords(guy)) < AOD.DistanceTooCloseToAnimal then
                ClearPedTasks(prey)
                TaskSmartFleePed(prey, guy, 600.0, -1, true, true)
                destination = true
            end
            Citizen.Wait(1000)
        end
        if not IsPedDeadOrDying(prey) then
            TaskSmartFleePed(prey, guy, 600.0, -1, true, true)
        end
    end)
end

RegisterNetEvent('AOD-huntingbait')
AddEventHandler('AOD-huntingbait', function()
    -- if not isValidZone() then
    --     exports['mythic_notify']:DoHudTextAOD.Strings.NotValidZone)
    --     return
    -- end
    if not IsPedInAnyVehicle(PlayerPedId()) then
        if not InhuntingZone then
            exports['mythic_notify']:DoHudText('error', AOD.Strings.NotValidZone)
            return
        end
        if busy then
            exports['mythic_notify']:DoHudText('error', AOD.Strings.ExploitDetected)
            Citizen.Wait(2000)
            exports['mythic_notify']:DoHudText('error', AOD.Strings.DontSpawm)
            TriggerServerEvent('AOD-hunt:TakeItem', 'huntingbait')
            return
        end
        if baitexists ~= 0 and GetGameTimer() < (baitexists + 90000) then
            exports['mythic_notify']:DoHudText('inform', AOD.Strings.WaitToBait)
            return
        end
        baitexists = nil
        busy = true
        local player = PlayerPedId()
        TaskStartScenarioInPlace(player, 'WORLD_HUMAN_GARDENER_PLANT', 0, true)
        -- exports['progressBars']:startUI((15000), AOD.Strings.PlacingBait)
        if lib.progressBar({
                duration = 15000,
                label = AOD.Strings.PlacingBait,
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
            }) then
            Citizen.Wait(1000)
            ClearPedTasks(player)
            baitexists = GetGameTimer()
            local baitLocation = GetEntityCoords(player)
            exports['mythic_notify']:DoHudText('success', AOD.Strings.BaitPlaced)
            TriggerServerEvent('AOD-hunt:TakeItem', 'huntingbait')
            baitDown(baitLocation)
            SpawnBaitItem(baitLocation)
            busy = false
        else
            exports['mythic_notify']:DoHudText('error', 'Aksi Dibatalkan!')
            ClearPedTasks(player)
        end
    else
        exports['mythic_notify']:DoHudText('error', 'Tidak bisa melakukan aksi diatas kendaraan')
    end
end)

RegisterNetEvent('AOD-huntingknife')
AddEventHandler('AOD-huntingknife', function()
    Citizen.CreateThread(function()
        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_KNIFE') then
            Citizen.Wait(1000)
            for index, value in ipairs(HuntedAnimalTable) do
                local person = PlayerPedId()
                local AnimalCoords = GetEntityCoords(value.id)
                local PlyCoords = GetEntityCoords(person)
                local AnimalHealth = GetEntityHealth(value.id)
                local PlyToAnimal = #(PlyCoords - AnimalCoords)
                local gun = AOD.HuntingWeapon
                local d = GetPedCauseOfDeath(value.id)
                if DoesEntityExist(value.id) and AnimalHealth <= 0 and PlyToAnimal < 2.0 and (gun == d or gun == nil) and
                    not busy then
                    busy = true
                    NetworkSetFriendlyFireOption(true)
                    LoadAnimDict('amb@medic@standing@kneel@base')
                    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')
                    TaskTurnPedToFaceEntity(person, value.id, -1)
                    Citizen.Wait(1500)
                    ClearPedTasksImmediately(person)
                    TaskPlayAnim(person, 'amb@medic@standing@kneel@base', 'base', 8.0, -8.0, -1, 1, 0, false, false,
                        false)
                    TaskPlayAnim(person, 'anim@gangops@facility@servers@bodysearch@', 'player_search', 8.0, -8.0, -1, 48
                        , 0,
                        false, false, false)
                    -- exports['progressBars']:startUI((5000), AOD.Strings.Harvest)
                    if lib.progressBar({
                            duration = 5000,
                            label = AOD.Strings.Harvest,
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                            },
                        }) then
                        Citizen.Wait(100)
                        ClearPedTasks(person)
                        exports['mythic_notify']:DoHudText('success', AOD.Strings.Butchered)
                        DeleteEntity(value.id)
                        TriggerServerEvent('AOD-butcheranimal', value.animal)
                        busy = false
                        table.remove(HuntedAnimalTable, index)
                        DeleteBaitItem()
                    else
                        exports['mythic_notify']:DoHudText('error', 'Aksi Dibatalkan!')
                    end
                elseif busy then
                    exports['mythic_notify']:DoHudText('error', AOD.Strings.ExploitDetected)
                elseif gun ~= d and AnimalHealth <= 0 and PlyToAnimal < 2.0 then
                    exports['mythic_notify']:DoHudText('inform', AOD.Strings.Roadkill)
                    DeleteEntity(value.id)
                    table.remove(HuntedAnimalTable, index)
                    DeleteBaitItem()
                elseif PlyToAnimal > 3.0 then
                    exports['mythic_notify']:DoHudText('error', AOD.Strings.NoAnimal)
                elseif AnimalHealth > 0 then
                    exports['mythic_notify']:DoHudText('error', AOD.Strings.NotDead)
                elseif not DoesEntityExist(value.id) and PlyToAnimal < 2.0 then
                    exports['mythic_notify']:DoHudText('error', AOD.Strings.NotYours)
                else
                    exports['mythic_notify']:DoHudText('error', AOD.Strings.WTF)
                end
            end
        else
            exports['mythic_notify']:DoHudText('error', 'Anda Harus Memengang Pisau Ditangan')
        end
    end)
end)

SpawnBaitItem = function(result)
    local model = `prop_drug_package_02`
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(10) end
    local bait = CreateObject(model, result.x, result.y, result.z - 1.0, true, true, true)
    SetModelAsNoLongerNeeded(model)
    FreezeEntityPosition(bait, true)
end

DeleteBaitItem = function()
    local player = PlayerPedId()
    local location = GetEntityCoords(player)
    local bait = GetClosestObjectOfType(location, 5.0, `prop_drug_package_02`, false, false, false)
    local baitloc = GetEntityCoords(bait)
    if DoesEntityExist(bait) and #(location - baitloc) < 3 then
        DeleteEntity(bait)
    else
        print('no bait object found nearby?')
    end
end


LoadAnimDict = function(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end
end

Notify = function(text, timer)
    if timer == nil then
        timer = 5000
    end
    --exports['mythic_notify']:DoCustomHudText('vrm', text, timer)
    -- exports.pNotify:SendNotification({layout = 'centerLeft', text = text, type = 'error', timeout = timer})
    ESX.ShowNotification(text)
end

local hewan = {
    "a_c_boar",
    "a_c_deer",
    "a_c_coyote",
}

exports.qtarget:AddTargetModel(hewan, {
    options = {
        {
            event = "AOD-huntingknife",
            icon = "fas fa-cow",
            label = "Menyembelih Hewan",
            num = 1,
            canInteract = function()
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    return true
                end
            end,
        },
    },
    distance = 2
})
