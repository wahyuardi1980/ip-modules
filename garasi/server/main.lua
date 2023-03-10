ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Make sure all Vehicles are Stored on restart
MySQL.ready(function()
	if ConfigGarasi.ParkVehicles then
		ParkVehicles()
	else
		print('ip-garasi: Parking Vehicles On Restart Is Currently Set To False.')
	end
end)

function ParkVehicles()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
		['@stored'] = true
	}, function(rowsChanged)
		if rowsChanged > 0 then
			print(('ip-garasi: %s Vehicle(s) Have Been Stored!'):format(rowsChanged))
		end
	end)
end

ESX.RegisterServerCallback('', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate,
	}, function(result)
		for _, v in pairs(result) do
			local vehicle = json.decode(v.vehicle)
			table.insert(result, { trunk = v.trunk })
		end
		cb(result)
	end)
end)

ESX.RegisterServerCallback('garage:getTrunkInventory', function(source, cb, plate)
	if plate == nil then
		return
	end
	MySQL.Async.fetchAll('SELECT trunk FROM owned_vehicles WHERE plate = @plate LIMIT 1', {
		['@plate'] = plate
	}, function(result)
		cb(result)
	end)
end)

-- Add Command for Getting Properties

-- Add Print Command for Getting Properties
RegisterServerEvent('ip-garasi:printGetProperties')
AddEventHandler('ip-garasi:printGetProperties', function()
	print('Getting Properties')
end)

-- Get Owned Properties
ESX.RegisterServerCallback('ip-garasi:getOwnedProperties', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(data)
		for _, v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)

-- Start of Ambulance Code
ESX.RegisterServerCallback('ip-garasi:getOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if ConfigGarasi.ShowVehLoc then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
			{ -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'ambulance'
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAmbulanceCars, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedAmbulanceCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
			, { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'ambulance',
				['@stored'] = true
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAmbulanceCars, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedAmbulanceCars)
		end)
	end
end)

ESX.RegisterServerCallback('ip-garasi:getOwnedAmbulanceAircrafts', function(source, cb)
	local ownedAmbulanceAircrafts = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if ConfigGarasi.AdvVehShop then
		if ConfigGarasi.ShowVehLoc then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
				{ -- job = NULL
					['@owner'] = xPlayer.identifier,
					['@Type'] = 'aircraft',
					['@job'] = 'ambulance'
				}, function(data)
				for _, v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceAircrafts, { vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'aircraft' })
				end
				cb(ownedAmbulanceAircrafts)
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
				, { -- job = NULL
					['@owner'] = xPlayer.identifier,
					['@Type'] = 'aircraft',
					['@job'] = 'ambulance',
					['@stored'] = true
				}, function(data)
				for _, v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceAircrafts, { vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'aircraft' })
				end
				cb(ownedAmbulanceAircrafts)
			end)
		end
	else
		if ConfigGarasi.ShowVehLoc then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
				{ -- job = NULL
					['@owner'] = xPlayer.identifier,
					['@Type'] = 'helicopter',
					['@job'] = 'ambulance'
				}, function(data)
				for _, v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceAircrafts,
						{ vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'helicopter' })
				end
				cb(ownedAmbulanceAircrafts)
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
				, { -- job = NULL
					['@owner'] = xPlayer.identifier,
					['@Type'] = 'helicopter',
					['@job'] = 'ambulance',
					['@stored'] = true
				}, function(data)
				for _, v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceAircrafts,
						{ vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'helicopter' })
				end
				cb(ownedAmbulanceAircrafts)
			end)
		end
	end
end)

ESX.RegisterServerCallback('ip-garasi:getOutOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = xPlayer.identifier,
		['@job'] = 'ambulance',
		['@stored'] = false
	}, function(data)
		for _, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAmbulanceCars, vehicle)
		end
		cb(ownedAmbulanceCars)
	end)
end)

ESX.RegisterServerCallback('ip-garasi:checkMoneyAmbulance', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= ConfigGarasi.Ambulance.PoundP then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('ip-garasi:payAmbulance')
AddEventHandler('ip-garasi:payAmbulance', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(ConfigGarasi.Ambulance.PoundP)
	TriggerClientEvent('alex_nuipack:client:Alert', source,
		{ type = 'inform', text = _U('you_paid') .. ConfigGarasi.Ambulance.PoundP })

	if ConfigGarasi.GiveSocMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(ConfigGarasi.Ambulance.PoundP)
		end)
	end
end)
-- End of Ambulance Code

-- Start of Police Code
ESX.RegisterServerCallback('ip-garasi:getOwnedPoliceCars', function(source, cb)
	local ownedPoliceCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if ConfigGarasi.ShowVehLoc then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
			{ -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'police'
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedPoliceCars, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedPoliceCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
			, { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'police',
				['@stored'] = true
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedPoliceCars, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedPoliceCars)
		end)
	end
end)

ESX.RegisterServerCallback('ip-garasi:getOwnedPoliceAircrafts', function(source, cb)
	local ownedPoliceAircrafts = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if ConfigGarasi.AdvVehShop then
		if ConfigGarasi.ShowVehLoc then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
				{ -- job = NULL
					['@owner'] = xPlayer.identifier,
					['@Type'] = 'aircraft',
					['@job'] = 'police'
				}, function(data)
				for _, v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceAircrafts, { vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'aircraft' })
				end
				cb(ownedPoliceAircrafts)
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
				, { -- job = NULL
					['@owner'] = xPlayer.identifier,
					['@Type'] = 'aircraft',
					['@job'] = 'police',
					['@stored'] = true
				}, function(data)
				for _, v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceAircrafts, { vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'aircraft' })
				end
				cb(ownedPoliceAircrafts)
			end)
		end
	else
		if ConfigGarasi.ShowVehLoc then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
				{ -- job = NULL
					['@owner'] = xPlayer.identifier,
					['@Type'] = 'helicopter',
					['@job'] = 'police'
				}, function(data)
				for _, v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceAircrafts, { vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'helicopter' })
				end
				cb(ownedPoliceAircrafts)
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
				, { -- job = NULL
					['@owner'] = xPlayer.identifier,
					['@Type'] = 'helicopter',
					['@job'] = 'police',
					['@stored'] = true
				}, function(data)
				for _, v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceAircrafts, { vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'helicopter' })
				end
				cb(ownedPoliceAircrafts)
			end)
		end
	end
end)

ESX.RegisterServerCallback('ip-garasi:getOutOwnedPoliceCars', function(source, cb)
	local ownedPoliceCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = xPlayer.identifier,
		['@job'] = 'police',
		['@stored'] = false
	}, function(data)
		for _, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedPoliceCars, vehicle)
		end
		cb(ownedPoliceCars)
	end)
end)

ESX.RegisterServerCallback('ip-garasi:checkMoneyPolice', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= ConfigGarasi.Police.PoundP then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('ip-garasi:payPolice')
AddEventHandler('ip-garasi:payPolice', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(ConfigGarasi.Police.PoundP)
	TriggerClientEvent('alex_nuipack:client:Alert', source,
		{ type = 'inform', text = _U('you_paid') .. ConfigGarasi.Police.PoundP })

	if ConfigGarasi.GiveSocMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(ConfigGarasi.Police.PoundP)
		end)
	end
end)
-- End of Police Code

-- Start of Mechanic Code
ESX.RegisterServerCallback('ip-garasi:getOwnedMechanicCars', function(source, cb)
	local ownedMechanicCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if ConfigGarasi.ShowVehLoc then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
			{ -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'mechanic'
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedMechanicCars, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedMechanicCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
			, { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'mechanic',
				['@stored'] = true
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedMechanicCars, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedMechanicCars)
		end)
	end
end)

ESX.RegisterServerCallback('ip-garasi:getOutOwnedMechanicCars', function(source, cb)
	local ownedMechanicCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = xPlayer.identifier,
		['@job'] = 'mechanic',
		['@stored'] = false
	}, function(data)
		for _, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedMechanicCars, vehicle)
		end
		cb(ownedMechanicCars)
	end)
end)

ESX.RegisterServerCallback('ip-garasi:checkMoneyMechanic', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= ConfigGarasi.Mechanic.PoundP then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('ip-garasi:payMechanic')
AddEventHandler('ip-garasi:payMechanic', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(ConfigGarasi.Mechanic.PoundP)
	TriggerClientEvent('alex_nuipack:client:Alert', source,
		{ type = 'inform', text = _U('you_paid') .. ConfigGarasi.Mechanic.PoundP })

	if ConfigGarasi.GiveSocMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(ConfigGarasi.Mechanic.PoundP)
		end)
	end
end)
-- End of Mechanic Code

-- Start of Aircraft Code
ESX.RegisterServerCallback('ip-garasi:getOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if ConfigGarasi.ShowVehLoc then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
			{ -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'civ'
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedAircrafts)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
			, { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'civ',
				['@stored'] = true
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedAircrafts)
		end)
	end
end)

ESX.RegisterServerCallback('ip-garasi:getOutOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
		, { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'aircraft',
			['@job'] = 'civ',
			['@stored'] = false
		}, function(data)
		for _, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAircrafts, vehicle)
		end
		cb(ownedAircrafts)
	end)
end)

ESX.RegisterServerCallback('ip-garasi:checkMoneyAircrafts', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= ConfigGarasi.Aircrafts.PoundP then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('ip-garasi:payAircraft')
AddEventHandler('ip-garasi:payAircraft', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(ConfigGarasi.Aircrafts.PoundP)

	if ConfigGarasi.GiveSocMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(ConfigGarasi.Aircrafts.PoundP)
		end)
	end
end)
-- End of Aircraft Code

-- Start of Boat Code
ESX.RegisterServerCallback('ip-garasi:getOwnedBoats', function(source, cb)
	local ownedBoats = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if ConfigGarasi.ShowVehLoc then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job',
			{ -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'boat',
				['@job'] = 'civ'
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedBoats)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
			, { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'boat',
				['@job'] = 'civ',
				['@stored'] = true
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, { vehicle = vehicle, stored = v.stored, plate = v.plate })
			end
			cb(ownedBoats)
		end)
	end
end)

ESX.RegisterServerCallback('ip-garasi:getOutOwnedBoats', function(source, cb)
	local ownedBoats = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored'
		, { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'boat',
			['@job'] = 'civ',
			['@stored'] = false
		}, function(data)
		for _, v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedBoats, vehicle)
		end
		cb(ownedBoats)
	end)
end)

ESX.RegisterServerCallback('ip-garasi:checkMoneyBoats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= ConfigGarasi.Boats.PoundP then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('ip-garasi:payBoat')
AddEventHandler('ip-garasi:payBoat', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(ConfigGarasi.Boats.PoundP)
	TriggerClientEvent('alex_nuipack:client:Alert', source,
		{ type = 'inform', text = _U('you_paid') .. ConfigGarasi.Boats.PoundP })

	if ConfigGarasi.GiveSocMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(ConfigGarasi.Boats.PoundP)
		end)
	end
end)
-- End of Boat Code

-- Start of Car Code
ESX.RegisterServerCallback('ip-garasi:getOwnedCars', function(source, cb, garage)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if ConfigGarasi.ShowVehLoc then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND garage = @garage',
			{ -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				-- ['@job'] = 'civ',
				['@garage'] = garage,
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, { vehicle = vehicle, stored = v.stored, plate = v.plate, vehiclename = v.vehiclename })
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND `stored` = @stored AND garage = @garage'
			, { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				-- ['@job'] = 'civ',
				['@stored'] = true,
				['@garage'] = garage,
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars,
					{ vehicle = vehicle, stored = v.stored, plate = v.plate, garage = v.garage, vehiclename = v.vehiclename })
			end
			cb(ownedCars)
		end)
	end
end)

ESX.RegisterServerCallback('ip-garasi:getOutOwnedCars', function(source, cb, location)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if location == 'Paleto_Bay' then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND `stored` = @stored AND owned_vehicles.plate NOT IN (SELECT plate FROM h_impounded_vehicles)'
			, { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@stored'] = false
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars,
					{ vehicle = vehicle, stored = v.stored, plate = v.plate, garage = v.garage, vehiclename = v.vehiclename })
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE `owner` = @owner AND `type` = @type AND `job` = @job AND `stored` = @stored AND owned_vehicles.plate NOT IN (SELECT plate FROM h_impounded_vehicles)'
			, { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@type'] = 'car',
				['@job'] = 'civ',
				['@stored'] = false
			}, function(data)
			for _, v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars,
					{ vehicle = vehicle, stored = v.stored, plate = v.plate, garage = v.garage, vehiclename = v.vehiclename })
			end
			cb(ownedCars)
		end)
	end
end)

ESX.RegisterServerCallback('checkMoney', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 10000 then
		cb(true)
		xPlayer.removeMoney(10000)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('ChangeNamePrice', function(source, cb)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getMoney() >= 25000 then
		cb(true)
		xPlayer.removeMoney(25000)
	else
		cb(false)
	end

end)

RegisterServerEvent('garage:renamevehicle')
AddEventHandler('garage:renamevehicle', function(vehicleplate, name)
	MySQL.Async.execute("UPDATE owned_vehicles SET vehiclename =@vehiclename WHERE plate=@plate",
		{ ['@vehiclename'] = name, ['@plate'] = vehicleplate })
end)

ESX.RegisterServerCallback('ip-garasi:checkMoneyCars', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= ConfigGarasi.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('ip-garasi:payCar')
AddEventHandler('ip-garasi:payCar', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(ConfigGarasi.CarPoundPrice)
	TriggerClientEvent('alex_nuipack:client:Alert', source,
		{ type = 'inform', text = _U('you_paid') .. ESX.Math.GroupDigits(ConfigGarasi.CarPoundPrice) })

	if ConfigGarasi.GiveSocMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(ConfigGarasi.CarPoundPrice)
		end)
	end
end)
-- End of Car Code

-- Store Vehicles
ESX.RegisterServerCallback('ip-garasi:storeVehicle', function(source, cb, vehicleProps, garage)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function(result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle, garage = @garage WHERE owner = @owner AND plate = @plate'
					, {
						['@owner'] = xPlayer.identifier,
						['@vehicle'] = json.encode(vehicleProps),
						['@plate'] = vehicleProps.plate,
						['@garage'] = garage
					}, function(rowsChanged)
					if rowsChanged == 0 then
						-- print(('ip-garasi: %s Attempted To Store An Vehicle They Don\'t Own!'):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				if ConfigGarasi.KickCheaters then
					if ConfigGarasi.CustomKickMsg then
						print(('ip-garasi: %s Attempted To Cheat! Tried Storing: %s | Original Vehicle: %s '):format(xPlayer.identifier
							, vehiclemodel, originalvehprops.model))

						DropPlayer(source, _U('custom_kick'))
						cb(false)
					else
						print(('ip-garasi: %s Attempted To Cheat! Tried Storing: %s | Original Vehicle: %s '):format(xPlayer.identifier
							, vehiclemodel, originalvehprops.model))

						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('ip-garasi: %s attempted to Cheat! Tried Storing: %s | Original Vehicle: %s '):format(xPlayer.identifier
						, vehiclemodel, originalvehprops.model))
					cb(false)
				end
			end
		else
			-- print(('ip-garasi: %s Attempted To Store An Vehicle They Don\'t Own!'):format(xPlayer.identifier))
			cb(false)
		end
	end)
end)

-- Pay to Return Broken Vehicles
RegisterServerEvent('ip-garasi:payhealth')
AddEventHandler('ip-garasi:payhealth', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(price)
	TriggerClientEvent('alex_nuipack:client:Alert', source, { type = 'inform', text = _U('you_paid') .. price })

	if ConfigGarasi.GiveSocMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(price)
		end)
	end
end)

-- Modify State of Vehicles
RegisterServerEvent('ip-garasi:setVehicleState')
AddEventHandler('ip-garasi:setVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			-- print(('ip-garasi: %s Exploited The Garage!'):format(xPlayer.identifier))
		end
	end)
end)


RegisterServerEvent('vehiclesStored')
AddEventHandler('vehiclesStored', function(plate, vehprop)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
		['@vehicle'] = json.encode(vehprop),
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
