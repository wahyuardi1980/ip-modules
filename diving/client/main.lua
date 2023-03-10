local iswearingsuit = false
local oxgenlevell = 0


local currentGear = {
    mask = 0,
    tank = 0,
    oxygen = 0,
    enabled = false
}

-- Functions
local function deleteGear()
    if currentGear.mask ~= 0 then
        DetachEntity(currentGear.mask, 0, 1)
        DeleteEntity(currentGear.mask)
        currentGear.mask = 0
    end
    if currentGear.tank ~= 0 then
        DetachEntity(currentGear.tank, 0, 1)
        DeleteEntity(currentGear.tank)
        currentGear.tank = 0
    end
end
local function gearAnim()
    RequestAnimDict("clothingshirt")
    while not HasAnimDictLoaded("clothingshirt") do
        Wait(0)
    end
    TaskPlayAnim(PlayerPedId(), "clothingshirt", "try_shirt_positive_d", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
end


-- Events
RegisterNetEvent("qb-diving:client:setoxygenlevel", function()
    if oxgenlevell == 0 then
        oxgenlevell = ConfigDiving.oxygenlevel -- oxygenlevel
        exports['mythic_notify']:DoHudText('success', 'You took your wetsuit off')
        TriggerServerEvent('qb-diving:server:removeItemAfterFill')
    else
        -- QBCore.Functions.Notify(Lang:t("error.oxygenlevel", { oxygenlevel = oxgenlevell }), 'error')
        exports['mythic_notify']:DoHudText('error', 'the gear level is ' .. oxgenlevell .. ' must be 0%')
    end
end)
function DrawText2(text)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(0.0, 0.45)
    SetTextDropshadow(1, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.45, 0.90)
end

RegisterNetEvent('qb-diving:client:UseGear', function()
    local ped = PlayerPedId()
    if iswearingsuit == false then
        if oxgenlevell > 0 then
            iswearingsuit = true
            if not IsPedSwimming(ped) and not IsPedInAnyVehicle(ped) then
                gearAnim()
                if lib.progressBar({
                        duration = 5000,
                        label = 'Put on a diving suit',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                        },
                    }) then
                    deleteGear()
                    local maskModel = `p_d_scuba_mask_s`
                    local tankModel = `p_s_scuba_tank_s`
                    RequestModel(tankModel)
                    while not HasModelLoaded(tankModel) do
                        Wait(0)
                    end
                    currentGear.tank = CreateObject(tankModel, 1.0, 1.0, 1.0, 1, 1, 0)
                    local bone1 = GetPedBoneIndex(ped, 24818)
                    AttachEntityToEntity(currentGear.tank, ped, bone1, -0.25, -0.25, 0.0, 180.0, 90.0, 0.0, 1, 1, 0,
                        0, 2, 1)

                    RequestModel(maskModel)
                    while not HasModelLoaded(maskModel) do
                        Wait(0)
                    end
                    currentGear.mask = CreateObject(maskModel, 1.0, 1.0, 1.0, 1, 1, 0)
                    local bone2 = GetPedBoneIndex(ped, 12844)
                    AttachEntityToEntity(currentGear.mask, ped, bone2, 0.0, 0.0, 0.0, 180.0, 90.0, 0.0, 1, 1, 0, 0, 2
                    , 1)
                    SetEnableScuba(ped, true)
                    SetPedMaxTimeUnderwater(ped, 2000.00)
                    currentGear.enabled = true
                    ClearPedTasks(ped)
                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                    oxgenlevell = oxgenlevell
                    Citizen.CreateThread(function()
                        while currentGear.enabled do
                            if IsPedSwimmingUnderWater(PlayerPedId()) then
                                oxgenlevell = oxgenlevell - 1
                                if oxgenlevell == 90 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 80 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 70 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 60 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 50 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 40 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 30 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 20 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 10 then
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", "breathdivingsuit", 0.25)
                                elseif oxgenlevell == 0 then
                                    --   deleteGear()
                                    SetEnableScuba(ped, false)
                                    SetPedMaxTimeUnderwater(ped, 1.00)
                                    currentGear.enabled = false
                                    iswearingsuit = false
                                    TriggerServerEvent("InteractSound_SV:PlayOnSource", nil, 0.25)
                                end
                            end
                            Wait(1000)
                        end
                    end)
                else
                    exports['mythic_notify']:DoHudText('error', 'Aksi Dibatalkan')
                end
            else
                exports['mythic_notify']:DoHudText('error', 'You need to be standing up to put on the diving gear')
            end
        else
            exports['mythic_notify']:DoHudText('error', 'you need oxygen tube')
        end
    elseif iswearingsuit == true then
        gearAnim()
        if lib.progressBar({
                duration = 5000,
                label = 'Pull out a diving suit ..',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
            }) then
            SetEnableScuba(ped, false)
            SetPedMaxTimeUnderwater(ped, 50.00)
            currentGear.enabled = false
            ClearPedTasks(ped)
            deleteGear()
            exports['mythic_notify']:DoHudText('success', 'You took your wetsuit off')
            TriggerServerEvent("InteractSound_SV:PlayOnSource", nil, 0.25)
            iswearingsuit = false
            oxgenlevell = oxgenlevell
        else
            exports['mythic_notify']:DoHudText('error', 'Aksi Dibatalkan')
        end
    end
end)





-- Threads
CreateThread(function()
    while true do
        Wait(0)
        if currentGear.enabled == true and iswearingsuit == true then
            if IsPedSwimmingUnderWater(PlayerPedId()) then
                DrawText2(oxgenlevell .. '⏱')
            end
        end
    end
end)
