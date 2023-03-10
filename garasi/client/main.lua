local CurrentActionData, PlayerData, userProperties, this_Garage, vehInstance, BlipList, PrivateBlips, JobBlips = {}, {}
	, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker, WasInPound, WasinJPound = false, false, false
local LastZone, CurrentAction, CurrentActionMsg, garage
local namagpp
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	CreateBlips()
	RefreshJobBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if ConfigGarasi.UsePrivateCarGarages then
		ESX.TriggerServerCallback('ip-garasi:getOwnedProperties', function(properties)
			userProperties = properties
			DeletePrivateBlips()
			RefreshPrivateBlips()
			-- garasipribadi()
		end)
	end

	ESX.PlayerData = xPlayer

	RefreshJobBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	DeleteJobBlips()
	RefreshJobBlips()
end)

RegisterNetEvent('ip-garasi:getPropertiesC')
AddEventHandler('ip-garasi:getPropertiesC', function(xPlayer)
	if ConfigGarasi.UsePrivateCarGarages then
		ESX.TriggerServerCallback('ip-garasi:getOwnedProperties', function(properties)
			userProperties = properties
			DeletePrivateBlips()
			RefreshPrivateBlips()
			-- garasipribadi()
		end)

		ESX.ShowNotification(_U('get_properties'))
		TriggerServerEvent('ip-garasi:printGetProperties')
	end
end)

local function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

-- Start of Ambulance Code
function ListOwnedAmbulanceMenu()
	local elements = {}

	if ConfigGarasi.ShowVehicleLocation and ConfigGarasi.ShowSpacers then
		local spacer = (
			'| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - <span style="color:red;">%s</span> |'
			):format(_U('plate'), _U('vehicle'), _U('location'))
		table.insert(elements, { label = spacer, value = nil })
	elseif ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
		local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |'):format(
			_U('plate')
			, _U('vehicle'))
		table.insert(elements, { label = ('<span style="color:red;">%s</span>'):format(_U('spacer1')), value = nil })
		table.insert(elements, { label = spacer, value = nil })
	end

	ESX.TriggerServerCallback('ip-garasi:getOwnedAmbulanceCars', function(ownedAmbulanceCars)
		if #ownedAmbulanceCars == 0 then
			ESX.ShowNotification(_U('garage_no_ambulance'))
		else
			for _, v in pairs(ownedAmbulanceCars) do
				local hashVehicule = v.vehicle.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName = GetLabelText(aheadVehName)
				local plate = v.plate
				local labelvehicle
				local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
					:
					format(plate, vehicleName)
				local labelvehicle3 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> | ')
					:
					format(plate, vehicleName)

				if ConfigGarasi.ShowVehicleLocation then
					if v.stored then
						labelvehicle = labelvehicle2 ..
							('<span style="color:green;">%s</span> |'):format(_U('loc_garage'))
					else
						labelvehicle = labelvehicle2 .. ('<span style="color:red;">%s</span> |'):format(_U('loc_pound'))
					end
				else
					if v.stored then
						labelvehicle = labelvehicle3
					else
						labelvehicle = labelvehicle3
					end
				end

				table.insert(elements, { label = labelvehicle, value = v })
			end
		end

		table.insert(elements, { label = _U('spacer2'), value = nil })

		ESX.TriggerServerCallback('ip-garasi:getOwnedAmbulanceAircrafts', function(ownedAmbulanceAircrafts)
			if #ownedAmbulanceAircrafts == 0 then
				ESX.ShowNotification(_U('garage_no_ambulance_aircraft'))
			else
				for _, v in pairs(ownedAmbulanceAircrafts) do
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName = GetLabelText(aheadVehName)
					local plate = v.plate
					local labelvehicle
					local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
						:
						format(plate, vehicleName)
					local labelvehicle3 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> | ')
						:
						format(plate, vehicleName)

					if ConfigGarasi.ShowVehicleLocation then
						if v.stored then
							labelvehicle = labelvehicle2 ..
								('<span style="color:green;">%s</span> |'):format(_U('loc_garage'))
						else
							labelvehicle = labelvehicle2 ..
								('<span style="color:red;">%s</span> |'):format(_U('loc_pound'))
						end
					else
						if v.stored then
							labelvehicle = labelvehicle3
						else
							labelvehicle = labelvehicle3
						end
					end

					table.insert(elements, { label = labelvehicle, value = v })
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_ambulance', {
				title = _U('garage_ambulance'),
				align = ConfigGarasi.MenuAlign,
				elements = elements
			}, function(data, menu)
				if data.current.value == nil then
				elseif data.current.value.vtype == 'aircraft' or data.current.value.vtype == 'helicopter' then
					if data.current.value.stored then
						menu.close()
						SpawnVehicle2(data.current.value.vehicle, data.current.value.plate)
					else
						ESX.ShowNotification(_U('ambulance_is_impounded'))
					end
				else
					if data.current.value.stored then
						menu.close()
						SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
					else
						ESX.ShowNotification(_U('ambulance_is_impounded'))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end)
	end)
end

function StoreOwnedAmbulanceMenu()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(PlayerPedId(), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('ip-garasi:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if ConfigGarasi.UseDamageMult then
						local apprasial = math.floor((1000 - engineHealth) / 1000 * ConfigGarasi.AmbulancePoundPrice *
						ConfigGarasi.DamageMult)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth) / 1000 * ConfigGarasi.AmbulancePoundPrice)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end

function ReturnOwnedAmbulanceMenu(location)
	local isimenu = {}
	if WasinJPound then
		ESX.ShowNotification(_U('must_wait', ConfigGarasi.JPoundWait))
	else
		ESX.TriggerServerCallback('ip-garasi:getOutOwnedAmbulanceCars', function(ownedAmbulanceCars)
			local elements = {}

			if ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
				local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |')
					:format(_U('plate')
						, _U('vehicle'))
				table.insert(elements, { label = spacer, value = nil })
			end

			for _, v in pairs(ownedAmbulanceCars) do
				if ConfigGarasi.UseVehicleNamesLua then
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName = GetLabelText(aheadVehName)
					local plate = v.plate
					local labelvehicle
					local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
						:
						format(plate, vehicleName)

					labelvehicle = labelvehicle2 .. ('<span style="color:green;">%s</span> |'):format(_U('return'))

					-- table.insert(elements, {label = labelvehicle, value = v})
					table.insert(isimenu,
						{
							title = vehicleName,
							description = 'Membayar asuransi kendaraan dan mengambil kendaraan ' .. vehicleName,
							metadata = { ['Biaya Asuransi'] = '$' .. ESX.Math.GroupDigits(ConfigGarasi.CarPoundPrice),
								['Plat Kendaraan'] = v.vehicle.plate,['Mesin'] = ESX.Math.Round(health) .. '%' },
							event = 'ip-garasi:keluardariAsuransiJob',
							args = { vehicle = v.vehicle, plate = v.vehicle.plate, location = location }
						})
				end
			end
			lib.registerContext({
				id = 'asuransi',
				title = 'Asuransi',
				options = isimenu
			})
			lib.showContext('asuransi')

			-- ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_ambulance', {
			-- 	title = _U('pound_ambulance', ESX.Math.GroupDigits(ConfigGarasi.AmbulancePoundPrice)),
			-- 	align = ConfigGarasi.MenuAlign,
			-- 	elements = elements
			-- }, function(data, menu)
			-- 	local doesVehicleExist = false

			-- 	for k,v in pairs (vehInstance) do
			-- 		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.value.plate) then
			-- 			if DoesEntityExist(v.vehicleentity) then
			-- 				doesVehicleExist = true
			-- 			else
			-- 				table.remove(vehInstance, k)
			-- 				doesVehicleExist = false
			-- 			end
			-- 		end
			-- 	end

			-- 	if not doesVehicleExist and not DoesAPlayerDrivesVehicle(data.current.value.plate) then
			-- 		ESX.TriggerServerCallback('ip-garasi:checkMoneyAmbulance', function(hasEnoughMoney)
			-- 			if hasEnoughMoney then
			-- 				if data.current.value == nil then
			-- 				else
			-- 					SpawnVehicle(data.current.value, data.current.value.plate)
			-- 					TriggerServerEvent('ip-garasi:payAmbulance')
			-- 					if ConfigGarasi.UsePoundTimer then
			-- 						WasinJPound = true
			-- 					end
			-- 				end
			-- 			else
			-- 				ESX.ShowNotification(_U('not_enough_money'))
			-- 			end
			-- 		end)
			-- 	else
			-- 		ESX.ShowNotification(_U('cant_take_out'))
			-- 	end
			-- end, function(data, menu)
			-- 	menu.close()
			-- end)
		end)
	end
end

-- End of Ambulance Code

-- Start of Police Code
function ListOwnedPoliceMenu()
	local elements = {}

	if ConfigGarasi.ShowVehicleLocation and ConfigGarasi.ShowSpacers then
		local spacer = (
			'| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - <span style="color:red;">%s</span> |'
			):format(_U('plate'), _U('vehicle'), _U('location'))
		table.insert(elements, { label = spacer, value = nil })
	elseif ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
		local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |'):format(
			_U('plate')
			, _U('vehicle'))
		table.insert(elements, { label = ('<span style="color:red;">%s</span>'):format(_U('spacer1')), value = nil })
		table.insert(elements, { label = spacer, value = nil })
	end

	ESX.TriggerServerCallback('ip-garasi:getOwnedPoliceCars', function(ownedPoliceCars)
		if #ownedPoliceCars == 0 then
			ESX.ShowNotification(_U('garage_no_police'))
		else
			for _, v in pairs(ownedPoliceCars) do
				local hashVehicule = v.vehicle.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName = GetLabelText(aheadVehName)
				local plate = v.plate
				local labelvehicle
				local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
					:
					format(plate, vehicleName)
				local labelvehicle3 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> | ')
					:
					format(plate, vehicleName)

				if ConfigGarasi.ShowVehicleLocation then
					if v.stored then
						labelvehicle = labelvehicle2 ..
							('<span style="color:green;">%s</span> |'):format(_U('loc_garage'))
					else
						labelvehicle = labelvehicle2 .. ('<span style="color:red;">%s</span> |'):format(_U('loc_pound'))
					end
				else
					if v.stored then
						labelvehicle = labelvehicle3
					else
						labelvehicle = labelvehicle3
					end
				end

				table.insert(elements, { label = labelvehicle, value = v })
			end
		end

		table.insert(elements, { label = _U('spacer2'), value = nil })

		ESX.TriggerServerCallback('ip-garasi:getOwnedPoliceAircrafts', function(ownedPoliceAircrafts)
			if #ownedPoliceAircrafts == 0 then
				ESX.ShowNotification(_U('garage_no_police_aircraft'))
			else
				for _, v in pairs(ownedPoliceAircrafts) do
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName = GetLabelText(aheadVehName)
					local plate = v.plate
					local labelvehicle
					local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
						:
						format(plate, vehicleName)
					local labelvehicle3 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> | ')
						:
						format(plate, vehicleName)

					if ConfigGarasi.ShowVehicleLocation then
						if v.stored then
							labelvehicle = labelvehicle2 ..
								('<span style="color:green;">%s</span> |'):format(_U('loc_garage'))
						else
							labelvehicle = labelvehicle2 ..
								('<span style="color:red;">%s</span> |'):format(_U('loc_pound'))
						end
					else
						if v.stored then
							labelvehicle = labelvehicle3
						else
							labelvehicle = labelvehicle3
						end
					end

					table.insert(elements, { label = labelvehicle, value = v })
				end
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_police', {
				title = _U('garage_police'),
				align = ConfigGarasi.MenuAlign,
				elements = elements
			}, function(data, menu)
				if data.current.value == nil then
				elseif data.current.value.vtype == 'aircraft' or data.current.value.vtype == 'helicopter' then
					if data.current.value.stored then
						menu.close()
						SpawnVehicle2(data.current.value.vehicle, data.current.value.plate)
					else
						ESX.ShowNotification(_U('police_is_impounded'))
					end
				else
					if data.current.value.stored then
						menu.close()
						SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
					else
						ESX.ShowNotification(_U('police_is_impounded'))
					end
				end
			end, function(data, menu)
				menu.close()
			end)
		end)
	end)
end

function StoreOwnedPoliceMenu()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(PlayerPedId(), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('ip-garasi:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if ConfigGarasi.UseDamageMult then
						local apprasial = math.floor((1000 - engineHealth) / 1000 * ConfigGarasi.PolicePoundPrice *
						ConfigGarasi.DamageMult)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth) / 1000 * ConfigGarasi.PolicePoundPrice)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end

function ReturnOwnedPoliceMenu(location)
	local isimenu = {}
	if WasinJPound then
		ESX.ShowNotification(_U('must_wait', ConfigGarasi.JPoundWait))
	else
		ESX.TriggerServerCallback('ip-garasi:getOutOwnedPoliceCars', function(ownedPoliceCars)
			local elements = {}

			if ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
				local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |')
					:format(_U('plate')
						, _U('vehicle'))
				table.insert(elements, { label = spacer, value = nil })
			end

			for _, v in pairs(ownedPoliceCars) do
				if ConfigGarasi.UseVehicleNamesLua then
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName = GetLabelText(aheadVehName)
					local plate = v.plate
					local labelvehicle
					local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
						:
						format(plate, vehicleName)

					labelvehicle = labelvehicle2 .. ('<span style="color:green;">%s</span> |'):format(_U('return'))

					-- table.insert(elements, {label = labelvehicle, value = v})
					table.insert(isimenu,
						{
							title = vehicleName,
							description = 'Membayar asuransi kendaraan dan mengambil kendaraan ' .. vehicleName,
							metadata = { ['Biaya Asuransi'] = '$' .. ESX.Math.GroupDigits(ConfigGarasi.CarPoundPrice),
								['Plat Kendaraan'] = v.vehicle.plate },
							event = 'ip-garasi:keluardariAsuransiJob',
							args = { vehicle = v.vehicle, plate = v.vehicle.plate, location = location }
						})
				end
			end

			lib.registerContext({
				id = 'asuransi',
				title = 'Asuransi',
				options = isimenu
			})
			lib.showContext('asuransi')

			-- ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_police', {
			-- 	title = _U('pound_police', ESX.Math.GroupDigits(ConfigGarasi.PolicePoundPrice)),
			-- 	align = ConfigGarasi.MenuAlign,
			-- 	elements = elements
			-- }, function(data, menu)
			-- 	local doesVehicleExist = false

			-- 	for k,v in pairs (vehInstance) do
			-- 		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.value.plate) then
			-- 			if DoesEntityExist(v.vehicleentity) then
			-- 				doesVehicleExist = true
			-- 			else
			-- 				table.remove(vehInstance, k)
			-- 				doesVehicleExist = false
			-- 			end
			-- 		end
			-- 	end

			-- 	if not doesVehicleExist and not DoesAPlayerDrivesVehicle(data.current.value.plate) then
			-- 		ESX.TriggerServerCallback('ip-garasi:checkMoneyPolice', function(hasEnoughMoney)
			-- 			if hasEnoughMoney then
			-- 				if data.current.value == nil then
			-- 				else
			-- 					SpawnVehicle(data.current.value, data.current.value.plate)
			-- 					TriggerServerEvent('ip-garasi:payPolice')
			-- 					if ConfigGarasi.UsePoundTimer then
			-- 						WasinJPound = true
			-- 					end
			-- 				end
			-- 			else
			-- 				ESX.ShowNotification(_U('not_enough_money'))
			-- 			end
			-- 		end)
			-- 	else
			-- 		ESX.ShowNotification(_U('cant_take_out'))
			-- 	end
			-- end, function(data, menu)
			-- 	menu.close()
			-- end)
		end)
	end
end

-- End of Police Code

-- Start of Aircraft Code
function ListOwnedAircraftsMenu()
	local elements = {}

	if ConfigGarasi.ShowVehicleLocation and ConfigGarasi.ShowSpacers then
		local spacer = (
			'| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - <span style="color:red;">%s</span> |'
			):format(_U('plate'), _U('vehicle'), _U('location'))
		table.insert(elements, { label = spacer, value = nil })
	elseif ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
		local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |'):format(
			_U('plate')
			, _U('vehicle'))
		table.insert(elements, { label = ('<span style="color:red;">%s</span>'):format(_U('spacer1')), value = nil })
		table.insert(elements, { label = spacer, value = nil })
	end

	ESX.TriggerServerCallback('ip-garasi:getOwnedAircrafts', function(ownedAircrafts)
		if #ownedAircrafts == 0 then
			ESX.ShowNotification(_U('garage_no_aircrafts'))
		else
			for _, v in pairs(ownedAircrafts) do
				local hashVehicule = v.vehicle.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName = GetLabelText(aheadVehName)
				local plate = v.plate
				local labelvehicle
				local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
					:
					format(plate, vehicleName)
				local labelvehicle3 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> | ')
					:
					format(plate, vehicleName)

				if ConfigGarasi.ShowVehicleLocation then
					if v.stored then
						labelvehicle = labelvehicle2 ..
							('<span style="color:green;">%s</span> |'):format(_U('loc_garage'))
					else
						labelvehicle = labelvehicle2 .. ('<span style="color:red;">%s</span> |'):format(_U('loc_pound'))
					end
				else
					if v.stored then
						labelvehicle = labelvehicle3
					else
						labelvehicle = labelvehicle3
					end
				end

				table.insert(elements, { label = labelvehicle, value = v })
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_aircraft', {
			title = _U('garage_aircrafts'),
			align = ConfigGarasi.MenuAlign,
			elements = elements
		}, function(data, menu)
			if data.current.value == nil then
			else
				if data.current.value.stored then
					menu.close()
					SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
				else
					ESX.ShowNotification(_U('aircraft_is_impounded'))
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function StoreOwnedAircraftsMenu()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(PlayerPedId(), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('ip-garasi:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if ConfigGarasi.UseDamageMult then
						local apprasial = math.floor((1000 - engineHealth) / 1000 * ConfigGarasi.AircraftPoundPrice *
						ConfigGarasi.DamageMult)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth) / 1000 * ConfigGarasi.AircraftPoundPrice)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end

function ReturnOwnedAircraftsMenu()
	if WasInPound then
		ESX.ShowNotification(_U('must_wait', ConfigGarasi.PoundWait))
	else
		ESX.TriggerServerCallback('ip-garasi:getOutOwnedAircrafts', function(ownedAircrafts)
			local elements = {}

			if ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
				local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |')
					:format(_U('plate')
						, _U('vehicle'))
				table.insert(elements, { label = spacer, value = nil })
			end

			for _, v in pairs(ownedAircrafts) do
				local hashVehicule = v.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName = GetLabelText(aheadVehName)
				local plate = v.plate
				local labelvehicle
				local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
					:
					format(plate, vehicleName)

				labelvehicle = labelvehicle2 .. ('<span style="color:green;">%s</span> |'):format(_U('return'))

				table.insert(elements, { label = labelvehicle, value = v })
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_aircraft', {
				title = _U('pound_aircrafts', ESX.Math.GroupDigits(ConfigGarasi.AircraftPoundPrice)),
				align = ConfigGarasi.MenuAlign,
				elements = elements
			}, function(data, menu)
				local doesVehicleExist = false

				for k, v in pairs(vehInstance) do
					if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.value.plate) then
						if DoesEntityExist(v.vehicleentity) then
							doesVehicleExist = true
						else
							table.remove(vehInstance, k)
							doesVehicleExist = false
						end
					end
				end

				if not doesVehicleExist and not DoesAPlayerDrivesVehicle(data.current.value.plate) then
					ESX.TriggerServerCallback('ip-garasi:checkMoneyAircrafts', function(hasEnoughMoney)
						if hasEnoughMoney then
							if data.current.value == nil then
							else
								SpawnVehicle(data.current.value, data.current.value.plate)
								TriggerServerEvent('ip-garasi:payAircraft')
								if ConfigGarasi.UsePoundTimer then
									WasInPound = true
								end
							end
						else
							ESX.ShowNotification(_U('not_enough_money'))
						end
					end)
				else
					ESX.ShowNotification(_U('cant_take_out'))
				end
			end, function(data, menu)
				menu.close()
			end)
		end)
	end
end

-- End of Aircraft Code

-- Start of Boat Code
function ListOwnedBoatsMenu()
	local elements = {}

	if ConfigGarasi.ShowVehicleLocation and ConfigGarasi.ShowSpacers then
		local spacer = (
			'| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - <span style="color:red;">%s</span> |'
			):format(_U('plate'), _U('vehicle'), _U('location'))
		table.insert(elements, { label = spacer, value = nil })
	elseif ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
		local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |'):format(
			_U('plate')
			, _U('vehicle'))
		table.insert(elements, { label = ('<span style="color:red;">%s</span>'):format(_U('spacer1')), value = nil })
		table.insert(elements, { label = spacer, value = nil })
	end

	ESX.TriggerServerCallback('ip-garasi:getOwnedBoats', function(ownedBoats)
		if #ownedBoats == 0 then
			ESX.ShowNotification(_U('garage_no_boats'))
		else
			for _, v in pairs(ownedBoats) do
				if ConfigGarasi.UseVehicleNamesLua then
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName = GetLabelText(aheadVehName)
					local plate = v.plate
					local labelvehicle
					local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
					local labelvehicle3 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> | ')

					if ConfigGarasi.ShowVehicleLocation then
						if v.stored then
							labelvehicle = labelvehicle2 ..
								('<span style="color:green;">%s</span> |'):format(_U('loc_garage'))
						else
							labelvehicle = labelvehicle2 ..
								('<span style="color:red;">%s</span> |'):format(_U('loc_pound'))
						end
					else
						if v.stored then
							labelvehicle = labelvehicle3
						else
							labelvehicle = labelvehicle3
						end
					end

					table.insert(elements, { label = labelvehicle, value = v })
				end
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_boat', {
			title = _U('garage_boats'),
			align = ConfigGarasi.MenuAlign,
			elements = elements
		}, function(data, menu)
			if data.current.value == nil then
			else
				if data.current.value.stored then
					menu.close()
					SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
				else
					ESX.ShowNotification(_U('boat_is_impounded'))
				end
			end
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function StoreOwnedBoatsMenu()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(PlayerPedId(), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('ip-garasi:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if ConfigGarasi.UseDamageMult then
						local apprasial = math.floor((1000 - engineHealth) / 1000 * ConfigGarasi.BoatPoundPrice *
						ConfigGarasi.DamageMult)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					else
						local apprasial = math.floor((1000 - engineHealth) / 1000 * ConfigGarasi.BoatPoundPrice)
						RepairVehicle(apprasial, vehicle, vehicleProps)
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end

function ReturnOwnedBoatsMenu()
	if WasInPound then
		ESX.ShowNotification(_U('must_wait', ConfigGarasi.PoundWait))
	else
		ESX.TriggerServerCallback('ip-garasi:getOutOwnedBoats', function(ownedBoats)
			local elements = {}

			if ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
				local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |')
					:format(_U('plate')
						, _U('vehicle'))
				table.insert(elements, { label = spacer, value = nil })
			end

			for _, v in pairs(ownedBoats) do
				local hashVehicule = v.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName = GetLabelText(aheadVehName)
				local plate = v.plate
				local labelvehicle
				local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
					:
					format(plate, vehicleName)

				labelvehicle = labelvehicle2 .. ('<span style="color:green;">%s</span> |'):format(_U('return'))

				table.insert(elements, { label = labelvehicle, value = v })
			end

			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_boat', {
				title = _U('pound_boats', ESX.Math.GroupDigits(ConfigGarasi.BoatPoundPrice)),
				align = ConfigGarasi.MenuAlign,
				elements = elements
			}, function(data, menu)
				local doesVehicleExist = false

				for k, v in pairs(vehInstance) do
					if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.value.plate) then
						if DoesEntityExist(v.vehicleentity) then
							doesVehicleExist = true
						else
							table.remove(vehInstance, k)
							doesVehicleExist = false
						end
					end
				end

				if not doesVehicleExist and not DoesAPlayerDrivesVehicle(data.current.value.plate) then
					ESX.TriggerServerCallback('ip-garasi:checkMoneyBoats', function(hasEnoughMoney)
						if hasEnoughMoney then
							if data.current.value == nil then
							else
								SpawnVehicle(data.current.value, data.current.value.plate)
								TriggerServerEvent('ip-garasi:payBoat')
								if ConfigGarasi.UsePoundTimer then
									WasInPound = true
								end
							end
						else
							ESX.ShowNotification(_U('not_enough_money'))
						end
					end)
				else
					ESX.ShowNotification(_U('cant_take_out'))
				end
			end, function(data, menu)
				menu.close()
			end)
		end)
	end
end

-- End of Boat Code

-- Start of Car Code
function ListOwnedCarsMenu(currentGarage)
	local elements = {}
	local isimenu = {}

	if ConfigGarasi.ShowVehicleLocation and ConfigGarasi.ShowSpacers then
		--local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - <span style="color:red;">%s</span> |'):format(_U('plate'), _U('vehicle'), _U('location'))
		--table.insert(elements, {label = spacer, value = nil})
	elseif ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
		--local spacer = ('| <span style="color:white;">%s</span> - <span style="color:white;">%s</span> |'):format(_U('plate'), _U('vehicle'))
		table.insert(elements, { label = ('<span style="color:white;">%s</span>'):format(_U('spacer1')), value = nil })
		--table.insert(elements, {label = spacer, value = nil})
	end

	ESX.TriggerServerCallback('ip-garasi:getOwnedCars', function(ownedCars)
		if #ownedCars == 0 then
			exports['mythic_notify']:DoHudText('error', 'Anda tidak memiliki Kendaraan apa pun!', 5000)
			-- ESX.ShowNotification(_U('garage_no_cars'))
		else
			for _, v in pairs(ownedCars) do
				if ConfigGarasi.UseVehicleNamesLua then
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName = GetLabelText(aheadVehName)
					local labelvehicle
					local labelvehicle2 = ('%s - %s  '):format(vehicleName, v.plate)
					local labelvehicle3 = ('%s -  %s  '):format(vehicleName, v.plate)
					if v.stored == true then
						labelvehicle = labelvehicle2 .. ('<span style="color:#2ecc71;"></span>')
					elseif v.stored == 2 then
						labelvehicle = labelvehicle2 .. ('<span style="color:#c0392b;"></span>')
					else
						labelvehicle = labelvehicle2 .. ('<span style="color:#e67e22;"></span>')
					end
					-- table.insert(elements, {label = labelvehicle, value = v})
					table.insert(isimenu,
						{
							title = vehicleName,
							description = '' .. vehicleName .. ' - ' .. v.plate .. ' - Di dalam garasi ',
							metadata = { ['Plat Kendaraan'] = v.plate,['Bensin'] = v.vehicle['fuelLevel'] .. '%',
								['Mesin'] = ESX.Math.Round(v.vehicle['engineHealth'] / 10.0) .. '%' },
							event = 'ip-garasi:keluarin',
							args = { vehicle = v.vehicle, plate = v.plate }
						})
				end

				lib.registerContext({
					id = 'garasi_' .. currentGarage,
					title = currentGarage,
					options = isimenu
					-- {
					-- 	id = 'other_example_menu',
					-- 	title = 'Other Context Menu',
					-- 	menu = 'example_menu',
					-- 	options = {
					-- 		['Nothing here'] = {}
					-- 	}
					-- }
				})
				lib.showContext('garasi_' .. currentGarage)
			end
		end

		-- ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'spawn_owned_car', {
		-- 	title = _U('garage_cars'),
		-- 	align = ConfigGarasi.MenuAlign,
		-- 	elements = elements
		-- }, function(data, menu)
		-- 	if data.current.value == nil then
		-- 	else
		-- 		if data.current.value.stored then
		-- 			menu.close()
		-- 			SpawnVehicle(data.current.value.vehicle, data.current.value.plate)
		-- 		else
		-- 			ESX.ShowNotification(_U('car_is_impounded'))
		-- 		end
		-- 	end
		-- end, function(data, menu)
		-- 	menu.close()
		-- end)
	end, currentGarage)
end

function StoreOwnedCarsMenu(currentGarage)
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) then
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(PlayerPedId(), true)
		local engineHealth = GetVehicleEngineHealth(current)

		ESX.TriggerServerCallback('ip-garasi:storeVehicle', function(valid)
			if valid then
				StoreVehicle(vehicle, vehicleProps)
			else
				TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
				while IsPedInVehicle(PlayerPedId(), vehicle, true) do
					Citizen.Wait(0)
				end

				Citizen.Wait(500)

				NetworkFadeOutEntity(vehicle, true, true)

				Citizen.Wait(100)

				ESX.Game.DeleteVehicle(vehicle)
				DeleteEntity(vehicle)
			end
		end, vehicleProps, currentGarage)
	else
		-- ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end

function ReturnOwnedCarsMenu(location)
	local isimenu = {}
	if WasInPound then
		ESX.ShowNotification(_U('must_wait', ConfigGarasi.PoundWait))
	else
		ESX.TriggerServerCallback('ip-garasi:getOutOwnedCars', function(ownedCars)
			local elements = {}

			if ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
				local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span>')
					:format(_U('plate')
						, _U('vehicle'))
				table.insert(elements, { label = spacer, value = nil })
			end

			for _, v in pairs(ownedCars) do
				if ConfigGarasi.UseVehicleNamesLua then
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName = GetLabelText(aheadVehName)
					local plate = v.vehicle.plate
					local health = (v.vehicle.bodyHealth / 100) or 1000.0
					local labelvehicle
					local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span>')
						:
						format(plate, vehicleName)

					labelvehicle = labelvehicle2 .. ('<span style="color:green;"></span> |')

					-- table.insert(elements, {label = labelvehicle, value = v})
					table.insert(isimenu,
						{
							title = vehicleName,
							description = '' ..
							vehicleName .. ' - ' .. v.vehicle.plate .. ' - Harga $' .. ESX.Math.GroupDigits(ConfigGarasi.CarPoundPrice),
							metadata = { ['Biaya Asuransi'] = '$' .. ESX.Math.GroupDigits(ConfigGarasi.CarPoundPrice),
								['Plat Kendaraan'] = v.vehicle.plate,['Mesin'] = ESX.Math.Round(health) .. '%' },
							event = 'ip-garasi:keluardariAsuransi',
							args = { vehicle = v.vehicle, plate = v.vehicle.plate, location = location }
						})
				end
			end
			lib.registerContext({
				id = 'asuransi',
				title = 'Asuransi',
				options = isimenu
			})
			lib.showContext('asuransi')
			-- ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'return_owned_car', {
			-- 	title = _U('pound_cars', ESX.Math.GroupDigits(ConfigGarasi.CarPoundPrice)),
			-- 	align = ConfigGarasi.MenuAlign,
			-- 	elements = elements
			-- }, function(data, menu)
			-- 	local doesVehicleExist = false

			-- 	for k,v in pairs (vehInstance) do
			-- 		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.current.value.plate) then
			-- 			if DoesEntityExist(v.vehicleentity) then
			-- 				doesVehicleExist = true
			-- 			else
			-- 				table.remove(vehInstance, k)
			-- 				doesVehicleExist = false
			-- 			end
			-- 		end
			-- 	end

			-- 	if not doesVehicleExist and not DoesAPlayerDrivesVehicle(data.current.value.plate) then
			-- 		ESX.TriggerServerCallback('ip-garasi:checkMoneyCars', function(hasEnoughMoney)
			-- 			if hasEnoughMoney then
			-- 				if data.current.value == nil then
			-- 				else
			-- 					SpawnVehicle(data.current.value, data.current.value.plate)
			-- 					TriggerServerEvent('ip-garasi:payCar')
			-- 					if ConfigGarasi.UsePoundTimer then
			-- 						WasInPound = true
			-- 					end
			-- 				end
			-- 			else
			-- 				exports['alex_nuipack']:Alert("Garage", "You dont have enough money!", 2500, 'error')
			-- 				-- ESX.ShowNotification(_U('not_enough_money'))
			-- 			end
			-- 		end)
			-- 	else
			-- 		exports['alex_nuipack']:Alert("Garage", "Cant take out vehicle!", 2500, 'error')
			-- 		-- ESX.ShowNotification(_U('cant_take_out'))
			-- 	end
			-- end, function(data, menu)
			-- 	menu.close()
			-- end)
		end)
	end
end

-- End of Car Code

function ReturnOwnedPedagangMenu(location)
	local isimenu = {}
	if WasinJPound then
		ESX.ShowNotification(_U('must_wait', ConfigGarasi.JPoundWait))
	else
		ESX.TriggerServerCallback('ip-garasi:getOutOwnedPedagangCars', function(ownedPedagangCars)
			local elements = {}

			if ConfigGarasi.ShowVehicleLocation == false and ConfigGarasi.ShowSpacers then
				local spacer = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> |')
					:format(_U('plate')
						, _U('vehicle'))
				table.insert(elements, { label = spacer, value = nil })
			end

			for _, v in pairs(ownedPedagangCars) do
				if ConfigGarasi.UseVehicleNamesLua then
					local hashVehicule = v.vehicle.model
					local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
					local vehicleName = GetLabelText(aheadVehName)
					local plate = v.plate
					local labelvehicle
					local labelvehicle2 = ('| <span style="color:red;">%s</span> - <span style="color:darkgoldenrod;">%s</span> - ')
						:
						format(plate, vehicleName)

					labelvehicle = labelvehicle2 .. ('<span style="color:green;">%s</span> |'):format(_U('return'))

					-- table.insert(elements, {label = labelvehicle, value = v})
					table.insert(isimenu,
						{
							title = vehicleName,
							description = 'Membayar asuransi kendaraan dan mengambil kendaraan ' .. vehicleName,
							metadata = { ['Biaya Asuransi'] = '$' .. ESX.Math.GroupDigits(ConfigGarasi.CarPoundPrice),
								['Plat Kendaraan'] = v.vehicle.plate },
							event = 'ip-garasi:keluardariAsuransiJob',
							args = { vehicle = v.vehicle, plate = v.vehicle.plate, location = location }
						})
				end
			end

			lib.registerContext({
				id = 'asuransi',
				title = 'Asuransi',
				options = isimenu
			})
			lib.showContext('asuransi')
		end)
	end
end

-- WasInPound & WasinJPound Code
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		if ConfigGarasi.UsePoundTimer then
			if WasInPound then
				Citizen.Wait(ConfigGarasi.PoundWait * 60000)
				WasInPound = false
			end
		end

		if ConfigGarasi.UseJPoundTimer then
			if WasinJPound then
				Citizen.Wait(ConfigGarasi.JPoundWait * 60000)
				WasinJPound = false
			end
		end

		if not WasInPound and not WasinJPound then
			Wait(1000)
		end
	end
end)

-- Repair Vehicles
function RepairVehicle(apprasial, vehicle, vehicleProps)
	ESX.UI.Menu.CloseAll()

	local elements = {
		{ label = _U('return_vehicle') .. " ($" .. apprasial .. ")", value = 'yes' },
		{ label = _U('see_mechanic'),                                value = 'no' }
	}

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delete_menu', {
		title = _U('damaged_vehicle'),
		align = ConfigGarasi.MenuAlign,
		elements = elements
	}, function(data, menu)
		menu.close()

		if data.current.value == 'yes' then
			TriggerServerEvent('ip-garasi:payhealth', apprasial)
			vehicleProps.bodyHealth = 1000.0 -- must be a decimal value!!!
			vehicleProps.engineHealth = 1000
			StoreVehicle(vehicle, vehicleProps)
		elseif data.current.value == 'no' then
			ESX.ShowNotification(_U('visit_mechanic'))
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- Store Vehicles
function StoreVehicle(vehicle, vehicleProps)
	for k, v in pairs(vehInstance) do
		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehicleProps.plate) then
			table.remove(vehInstance, k)
		end
	end

	TaskLeaveVehicle(PlayerPedId(), vehicle, 0)
	while IsPedInVehicle(PlayerPedId(), vehicle, true) do
		Citizen.Wait(0)
	end

	Citizen.Wait(250)

	NetworkFadeOutEntity(vehicle, true, true)

	Citizen.Wait(100)

	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('ip-garasi:setVehicleState', vehicleProps.plate, true)
	--ESX.ShowNotification(_U('vehicle_in_garage'))
	exports['mythic_notify']:DoHudText('success', 'Berhasil Menyimpan Kendaraan', 5000)
end

-- Spawn Vehicles
function SpawnVehicle(vehicle, plate)
	local c = GetEntityCoords(PlayerPedId())
	local h = GetEntityHeading(PlayerPedId())
	ESX.Game.SpawnVehicle(vehicle.model, c, h, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		local carplate = GetVehicleNumberPlateText(callback_vehicle)
		table.insert(vehInstance, { vehicleentity = callback_vehicle, plate = carplate })
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		SetEntityAsMissionEntity(callback_vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)
	end)
	exports['mythic_notify']:DoHudText('success', 'Berhasil Mengeluarkan Kendaraan', 5000)
	TriggerServerEvent('ip-garasi:setVehicleState', plate, false)
end

function SpawnVehicle2(vehicle, plate)
	ESX.Game.SpawnVehicle(vehicle.model, this_Garage.Spawner2, this_Garage.Heading2, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		local carplate = GetVehicleNumberPlateText(callback_vehicle)
		table.insert(vehInstance, { vehicleentity = callback_vehicle, plate = carplate })
		TaskWarpPedIntoVehicle(PlayerPedId(), callback_vehicle, -1)
		SetEntityAsMissionEntity(callback_vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(callback_vehicle, true)
	end)

	TriggerServerEvent('ip-garasi:setVehicleState', plate, false)
end

-- Check Vehicles
function DoesAPlayerDrivesVehicle(plate)
	local isVehicleTaken = false
	local players = ESX.Game.GetPlayers()
	for i = 1, #players, 1 do
		local target = GetPlayerPed(players[i])
		if target ~= PlayerPedId() then
			local plate1 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, true))
			local plate2 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, false))
			if plate == plate1 or plate == plate2 then
				isVehicleTaken = true
				break
			end
		end
	end
	return isVehicleTaken
end

-- Entered Marker
AddEventHandler('ip-garasi:hasEnteredMarker', function(zone)
	if zone == 'ambulance_garage_point' then
		CurrentAction = 'ambulance_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'ambulance_store_point' then
		CurrentAction = 'ambulance_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'ambulance_pound_point' then
		CurrentAction = 'ambulance_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'police_garage_point' then
		CurrentAction = 'police_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'police_store_point' then
		CurrentAction = 'police_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'police_pound_point' then
		CurrentAction = 'police_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'aircraft_garage_point' then
		CurrentAction = 'aircraft_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'aircraft_store_point' then
		CurrentAction = 'aircraft_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'aircraft_pound_point' then
		CurrentAction = 'aircraft_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'boat_garage_point' then
		CurrentAction = 'boat_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'boat_store_point' then
		CurrentAction = 'boat_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'boat_pound_point' then
		CurrentAction = 'boat_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'car_garage_point' then
		CurrentAction = 'car_garage_point'
		CurrentActionMsg = ('press_to_enter')
		CurrentActionData = { garage = garage }
		lib.showTextUI('[ALT] Garasi', {
			position = "left-center",
			icon = 'parking',
			style = {
				borderRadius = 0,
				backgroundColor = 'rgba(33, 35, 48, 0.9)',
				color = 'white'
			}
		})
	elseif zone == 'car_store_point' then
		CurrentAction = 'car_store_point'
		CurrentActionMsg = ('press_to_delete')
		CurrentActionData = { garage = garage }
		lib.showTextUI('[ALT] Garasi', {
			position = "left-center",
			icon = 'parking',
			style = {
				borderRadius = 0,
				backgroundColor = 'rgba(33, 35, 48, 0.9)',
				color = 'white'
			}
		})
	elseif zone == 'car_pound_point' then
		CurrentAction = 'car_pound_point'
		CurrentActionMsg = ('press_to_impound')
		CurrentActionData = {}
		lib.showTextUI('Asuransi', {
			position = "left-center",
			icon = 'fas fa-car-burst',
			style = {
				borderRadius = 0,
				backgroundColor = 'rgba(33, 35, 48, 0.9)',
				color = 'white'
			}
		})
	end
end)

-- Exited Marker
AddEventHandler('ip-garasi:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
	lib.hideTextUI()
end)

-- Resource Stop
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ESX.UI.Menu.CloseAll()
	end
end)

-- Create Blips
function CreateBlips()
	if ConfigGarasi.UseAircraftGarages and ConfigGarasi.UseAircraftBlips then
		for k, v in pairs(ConfigGarasi.AircraftGarages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, ConfigGarasi.GarageBlip.Sprite)
			SetBlipColour(blip, ConfigGarasi.GarageBlip.Color)
			SetBlipDisplay(blip, ConfigGarasi.GarageBlip.Display)
			SetBlipScale(blip, ConfigGarasi.GarageBlip.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end

		for k, v in pairs(ConfigGarasi.AircraftPounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, ConfigGarasi.PoundBlip.Sprite)
			SetBlipColour(blip, ConfigGarasi.PoundBlip.Color)
			SetBlipDisplay(blip, ConfigGarasi.PoundBlip.Display)
			SetBlipScale(blip, ConfigGarasi.PoundBlip.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_pound'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end

	if ConfigGarasi.UseBoatGarages and ConfigGarasi.UseBoatBlips then
		for k, v in pairs(ConfigGarasi.BoatGarages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, ConfigGarasi.GarageBlip.Sprite)
			SetBlipColour(blip, ConfigGarasi.GarageBlip.Color)
			SetBlipDisplay(blip, ConfigGarasi.GarageBlip.Display)
			SetBlipScale(blip, ConfigGarasi.GarageBlip.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end

		for k, v in pairs(ConfigGarasi.BoatPounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, ConfigGarasi.PoundBlip.Sprite)
			SetBlipColour(blip, ConfigGarasi.PoundBlip.Color)
			SetBlipDisplay(blip, ConfigGarasi.PoundBlip.Display)
			SetBlipScale(blip, ConfigGarasi.PoundBlip.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_pound'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end

	if ConfigGarasi.UseCarGarages and ConfigGarasi.UseCarBlips then
		for k, v in pairs(ConfigGarasi.CarGarages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, ConfigGarasi.GarageBlip.Sprite)
			SetBlipColour(blip, ConfigGarasi.GarageBlip.Color)
			SetBlipDisplay(blip, ConfigGarasi.GarageBlip.Display)
			SetBlipScale(blip, ConfigGarasi.GarageBlip.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end

		for k, v in pairs(ConfigGarasi.CarPounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, ConfigGarasi.PoundBlip.Sprite)
			SetBlipColour(blip, ConfigGarasi.PoundBlip.Color)
			SetBlipDisplay(blip, ConfigGarasi.PoundBlip.Display)
			SetBlipScale(blip, ConfigGarasi.PoundBlip.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_pound'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end
end

-- Handles Private Blips
function DeletePrivateBlips()
	if PrivateBlips[1] ~= nil then
		for i = 1, #PrivateBlips, 1 do
			RemoveBlip(PrivateBlips[i])
			PrivateBlips[i] = nil
		end
	end
end

function RefreshPrivateBlips()
	for zoneKey, zoneValues in pairs(ConfigGarasi.PrivateCarGarages) do
		if zoneValues.Private and has_value(userProperties, zoneValues.Private) then
			local blip = AddBlipForCoord(zoneValues.Marker)

			SetBlipSprite(blip, ConfigGarasi.PGarageBlip.Sprite)
			SetBlipColour(blip, ConfigGarasi.PGarageBlip.Color)
			SetBlipDisplay(blip, ConfigGarasi.PGarageBlip.Display)
			SetBlipScale(blip, ConfigGarasi.PGarageBlip.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(_U('blip_garage_private'))
			EndTextCommandSetBlipName(blip)
			table.insert(PrivateBlips, blip)
		end
	end
end

-- Cek didalam mobil / tidak

-- Handles Job Blips
function DeleteJobBlips()
	if JobBlips[1] ~= nil then
		for i = 1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function RefreshJobBlips()
	if ConfigGarasi.UsePolicePounds and ConfigGarasi.UsePoliceBlips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' or ESX.PlayerData.job.name == 'ambulance' or
			ESX.PlayerData.job.name == 'pedagang' then
			for k, v in pairs(ConfigGarasi.Pounds) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, ConfigGarasi.JPoundBlip.Sprite)
				SetBlipColour(blip, ConfigGarasi.JPoundBlip.Color)
				SetBlipDisplay(blip, ConfigGarasi.JPoundBlip.Display)
				SetBlipScale(blip, ConfigGarasi.JPoundBlip.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Job Impound")
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end
end

for k, v in pairs(ConfigGarasi.CarGarages) do
	-- print(json.encode(k, {indent = true}))
	exports['qtarget']:AddCircleZone('AmbilGarasiPublic_' .. k, vec3(v.Marker.x, v.Marker.y, v.Marker.z - 0.7), 10.2, {
		name = 'AmbilGarasiPublic_' .. k,
		debugPoly = false,
		useZ = true,
	}, {
		options = {
			{
				event = "ip-garasi:ambil",
				icon = "fas fa-warehouse",
				label = "Keluarkan Kendaraan",
				location = k,
				canInteract = function()
					if not IsPedInAnyVehicle(PlayerPedId()) then
						return true
					end
				end,
			},
			{
				event = "ip-garasi:simpan",
				icon = "fas fa-parking",
				label = "Masukkan Kendaraan",
				location = k,
				canInteract = function()
					if IsPedInAnyVehicle(PlayerPedId()) then
						return true
					end
				end,

			},
		},
		distance = 3.0,
	})
end
-- for k, v in pairs(ConfigGarasi.CarGarages) do
-- 	-- print(json.encode(k, {indent = true}))
-- 	exports['qtarget']:AddCircleZone('MasukinGarasiPublic_' .. k, vec3(v.Deleter.x, v.Deleter.y, v.Deleter.z - 0.7), 10.2,
-- 		{
-- 			name = 'MasukinGarasiPublic_' .. k,
-- 			debugPoly = false,
-- 			useZ = true,
-- 		}, {
-- 		options = {
-- 			{
-- 				event = "ip-garasi:simpan",
-- 				icon = "fas fa-parking",
-- 				label = "Masukkan Kendaraan",
-- 				location = k,
-- 				canInteract = function()
-- 					if IsPedInAnyVehicle(PlayerPedId()) then
-- 						return true
-- 					end
-- 				end,

-- 			},
-- 		},
-- 		distance = 3,
-- 	})
-- end



for k, v in pairs(ConfigGarasi.PrivateCarGarages) do
	-- print(json.encode(k, {indent = true}))
	exports['qtarget']:AddCircleZone('KeluarKendaraanPrivate_' .. k, vec3(v.Marker.x, v.Marker.y, v.Marker.z - 0.7), 10.2,
		{
			name = 'KeluarKendaraanPrivate_' .. k,
			debugPoly = false,
			useZ = true,
		}, {
		options = {
			{
				event = "ip-garasi:ambilgp",
				icon = "fas fa-warehouse",
				label = "Keluarkan Kendaraan",
				location = k,
				canInteract = function()
					if not IsPedInAnyVehicle(PlayerPedId()) then
						return true
					end
				end,
			},
			{
				event = "ip-garasi:simpangp",
				icon = "fas fa-parking",
				label = "Masukkan Kendaraan",
				location = k,
				canInteract = function()
					if IsPedInAnyVehicle(PlayerPedId()) then
						return true
					end
				end,

			},
		},
		distance = 3,
	})
end


for k, v in pairs(ConfigGarasi.CarPounds) do
	-- print(json.encode(k, {indent = true}))
	exports['qtarget']:AddCircleZone('Asuransi_' .. k, vec3(v.Marker.x, v.Marker.y, v.Marker.z - 0.2), 2.2, {
		name = 'Asuransi_' .. k,
		debugPoly = false,
		useZ = true,
	}, {
		options = {
			{
				event = "ip-garasi:asuransi",
				icon = "fas fa-warehouse",
				label = "Buka Asuransi",
				location = k,
				canInteract = function()
					if not IsPedInAnyVehicle(PlayerPedId()) then
						return true
					end
				end,
			},
		},
		distance = 3
	})
end

for k, v in pairs(ConfigGarasi.Pounds) do
	-- print(json.encode(k, {indent = true}))
	exports['qtarget']:AddCircleZone('AsuransiJob_' .. k, vec3(v.Marker.x, v.Marker.y, v.Marker.z - 0.2), 2.2, {
		name = 'AsuransiJob_' .. k,
		debugPoly = false,
		useZ = true,
	}, {
		options = {
			{
				event = "ip-garasi:asuransijob",
				icon = "fas fa-warehouse",
				label = "Buka Asuransi Job",
				job = { ["police"] = 0,["ambulance"] = 0,["pedagang"] = 0,["taxi"] = 0 },
				location = k,
				canInteract = function()
					if not IsPedInAnyVehicle(PlayerPedId()) then
						return true
					end
				end,
			},
		},
		distance = 3
	})
end


-- Enter / Exit marker events & Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords                      = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true
		local playerPed                         = GetPlayerPed( -1)


		if ConfigGarasi.UseCarGarages then
			for k, v in pairs(ConfigGarasi.CarGarages) do
				local distance = #(playerCoords - v.Marker)
				local distance2 = #(playerCoords - v.Deleter)

				if not IsPedInAnyVehicle(playerPed, false) and distance < ConfigGarasi.DrawDistance then
					letSleep = false

					-- if ConfigGarasi.PointMarker.Type ~= -1 then
					-- 	DrawMarker(ConfigGarasi.PointMarker.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigGarasi.PointMarker.x,
					-- 		ConfigGarasi.PointMarker.y, ConfigGarasi.PointMarker.z, ConfigGarasi.PointMarker.r, ConfigGarasi.PointMarker.g, ConfigGarasi.PointMarker.b, 100
					-- 		, false, true, 2, false, nil, nil, false)
					-- end

					if distance < ConfigGarasi.PointMarker.x then
						isInMarker, this_Garage, currentZone, garage = true, v, 'car_garage_point', k
					end
				end

				if IsPedInAnyVehicle(playerPed, false) and distance2 < ConfigGarasi.DrawDistance then
					letSleep = false

					-- if ConfigGarasi.DeleteMarker.Type ~= -1 then
					-- 	DrawMarker(ConfigGarasi.DeleteMarker.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigGarasi.DeleteMarker.x,
					-- 		ConfigGarasi.DeleteMarker.y, ConfigGarasi.DeleteMarker.z, ConfigGarasi.DeleteMarker.r, ConfigGarasi.DeleteMarker.g, ConfigGarasi.DeleteMarker.b
					-- 		, 100, false, true, 2, false, nil, nil, false)
					-- end

					if distance2 < ConfigGarasi.DeleteMarker.x then
						isInMarker, this_Garage, currentZone, garage = true, v, 'car_store_point', k
					end
				end
			end

			for k, v in pairs(ConfigGarasi.CarPounds) do
				local distance = #(playerCoords - v.Marker)

				if distance < ConfigGarasi.DrawDistance then
					letSleep = false

					-- if ConfigGarasi.PoundMarker.Type ~= -1 then
					-- 	DrawMarker(ConfigGarasi.PoundMarker.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ConfigGarasi.PoundMarker.x,
					-- 		ConfigGarasi.PoundMarker.y, ConfigGarasi.PoundMarker.z, ConfigGarasi.PoundMarker.r, ConfigGarasi.PoundMarker.g, ConfigGarasi.PoundMarker.b, 100
					-- 		, false, true, 2, false, nil, nil, false)
					-- end

					if distance < ConfigGarasi.PoundMarker.x then
						isInMarker, this_Garage, currentZone = true, v, 'car_pound_point'
					end
				end
			end
		end

		if ConfigGarasi.UsePrivateCarGarages then
			for k, v in pairs(ConfigGarasi.PrivateCarGarages) do
				if not v.Private or has_value(userProperties, v.Private) then
					local distance = #(playerCoords - v.Marker)
					local distance2 = #(playerCoords - v.Deleter)

					-- if distance < ConfigGarasi.DrawDistance then
					if not IsPedInAnyVehicle(playerPed, false) and distance < ConfigGarasi.DrawDistance then
						letSleep = false

						if ConfigGarasi.PointMarker.Type ~= -1 then
							DrawMarker(ConfigGarasi.PointMarker.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
								ConfigGarasi.PointMarker.x,
								ConfigGarasi.PointMarker.y, ConfigGarasi.PointMarker.z, ConfigGarasi.PointMarker.r,
								ConfigGarasi.PointMarker.g,
								ConfigGarasi.PointMarker.b, 100
								, false, true, 2, false, nil, nil, false)
						end

						if distance < ConfigGarasi.PointMarker.x then
							isInMarker, this_Garage, currentZone, garage = true, v, 'car_garage_point', k
						end
					end

					if IsPedInAnyVehicle(playerPed, false) and distance2 < ConfigGarasi.DrawDistance then
						letSleep = false

						if ConfigGarasi.DeleteMarker.Type ~= -1 then
							DrawMarker(ConfigGarasi.DeleteMarker.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
								ConfigGarasi.DeleteMarker.x,
								ConfigGarasi.DeleteMarker.y, ConfigGarasi.DeleteMarker.z, ConfigGarasi.DeleteMarker.r,
								ConfigGarasi.DeleteMarker.g, ConfigGarasi.DeleteMarker.b
								, 100, false, true, 2, false, nil, nil, false)
						end

						if distance2 < ConfigGarasi.DeleteMarker.x then
							isInMarker, this_Garage, currentZone, garage = true, v, 'car_store_point', k
						end
					end
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			LastZone = currentZone
			TriggerEvent('ip-garasi:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('ip-garasi:hasExitedMarker', LastZone)
			shown = false
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)


RegisterNetEvent('ip-garasi:ambil')
AddEventHandler('ip-garasi:ambil', function(data)
	if data.location ~= nil then
		ListOwnedCarsMenu(data.location)
	end
end)

RegisterNetEvent('ip-garasi:simpan')
AddEventHandler('ip-garasi:simpan', function(data)
	if data.location ~= nil then
		StoreOwnedCarsMenu(data.location)
	end
end)

RegisterNetEvent('ip-garasi:keluarin')
AddEventHandler('ip-garasi:keluarin', function(data)
	SpawnVehicle(data.vehicle, data.plate)
end)

RegisterNetEvent('ip-garasi:asuransi')
AddEventHandler('ip-garasi:asuransi', function(data)
	ReturnOwnedCarsMenu(data.location)
end)


RegisterNetEvent('ip-garasi:keluardariAsuransi')
AddEventHandler('ip-garasi:keluardariAsuransi', function(data)
	for k, v in pairs(vehInstance) do
		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.plate) then
			if DoesEntityExist(v.vehicleentity) then
				doesVehicleExist = true
			else
				table.remove(vehInstance, k)
				doesVehicleExist = false
			end
		end
	end

	if not doesVehicleExist and not DoesAPlayerDrivesVehicle(data.plate) then
		ESX.TriggerServerCallback('ip-garasi:checkMoneyCars', function(hasEnoughMoney)
			if hasEnoughMoney then
				if data.vehicle == nil then
				else
					for k, v in pairs(ConfigGarasi.CarPounds) do
						if k == data.location then
							SetEntityCoords(PlayerPedId(), v.Spawner)
							SetEntityHeading(PlayerPedId(), v.Heading)
						end
					end
					SpawnVehicle(data.vehicle, data.plate)
					TriggerServerEvent('ip-garasi:payCar')
					if ConfigGarasi.UsePoundTimer then
						WasInPound = true
					end
				end
			else
				exports['mythic_notify']:DoHudText('error', 'Anda tidak memiliki uang', 2500)
				-- ESX.ShowNotification(_U('not_enough_money'))
			end
		end)
	else
		exports['mythic_notify']:DoHudText('error', 'Anda sudah mengambil kendaraan', 2500)
		-- ESX.ShowNotification(_U('cant_take_out'))
	end
end)

RegisterNetEvent('ip-garasi:simpangp')
AddEventHandler('ip-garasi:simpangp', function(data)
	if data.location ~= nil then
		StoreOwnedCarsMenu(data.location)
	end
end)

RegisterNetEvent('ip-garasi:ambilgp')
AddEventHandler('ip-garasi:ambilgp', function(data)
	if data.location ~= nil then
		ListOwnedCarsMenu(data.location)
	end
end)

RegisterNetEvent('ip-garasi:asuransijob')
AddEventHandler('ip-garasi:asuransijob', function(data)
	if ESX.GetPlayerData().job.name == "ambulance" then
		ReturnOwnedAmbulanceMenu(data.location)
	elseif ESX.GetPlayerData().job.name == "pedagang" then
		ReturnOwnedPedagangMenu(data.location)
	elseif ESX.GetPlayerData().job.name == "police" then
		ReturnOwnedPoliceMenu(data.location)
	end
end)
RegisterNetEvent('ip-garasi:asuransipedagang')
AddEventHandler('ip-garasi:asuransipedagang', function(data)
	ReturnOwnedPedagangMenu(data.location)
end)

RegisterNetEvent('ip-garasi:keluardariAsuransiJob')
AddEventHandler('ip-garasi:keluardariAsuransiJob', function(data)
	for k, v in pairs(vehInstance) do
		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(data.plate) then
			if DoesEntityExist(v.vehicleentity) then
				doesVehicleExist = true
			else
				table.remove(vehInstance, k)
				doesVehicleExist = false
			end
		end
	end

	if not doesVehicleExist and not DoesAPlayerDrivesVehicle(data.plate) then
		ESX.TriggerServerCallback('ip-garasi:checkMoneyAmbulance', function(hasEnoughMoney)
			if hasEnoughMoney then
				if data.vehicle == nil then
				else
					for k, v in pairs(ConfigGarasi.Pounds) do
						if k == data.location then
							SetEntityCoords(PlayerPedId(), v.Spawner)
							SetEntityHeading(PlayerPedId(), v.Heading)
						end
					end
					SpawnVehicle(data.vehicle, data.plate)
					TriggerServerEvent('ip-garasi:payCar')
					if ConfigGarasi.UsePoundTimer then
						WasInPound = true
					end
				end
			else
				exports['mythic_notify']:DoHudText('error', 'Anda tidak memiliki uang', 2500)
				-- ESX.ShowNotification(_U('not_enough_money'))
			end
		end)
	else
		exports['mythic_notify']:DoHudText('error', 'Anda sudah mengambil kendaraan', 2500)
		-- ESX.ShowNotification(_U('cant_take_out'))
	end
end)
