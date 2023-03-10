local ELECTRIC_VEHICLES = {
    [GetHashKey('AIRTUG')] = true,
    [GetHashKey('CYCLONE')] = true,
    [GetHashKey('CADDY')] = true,
    [GetHashKey('CADDY2')] = true,
    [GetHashKey('CADDY3')] = true,
    [GetHashKey('DILETTANTE')] = true,
    [GetHashKey('IMORGON')] = true,
    [GetHashKey('KHAMEL')] = true,
    [GetHashKey('NEON')] = true,
    [GetHashKey('RAIDEN')] = true,
    [GetHashKey('SURGE')] = true,
    [GetHashKey('VOLTIC')] = true,
    [GetHashKey('VOLTIC2')] = true,
    [GetHashKey('TEZERACT')] = true,
    -- police
    [GetHashKey('POLICE')] = true,
    [GetHashKey('BARACUDA')] = true,
    [GetHashKey('MAZDA6')] = true,
    [GetHashKey('PBUS')] = true,
    [GetHashKey('VXR')] = true,
    [GetHashKey('FIRETRUK')] = true,
    [GetHashKey('POLICEINSURGENT')] = true,
    [GetHashKey('RIOT')] = true,
    [GetHashKey('SHERIFF2')] = true,
    [GetHashKey('PRANGER')] = true,
    [GetHashKey('LGUARD')] = true,
    [GetHashKey('PORTPD1')] = true,
    -- ambulance
    [GetHashKey('AMBULANCE')] = true,
    -- mobil dealer
    [GetHashKey('GUARDIAN')] = true,
    [GetHashKey('NEON')] = true,
    [GetHashKey('BLISTA')] = true
}

-- TODO: Replace with `FLAG_IS_ELECTRIC` from vehicles.meta:
-- https://gtamods.com/wiki/Vehicles.meta
function IsVehicleElectric(vehicle)
  local model = GetEntityModel(vehicle)
  return ELECTRIC_VEHICLES[model] or false
end
