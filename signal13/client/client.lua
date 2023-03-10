local PlayerData = {}
local GUI        = {}
local holstered  = true
ESX              = nil
GUI.Time         = 0

function getJob()
	if PlayerData.job ~= nil then
		return PlayerData.job.name
	end
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

function sendNotification(message, messageType, messageTimeout)
	TriggerEvent("pNotify:SendNotification", {
		text = message,
		type = messageType,
		queue = "sig13",
		timeout = messageTimeout,
		layout = "bottomCenter"
	})
end

RegisterNetEvent('s13')
AddEventHandler('s13', function()
	if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' then -- checks the job
		local playerPed            = PlayerPedId()
		PedPosition                = GetEntityCoords(playerPed)
		local x, y, z              = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
		local plyPos               = GetEntityCoords(GetPlayerPed(-1), true)
		local streetName, crossing = Citizen.InvokeNative(0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z,
			Citizen.PointerValueInt(), Citizen.PointerValueInt())
		local streetName, crossing = GetStreetNameAtCoord(x, y, z)
		streetName                 = GetStreetNameFromHashKey(streetName)
		crossing                   = GetStreetNameFromHashKey(crossing)
		sendNotification(('SIGNAL 13 Activate'), 'error', 10000) -- send a notification using Pnotify please have Pnotify in your resources and running

		local coords = GetEntityCoords(GetPlayerPed(-1))
		-- local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }
		-- local playerPed    = PlayerPedId
		-- local myPos        = GetEntityCoords(playerPed)
		-- local GPS          = 'GPS: ' .. myPos.x .. ', ' .. myPos.y

		local myPos = GetEntityCoords(PlayerPedId())
		local GPS = 'GPS: ' .. myPos.x .. ', ' .. myPos.y
		TriggerServerEvent('gksphone:jbmessage', 'Signal 13', 0, 'Sinyal Baru Polisi', '', GPS, 'police', 'ambulance')
		-- print("Fun SendDistressSignal berjalan")

		TriggerServerEvent('esx_phone:send', "police", "SIGNAL 13 ACTIVATED! " .. streetName, true, {
			x = coords.x,
			y = coords.y,
			z = coords.z
		})
		TriggerServerEvent('esx_phone:send', "ambulance", "SIGNAL 13 ACTIVATED! " .. streetName, true, {
			x = coords.x,
			y = coords.y,
			z = coords.z
		})
	end
end)
