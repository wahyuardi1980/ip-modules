if ConfigBensin.UseESX then
	Citizen.CreateThread(function()
		while not ESX do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

			Citizen.Wait(500)
		end
	end)
end

local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000
local fuelSynced = false
local inBlacklisted = false

function ManageFuelUsage(vehicle)
	if not DecorExistOn(vehicle, ConfigBensin.FuelDecor) then
		SetFuel(vehicle, math.random(200, 800) / 10)
	elseif not fuelSynced then
		SetFuel(vehicle, GetFuel(vehicle))

		fuelSynced = true
	end

	if IsVehicleEngineOn(vehicle) then
		SetFuel(vehicle,
			GetVehicleFuelLevel(vehicle) -
			ConfigBensin.FuelUsage[Round(GetVehicleCurrentRpm(vehicle), 1)] *
			(ConfigBensin.Classes[GetVehicleClass(vehicle)] or 1.0) / 10)
	end
end

Citizen.CreateThread(function()
	DecorRegister(ConfigBensin.FuelDecor, 1)

	for index = 1, #ConfigBensin.Blacklist do
		if type(ConfigBensin.Blacklist[index]) == 'string' then
			ConfigBensin.Blacklist[GetHashKey(ConfigBensin.Blacklist[index])] = true
		else
			ConfigBensin.Blacklist[ConfigBensin.Blacklist[index]] = true
		end
	end

	for index = #ConfigBensin.Blacklist, 1, -1 do
		table.remove(ConfigBensin.Blacklist, index)
	end

	while true do
		Citizen.Wait(1000)

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped) then
			local vehicle = GetVehiclePedIsIn(ped)

			if ConfigBensin.Blacklist[GetEntityModel(vehicle)] then
				inBlacklisted = true
			else
				inBlacklisted = false
			end

			if not inBlacklisted and GetPedInVehicleSeat(vehicle, -1) == ped then
				ManageFuelUsage(vehicle)
			end
		else
			if fuelSynced then
				fuelSynced = false
			end

			if inBlacklisted then
				inBlacklisted = false
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(250)

		local pumpObject, pumpDistance = FindNearestFuelPump()

		if pumpDistance < 2.5 then
			isNearPump = pumpObject

			if ConfigBensin.UseESX then
				local playerData = ESX.GetPlayerData()
				for i = 1, #playerData.accounts, 1 do
					if playerData.accounts[i].name == 'money' then
						currentCash = playerData.accounts[i].money
						break
					end
				end
			end
		else
			isNearPump = false

			Citizen.Wait(math.ceil(pumpDistance * 20))
		end
	end
end)

local pombensin = {
	-2007231801,
	1339433404,
	1694452750,
	1933174915,
	-462817101,
	-469694731,
	-164877493,
	-462817101,
}

exports.qtarget:AddTargetModel(pombensin, {
	options = {
		{
			event = "isi:bensin",
			icon = "fas fa-gas-pump",
			label = "Isi Bensin"
		},
		{
			event = "isi:jerigen",
			icon = "fas fa-oil-can",
			label = "Beli Jerigen"
		},
	},
	distance = 2
})

RegisterNetEvent('fuel:startFuelUpTick')
AddEventHandler('fuel:startFuelUpTick', function(pumpObject, ped, vehicle)
	currentFuel = GetVehicleFuelLevel(vehicle)

	while isFueling do
		Citizen.Wait(500)

		local oldFuel = DecorGetFloat(vehicle, ConfigBensin.FuelDecor)
		local fuelToAdd = math.random(10, 20) / 10.0
		local extraCost = fuelToAdd / 1.5 * ConfigBensin.CostMultiplier

		if not pumpObject then
			if GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100 >= 0 then
				currentFuel = oldFuel + fuelToAdd

				SetPedAmmo(ped, 883325847, math.floor(GetAmmoInPedWeapon(ped, 883325847) - fuelToAdd * 100))
			else
				isFueling = false
			end
		else
			currentFuel = oldFuel + fuelToAdd
		end

		if currentFuel > 100.0 then
			currentFuel = 100.0
			isFueling = false
		end

		currentCost = currentCost + extraCost

		if currentCash >= currentCost then
			SetFuel(vehicle, currentFuel)
		else
			isFueling = false
		end
	end

	if pumpObject then
		TriggerServerEvent('fuel:pay', currentCost)
	end

	currentCost = 0.0
end)

RegisterNetEvent('fuel:refuelFromPump')
AddEventHandler('fuel:refuelFromPump', function(pumpObject, ped, vehicle)
	TaskTurnPedToFaceEntity(ped, vehicle, 1000)
	Citizen.Wait(1000)
	SetCurrentPedWeapon(ped, -1569615261, true)
	LoadAnimDict("timetable@gardener@filling_can")
	TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)

	TriggerEvent('fuel:startFuelUpTick', pumpObject, ped, vehicle)

	while isFueling do
		for _, controlIndex in pairs(ConfigBensin.DisableKeys) do
			DisableControlAction(0, controlIndex)
		end

		local vehicleCoords = GetEntityCoords(vehicle)

		if pumpObject then
			local stringCoords = GetEntityCoords(pumpObject)
			local extraString = ""

			if ConfigBensin.UseESX then
				extraString = "\n" .. ConfigBensin.Strings.TotalCost .. ": ~g~$" .. Round(currentCost, 1)
			end

			DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
				ConfigBensin.Strings.CancelFuelingPump .. extraString)
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5, Round(currentFuel, 1) .. "%")
		else
			DrawText3Ds(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 0.5,
				ConfigBensin.Strings.CancelFuelingJerryCan ..
				"\nGas can: ~g~" ..
				Round(GetAmmoInPedWeapon(ped, 883325847) / 4500 * 100, 1) ..
				"% | Vehicle: " .. Round(currentFuel, 1) .. "%")
		end

		if not IsEntityPlayingAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 3) then
			TaskPlayAnim(ped, "timetable@gardener@filling_can", "gar_ig_5_filling_can", 2.0, 8.0, -1, 50, 0, 0, 0, 0)
		end

		if IsControlJustReleased(0, 38) or DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) or
			(isNearPump and GetEntityHealth(pumpObject) <= 0) then
			isFueling = false
		end

		Citizen.Wait(0)
	end

	ClearPedTasks(ped)
	RemoveAnimDict("timetable@gardener@filling_can")
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if not isFueling and
			((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
			if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
				local pumpCoords = GetEntityCoords(isNearPump)

				DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, ConfigBensin.Strings.ExitVehicle)
			else
				local vehicle = GetPlayersLastVehicle()
				local vehicleCoords = GetEntityCoords(vehicle)

				if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 2.5 then
					if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
						local stringCoords = GetEntityCoords(isNearPump)
						local canFuel = true

						if GetSelectedPedWeapon(ped) == 883325847 then
							stringCoords = vehicleCoords

							if GetAmmoInPedWeapon(ped, 883325847) < 100 then
								canFuel = false
							end
						end

						if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
							if currentCash > 0 then
								-- DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.EToRefuel)

								if IsControlJustReleased(0, 38) then
									isFueling = true

									-- TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
									LoadAnimDict("timetable@gardener@filling_can")
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
									ConfigBensin.Strings.NotEnoughCash)
							end
						elseif not canFuel then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
								ConfigBensin.Strings.JerryCanEmpty)
						else
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
								ConfigBensin.Strings.FullTank)
						end
					end
				elseif isNearPump then
					local stringCoords = GetEntityCoords(isNearPump)

					if currentCash >= ConfigBensin.JerryCanCost then
						if not HasPedGotWeapon(ped, 883325847) then
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
								ConfigBensin.Strings.PurchaseJerryCan)

							if IsControlJustReleased(0, 38) then
								-- GiveWeaponToPed(ped, 883325847, 4500, false, true)

								TriggerServerEvent('gas:GiveWeapon', ConfigBensin.JerryCanCost)

								currentCash = ESX.GetPlayerData().money
							end
						else
							if ConfigBensin.UseESX then
								local refillCost = Round(ConfigBensin.RefillCost *
								(1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))

								if refillCost > 0 then
									if currentCash >= refillCost then
										DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
											ConfigBensin.Strings.RefillJerryCan .. refillCost)

										if IsControlJustReleased(0, 38) then
											TriggerServerEvent('fuel:pay', refillCost)

											SetPedAmmo(ped, 883325847, 4500)
										end
									else
										DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
											ConfigBensin.Strings.NotEnoughCashJerryCan)
									end
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
										ConfigBensin.Strings.JerryCanFull)
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
									ConfigBensin.Strings.RefillJerryCan)

								if IsControlJustReleased(0, 38) then
									SetPedAmmo(ped, 883325847, 4500)
								end
							end
						end
					else
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
							ConfigBensin.Strings.NotEnoughCash)
					end
				else
					Citizen.Wait(250)
				end
			end
		else
			Citizen.Wait(250)
		end

		Citizen.Wait(0)
	end
end)

if ConfigBensin.ShowNearestGasStationOnly then
	Citizen.CreateThread(function()
		local currentGasBlip = 0

		while true do
			local coords = GetEntityCoords(PlayerPedId())
			local closest = 1000
			local closestCoords

			for _, gasStationCoords in pairs(ConfigBensin.GasStations) do
				local dstcheck = GetDistanceBetweenCoords(coords, gasStationCoords)

				if dstcheck < closest then
					closest = dstcheck
					closestCoords = gasStationCoords
				end
			end

			if DoesBlipExist(currentGasBlip) then
				RemoveBlip(currentGasBlip)
			end

			-- currentGasBlip = CreateBlip(closestCoords)

			Citizen.Wait(10000)
		end
	end)
elseif ConfigBensin.ShowAllGasStations then
	Citizen.CreateThread(function()
		for _, gasStationCoords in pairs(ConfigBensin.GasStations) do
			CreateBlip(gasStationCoords)
		end
	end)
end

if ConfigBensin.EnableHUD then
	local function DrawAdvancedText(x, y, w, h, sc, text, r, g, b, a, font, jus)
		SetTextFont(font)
		SetTextProportional(0)
		SetTextScale(sc, sc)
		N_0x4e096588b13ffeca(jus)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - 0.1 + w, y - 0.02 + h)
	end

	local mph = 0
	local kmh = 0
	local fuel = 0
	local displayHud = false

	local x = 0.01135
	local y = 0.002

	Citizen.CreateThread(function()
		while true do
			local ped = PlayerPedId()

			if IsPedInAnyVehicle(ped) and not (ConfigBensin.RemoveHUDForBlacklistedVehicle and inBlacklisted) then
				local vehicle = GetVehiclePedIsIn(ped)
				local speed = GetEntitySpeed(vehicle)

				mph = tostring(math.ceil(speed * 2.236936))
				kmh = tostring(math.ceil(speed * 3.6))
				fuel = tostring(math.ceil(GetVehicleFuelLevel(vehicle)))

				displayHud = true
			else
				displayHud = false

				Citizen.Wait(500)
			end

			Citizen.Wait(50)
		end
	end)

	-- Citizen.CreateThread(function()
	-- 	while true do
	-- 		if displayHud then
	-- 			DrawAdvancedText(0.130 - x, 0.77 - y, 0.005, 0.0028, 0.6, mph, 255, 255, 255, 255, 6, 1)
	-- 			DrawAdvancedText(0.174 - x, 0.77 - y, 0.005, 0.0028, 0.6, kmh, 255, 255, 255, 255, 6, 1)
	-- 			DrawAdvancedText(0.2195 - x, 0.77 - y, 0.005, 0.0028, 0.6, fuel, 255, 255, 255, 255, 6, 1)
	-- 			DrawAdvancedText(0.148 - x, 0.7765 - y, 0.005, 0.0028, 0.4, "mp/h              km/h              Fuel", 255, 255, 255, 255, 6, 1)
	-- 		else
	-- 			Citizen.Wait(750)
	-- 		end

	-- 		Citizen.Wait(0)
	-- 	end
	-- end)
end


RegisterNetEvent('isi:bensin')
AddEventHandler('isi:bensin', function()
	local ped = PlayerPedId()

	if not isFueling and
		((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
		if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
			local pumpCoords = GetEntityCoords(isNearPump)

			DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, ConfigBensin.Strings.ExitVehicle)
		else
			local vehicle = GetPlayersLastVehicle()
			local vehicleCoords = GetEntityCoords(vehicle)

			if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 2.5 then
				if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
					local stringCoords = GetEntityCoords(isNearPump)
					local canFuel = true

					if GetSelectedPedWeapon(ped) == 883325847 then
						stringCoords = vehicleCoords

						if GetAmmoInPedWeapon(ped, 883325847) < 100 then
							canFuel = false
						end
					end

					if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
						if currentCash > 0 then
							-- DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.EToRefuel)
							isFueling = true
							TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
							LoadAnimDict("timetable@gardener@filling_can")
						else
							-- DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.NotEnoughCash)
							exports['mythic_notify']:DoHudText('error', ConfigBensin.Strings.NotEnoughCash)
						end
					elseif not canFuel then
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
							ConfigBensin.Strings.JerryCanEmpty)
					else
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.FullTank)
					end
				end
			elseif isNearPump then
				local stringCoords = GetEntityCoords(isNearPump)

				if currentCash >= ConfigBensin.JerryCanCost then
					if not HasPedGotWeapon(ped, 883325847) then
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
							ConfigBensin.Strings.PurchaseJerryCan)

						-- GiveWeaponToPed(ped, 883325847, 4500, false, true)

						TriggerServerEvent('gas:GiveWeapon', ConfigBensin.JerryCanCost)

						currentCash = ESX.GetPlayerData().money
					else
						if ConfigBensin.UseESX then
							local refillCost = Round(ConfigBensin.RefillCost *
							(1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))

							if refillCost > 0 then
								if currentCash >= refillCost then
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
										ConfigBensin.Strings.RefillJerryCan .. refillCost)
									TriggerServerEvent('fuel:pay', refillCost)

									SetPedAmmo(ped, 883325847, 4500)
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
										ConfigBensin.Strings.NotEnoughCashJerryCan)
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
									ConfigBensin.Strings.JerryCanFull)
							end
						else
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
								ConfigBensin.Strings.RefillJerryCan)
							SetPedAmmo(ped, 883325847, 4500)
						end
					end
				else
					DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.NotEnoughCash)
				end
			else
				Citizen.Wait(250)
			end
		end
	else
		Citizen.Wait(250)
	end
end)

RegisterNetEvent('isi:jerigen')
AddEventHandler('isi:jerigen', function()
	local ped = PlayerPedId()

	if not isFueling and
		((isNearPump and GetEntityHealth(isNearPump) > 0) or (GetSelectedPedWeapon(ped) == 883325847 and not isNearPump)) then
		if IsPedInAnyVehicle(ped) and GetPedInVehicleSeat(GetVehiclePedIsIn(ped), -1) == ped then
			local pumpCoords = GetEntityCoords(isNearPump)

			DrawText3Ds(pumpCoords.x, pumpCoords.y, pumpCoords.z + 1.2, ConfigBensin.Strings.ExitVehicle)
		else
			local vehicle = GetPlayersLastVehicle()
			local vehicleCoords = GetEntityCoords(vehicle)

			if DoesEntityExist(vehicle) and GetDistanceBetweenCoords(GetEntityCoords(ped), vehicleCoords) < 2.5 then
				if not DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
					local stringCoords = GetEntityCoords(isNearPump)
					local canFuel = true

					if GetSelectedPedWeapon(ped) == 883325847 then
						stringCoords = vehicleCoords

						if GetAmmoInPedWeapon(ped, 883325847) < 100 then
							canFuel = false
						end
					end

					if GetVehicleFuelLevel(vehicle) < 95 and canFuel then
						if currentCash > 0 then
							-- DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.EToRefuel)
							isFueling = true
							-- TriggerEvent('fuel:refuelFromPump', isNearPump, ped, vehicle)
							LoadAnimDict("timetable@gardener@filling_can")
						else
							-- DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.NotEnoughCash)
							exports['mythic_notify']:DoHudText('error', ConfigBensin.Strings.NotEnoughCash)
						end
					elseif not canFuel then
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
							ConfigBensin.Strings.JerryCanEmpty)
					else
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.FullTank)
					end
				end
			elseif isNearPump then
				local stringCoords = GetEntityCoords(isNearPump)

				if currentCash >= ConfigBensin.JerryCanCost then
					if not HasPedGotWeapon(ped, 883325847) then
						DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
							ConfigBensin.Strings.PurchaseJerryCan)

						-- GiveWeaponToPed(ped, 883325847, 4500, false, true)

						TriggerServerEvent('gas:GiveWeapon', ConfigBensin.JerryCanCost)

						currentCash = ESX.GetPlayerData().money
					else
						if ConfigBensin.UseESX then
							local refillCost = Round(ConfigBensin.RefillCost *
							(1 - GetAmmoInPedWeapon(ped, 883325847) / 4500))

							if refillCost > 0 then
								if currentCash >= refillCost then
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
										ConfigBensin.Strings.RefillJerryCan .. refillCost)
									TriggerServerEvent('fuel:pay', refillCost)

									SetPedAmmo(ped, 883325847, 4500)
								else
									DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
										ConfigBensin.Strings.NotEnoughCashJerryCan)
								end
							else
								DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
									ConfigBensin.Strings.JerryCanFull)
							end
						else
							DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2,
								ConfigBensin.Strings.RefillJerryCan)
							SetPedAmmo(ped, 883325847, 4500)
						end
					end
				else
					-- DrawText3Ds(stringCoords.x, stringCoords.y, stringCoords.z + 1.2, ConfigBensin.Strings.NotEnoughCash)
					exports['mythic_notify']:DoHudText('error', ConfigBensin.Strings.NotEnoughCash)
				end
			else
				Citizen.Wait(250)
			end
		end
	else
		Citizen.Wait(250)
	end
end)
