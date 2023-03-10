-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local fishing = false
local InIlegalZone = false

if ConfigFishing.sellShop.enabled then
    CreateThread(function()
        -- CreateBlip(ConfigFishing.sellShop.coords, 356, 1, Strings.sell_shop_blip, 0.80)
        local ped, pedSpawned
        local textUI
        while true do
            local sleep = 1500
            local playerPed = cache.ped
            local coords = GetEntityCoords(playerPed)
            local dist = #(coords - ConfigFishing.sellShop.coords)
            if dist <= 30 and not pedSpawned then
                lib.requestAnimDict('mini@strip_club@idles@bouncer@base', 100)
                lib.requestModel(ConfigFishing.sellShop.ped, 100)
                ped = CreatePed(28, ConfigFishing.sellShop.ped, ConfigFishing.sellShop.coords.x,
                    ConfigFishing.sellShop.coords.y, ConfigFishing.sellShop.coords.z, ConfigFishing.sellShop.heading,
                    false,
                    false)
                FreezeEntityPosition(ped, true)
                SetEntityInvincible(ped, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                TaskPlayAnim(ped, 'mini@strip_club@idles@bouncer@base', 'base', 8.0, 0.0, -1, 1, 0, 0, 0, 0)
                pedSpawned = true
            elseif dist <= 1.8 and pedSpawned then
                sleep = 0
                if not textUI then
                    lib.showTextUI(Strings.sell_fish)
                    textUI = true
                end
                if IsControlJustReleased(0, 38) then
                    FishingSellItems()
                end
            elseif dist >= 1.9 and textUI then
                sleep = 0
                lib.hideTextUI()
                textUI = nil
            elseif dist >= 31 and pedSpawned then
                local model = GetEntityModel(ped)
                SetModelAsNoLongerNeeded(model)
                DeletePed(ped)
                SetPedAsNoLongerNeeded(ped)
                RemoveAnimDict('mini@strip_club@idles@bouncer@base')
                pedSpawned = nil
            end
            Wait(sleep)
        end
    end)
end

RegisterNetEvent('wasabi_fishing:startFishing')
AddEventHandler('wasabi_fishing:startFishing', function()
    if InIlegalZone then
        if IsPedInAnyVehicle(cache.ped) or IsPedSwimming(cache.ped) then
            TriggerEvent('wasabi_fishing:notify', Strings.cannot_perform, Strings.cannot_perform_desc, 'error')
            return
        end
        local hasItem = lib.callback.await('wasabi_fishing:checkItem', 100, ConfigFishing.bait.itemName)
        if hasItem then
            local water, waterLoc = WaterCheck()
            if water then
                if not fishing then
                    fishing = true
                    local model = `prop_fishing_rod_01`
                    lib.requestModel(model, 100)
                    local pole = CreateObject(model, GetEntityCoords(cache.ped), true, false, false)
                    AttachEntityToEntity(pole, cache.ped, GetPedBoneIndex(cache.ped, 18905), 0.1, 0.05, 0, 80.0, 120.0,
                        160.0,
                        true, true, false, true, 1, true)
                    SetModelAsNoLongerNeeded(model)
                    lib.requestAnimDict('mini@tennis', 100)
                    lib.requestAnimDict('amb@world_human_stand_fishing@idle_a', 100)
                    TaskPlayAnim(cache.ped, 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
                    Wait(3000)
                    TaskPlayAnim(cache.ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 11, 0, 0, 0,
                        0)
                    while fishing do
                        Wait()
                        local unarmed = `WEAPON_UNARMED`
                        SetCurrentPedWeapon(ped, unarmed)
                        lib.showTextUI('Tekan [F] Untuk Memancing | Tekan [X] Untuk Membatalkan Kapan Saja', {
                            position = "left-center",
                            icon = 'fas fa-fish',
                            style = {
                                borderRadius = 0,
                                backgroundColor = 'rgba(33, 35, 48, 0.9)',
                                color = 'white'
                            }
                        })
                        DisableControlAction(0, 23, true)
                        if IsDisabledControlJustReleased(0, 23) then
                            TaskPlayAnim(cache.ped, 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
                            TriggerEvent('wasabi_fishing:notify', Strings.waiting_bite, Strings.waiting_bite_desc,
                                'inform')
                            Wait(math.random(ConfigFishing.timeForBite.min, ConfigFishing.timeForBite.max))
                            TriggerEvent('wasabi_fishing:notify', Strings.got_bite, Strings.got_bite_desc, 'inform')
                            Wait(1000)
                            local fishData = lib.callback.await('wasabi_fishing:getFishData', 100)
                            if lib.skillCheck(fishData.difficulty) then
                                ClearPedTasks(cache.ped)
                                TryFish(fishData)
                                TaskPlayAnim(cache.ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0,
                                    11,
                                    0, 0, 0, 0)
                            else
                                local breakChance = math.random(1, 100)
                                if breakChance < ConfigFishing.fishingRod.breakChance then
                                    TriggerServerEvent('wasabi_fishing:rodBroke')
                                    TriggerEvent('wasabi_fishing:notify', Strings.rod_broke, Strings.rod_broke_desc,
                                        'error')
                                    ClearPedTasks(cache.ped)
                                    fishing = false
                                    break
                                end
                                TriggerEvent('wasabi_fishing:notify', Strings.failed_fish, Strings.failed_fish_desc,
                                    'error')
                            end
                        elseif IsControlJustReleased(0, 73) then
                            ClearPedTasks(cache.ped)
                            lib.hideTextUI()
                            break
                        elseif #(GetEntityCoords(cache.ped) - waterLoc) > 30 then
                            break
                        end
                    end
                    fishing = false
                    DeleteObject(pole)
                    RemoveAnimDict('mini@tennis')
                    RemoveAnimDict('amb@world_human_stand_fishing@idle_a')
                end
            else
                TriggerEvent('wasabi_fishing:notify', Strings.no_water, Strings.no_water_desc, 'error')
            end
        else
            TriggerEvent('wasabi_fishing:notify', Strings.no_bait, Strings.no_bait_desc, 'error')
        end
    else
        exports['mythic_notify']:DoHudText('error', 'Anda harus berada dizona pemancigan ilegal')
    end
end)

RegisterNetEvent('wasabi_fishing:interupt')
AddEventHandler('wasabi_fishing:interupt', function()
    fishing = false
    ClearPedTasks(cache.ped)
end)

CreateThread(function()
    -- blip and radius
    local blip = AddBlipForCoord(ConfigFishing.ilegalZone)
    SetBlipSprite(blip, 780)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Area Pemancigan Ilegal')
    EndTextCommandSetBlipName(blip)
    local RadiusBlip = AddBlipForRadius(ConfigFishing.ilegalZone, 300.00)
    SetBlipRotation(RadiusBlip, 0)
    SetBlipColour(RadiusBlip, 1)
    SetBlipAlpha(RadiusBlip, 64)
    --
    local FishingIlegalZone = CircleZone:Create(ConfigFishing.ilegalZone, 300.0, {
        name = 'FishingIlegalZone',
        heading = 0,
        debugPoly = false,
        minZ = 70.21 - 1.0,
        maxZ = 70.21 + 5.0
    })

    FishingIlegalZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            InIlegalZone = true
            lib.showTextUI('Area Pemancigan Ilegal', {
                position = "left-center",
                icon = 'fas fa-fish',
                style = {
                    borderRadius = 0,
                    backgroundColor = 'rgba(33, 35, 48, 0.9)',
                    color = 'white'
                }
            })
        else
            InIlegalZone = false
            lib.hideTextUI()
        end
    end)
end)
