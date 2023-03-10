ConfigGarasi                          = {}
ConfigGarasi.Locale                   = 'en'

ConfigGarasi.MenuAlign                = 'bottom-right'
ConfigGarasi.DrawDistance             = 5

ConfigGarasi.UseCommand               = false -- Will allow players to do /getproperties instead of having to log out & back in to see Private Garages.
ConfigGarasi.ParkVehicles             = false -- true = Automatically Park all Vehicles in Garage on Server/Script Restart | false = Opposite of true but players will have to go to Pound to get their Vehicle Back.
ConfigGarasi.KickPossibleCheaters     = true -- true = Kick Player that tries to Cheat Garage by changing Vehicle Hash/Plate.
ConfigGarasi.UseCustomKickMessage     = false -- true = Sets Custom Kick Message for those that try to Cheat. Note: "ConfigGarasi.KickPossibleCheaters" must be true.

ConfigGarasi.GiveSocietyMoney         = false -- true = Gives money to society_mechanic. Note: REQUIRES esx_mechanicjob.
ConfigGarasi.ShowVehicleLocation      = true -- true = Will show Location of Vehicles in the Garage Menus.
ConfigGarasi.ShowSpacers              = true -- true = Shows Spacers in Menus.
ConfigGarasi.UseVehicleNamesLua       = true -- Must setup a vehicle_names.lua for Custom Addon Vehicles.

ConfigGarasi.PointMarker              = { Type = 2, r = 0, g = 0, b = 100, x = 1.0, y = 1.0, z = 1.0 } -- Green Color / Standard Size Circle.
ConfigGarasi.DeleteMarker             = { Type = 2, r = 255, g = 0, b = 0, x = 1.0, y = 1.0, z = 1.0 } -- Red Color / Big Size Circle.
ConfigGarasi.PoundMarker              = { Type = 27, r = 0, g = 0, b = 100, x = 2.0, y = 2.0, z = 2.0 } -- Blue Color / Standard Size Circle.
ConfigGarasi.JPoundMarker             = { Type = 27, r = 255, g = 0, b = 0, x = 2.0, y = 2.0, z = 2.0 } -- Red Color / Standard Size Circle.

ConfigGarasi.GarageBlip               = { Sprite = 290, Color = 38, Display = 2, Scale = 0.7 } -- Public Garage Blip.
ConfigGarasi.PGarageBlip              = { Sprite = 290, Color = 53, Display = 2, Scale = 0.7 } -- Private Garage Blip.
ConfigGarasi.PoundBlip                = { Sprite = 67, Color = 64, Display = 2, Scale = 0.7 } -- Pound Blip.
ConfigGarasi.JGarageBlip              = { Sprite = 290, Color = 49, Display = 2, Scale = 0.7 } -- Job Garage Blip.
ConfigGarasi.JPoundBlip               = { Sprite = 67, Color = 49, Display = 2, Scale = 0.7 } -- Job Pound Blip.

ConfigGarasi.UsePoundTimer            = false -- true = Uses Pound Timer
ConfigGarasi.PoundWait                = 5 -- How many Minutes someone must wait before Opening Pound Menu Again.

ConfigGarasi.UseJPoundTimer           = false -- true = Uses Job Pound Timer
ConfigGarasi.JPoundWait               = 2.5 -- How many Minutes someone must wait before Opening Job Pound Menu Again.

ConfigGarasi.UseDamageMult            = true -- true = Costs more to Store a Broken/Damaged Vehicle.
ConfigGarasi.DamageMult               = 5 -- Higher Number = Higher Repair Price.

ConfigGarasi.UsingAdvancedVehicleShop = false -- Set to true if using esx_advancedvehicleshop

ConfigGarasi.UseAmbulanceGarages      = false -- true = Allows use of Ambulance Garages.
ConfigGarasi.UseAmbulancePounds       = true -- true = Allows use of Ambulance Pounds.
ConfigGarasi.UseAmbulanceBlips        = false -- true = Use Ambulance Blips.
ConfigGarasi.AmbulancePoundPrice      = 5000 -- How much it Costs to get Vehicle from Ambulance Pound.


ConfigGarasi.UsePedagangPounds = true -- true = Allows use of Ambulance Pounds.
ConfigGarasi.UsePedagangBlips = true -- true = Use Ambulance Blips.
ConfigGarasi.PedagangPoundPrice = 5000 -- How much it Costs to get Vehicle from Ambulance Pound.

ConfigGarasi.UsePoliceGarages = true -- true = Allows use of Police Garages.
ConfigGarasi.UsePolicePounds = false -- true = Allows use of Police Pounds.
ConfigGarasi.UsePoliceBlips = true -- true = Use Police Blips.
ConfigGarasi.PolicePoundPrice = 5000 -- How much it Costs to get Vehicle from Police Pound.

ConfigGarasi.UseAircraftGarages = false -- true = Allows use of Aircraft Garages.
ConfigGarasi.UseAircraftBlips = false -- true = Use Aircraft Blips.
ConfigGarasi.AircraftPoundPrice = 2500 -- How much it Costs to get Vehicle from Aircraft Pound.

ConfigGarasi.UseBoatGarages = false -- true = Allows use of Boat Garages.
ConfigGarasi.UseBoatBlips = false -- true = Use Boat Blips.
ConfigGarasi.BoatPoundPrice = 500 -- How much it Costs to get Vehicle from Boat Pound.

ConfigGarasi.UseCarGarages = true -- true = Allows use of Car Garages.
ConfigGarasi.UseCarBlips = false -- true = Use Car Blips.
ConfigGarasi.CarPoundPrice = 10000 -- How much it Costs to get Vehicle from Car Pound.

ConfigGarasi.UsePrivateCarGarages = true -- true = Allows use of Private Car Garages.

-- Marker = Enter Location | Spawner = Spawn Location | Spawner2 = Job Aircraft Spawn Location | Deleter = Delete Location
-- Deleter2 = Job Aircraft Delete Location | Heading = Spawn Heading | Heading2 = Job Aircraft Spawn Heading

-- Start of Ambulance
ConfigGarasi.AmbulanceGarages = {
	Los_Santos = {
		Marker = vector3(302.95, -1453.5, 28.97),
		Spawner = vector3(300.33, -1431.91, 29.8),
		Spawner2 = vector3(313.36, -1465.17, 46.51),
		Deleter = vector3(300.33, -1431.91, 28.8),
		Deleter2 = vector3(313.36, -1465.17, 45.51),
		Heading = 226.71,
		Heading2 = 318.34
	}
}

ConfigGarasi.Pounds = {
	Sandy_Shores = {
		Marker = vector3(252.43141174316, 2596.1325683594, 43.882186889648),
		Spawner = vector3(239.9415, 2601.7378, 45.1119),
		Heading = 16.6328
	},
	Paleto_Bay = {
		Marker = vector3( -358.6889, 6061.7173, 31.5001),
		Spawner = vector3( -359.0310, 6072.8081, 31.4978),
		Heading = 136.9588
	}
}

ConfigGarasi.PedagangPounds = {
	Sandy_Shores = {
		Marker = vector3(252.43141174316, 2596.1325683594, 43.882186889648),
		Spawner = vector3(239.2, 2602.16, 45.14),
		Heading = 99.0
	},
	Paleto_Bay = {
		Marker = vector3( -379.34426879883, 6062.0278320313, 30.50012588501),
		Spawner = vector3( -386.87811279297, 6062.501953125, 31.500106811523),
		Heading = 129.39
	}
}
-- End of Ambulance

-- Start of Police
ConfigGarasi.PoliceGarages = {
	Los_Santos = {
		Marker = vector3(455.42, -1020.1, 29.32),
		Spawner = vector3(434.28, -1015.8, 28.83),
		Spawner2 = vector3(449.21, -981.35, 43.69),
		Deleter = vector3(462.95, -1014.56, 27.07),
		Deleter2 = vector3(449.21, -981.35, 42.69),
		Heading = 90.46,
		Heading2 = 184.53
	}
}

ConfigGarasi.PolicePounds = {
	Los_Santos = {
		Marker = vector3(252.43141174316, 2596.1325683594, 43.882186889648),
		Spawner = vector3(258.64971923828, 2589.7944335938, 44.954086303711),
		Heading = 15.86
	},
	Paleto_Bay = {
		Marker = vector3( -358.6889, 6061.7173, 31.5001),
		Spawner = vector3( -359.0310, 6072.8081, 31.4978),
		Heading = 136.9588
	}
}
-- End of Police

-- Start of Aircrafts
ConfigGarasi.AircraftGarages = {
	Los_Santos_Airport = {
		Marker = vector3( -1617.14, -3145.52, 12.99),
		Spawner = vector3( -1657.99, -3134.38, 12.99),
		Deleter = vector3( -1642.12, -3144.25, 12.99),
		Heading = 330.11
	},
	Sandy_Shores_Airport = {
		Marker = vector3(1723.84, 3288.29, 40.16),
		Spawner = vector3(1710.85, 3259.06, 40.69),
		Deleter = vector3(1714.45, 3246.75, 40.07),
		Heading = 104.66
	},
	Grapeseed_Airport = {
		Marker = vector3(2152.83, 4797.03, 40.19),
		Spawner = vector3(2122.72, 4804.85, 40.78),
		Deleter = vector3(2082.36, 4806.06, 40.07),
		Heading = 115.04
	}
}

ConfigGarasi.AircraftPounds = {
	Los_Santos_Airport = {
		Marker = vector3( -1243.0, -3391.92, 12.94),
		Spawner = vector3( -1272.27, -3382.46, 12.94),
		Heading = 330.25
	}
}
-- End of Aircrafts

-- Start of Boats
ConfigGarasi.BoatGarages = {
	Los_Santos_Dock = {
		Marker = vector3( -735.87, -1325.08, 0.6),
		Spawner = vector3( -718.87, -1320.18, -0.47),
		Deleter = vector3( -731.15, -1334.71, -0.47),
		Heading = 45.0
	},
	Sandy_Shores_Dock = {
		Marker = vector3(1333.2, 4269.92, 30.5),
		Spawner = vector3(1334.61, 4264.68, 29.86),
		Deleter = vector3(1323.73, 4269.94, 29.86),
		Heading = 87.0
	},
	Paleto_Bay_Dock = {
		Marker = vector3( -283.74, 6629.51, 6.3),
		Spawner = vector3( -290.46, 6622.72, -0.47),
		Deleter = vector3( -304.66, 6607.36, -0.47),
		Heading = 52.0
	}
}

ConfigGarasi.BoatPounds = {
	Los_Santos_Dock = {
		Marker = vector3( -738.67, -1400.43, 4.0),
		Spawner = vector3( -738.33, -1381.51, 0.12),
		Heading = 137.85
	}
}
-- End of Boats

-- Start of Cars
ConfigGarasi.CarGarages = {
	Garasi_Polisi = {
		Marker = vector3(472.45, -1084.22, 29.2),
		Spawner = vector3(472.45, -1084.22, 29.2),
		Deleter = vector3(472.45, -1084.22, 29.2),
		Heading = 94.57
	},
	Garasi_Rs = {
		Marker = vector3(274.37, -328.81, 44.92),
		Spawner = vector3(274.37, -328.81, 44.92),
		Deleter = vector3(274.37, -328.81, 44.92),
		Heading = 163.91
	},
	Garasi_Paradise = {
		Marker = vector3(153.39, -1334.76, 29.2),
		Spawner = vector3(153.39, -1334.76, 29.2),
		Deleter = vector3(153.39, -1334.76, 29.2),
		Heading = 323.01
	},
	Garasi_Perumnas = {
		Marker = vector3(1042.58, -776.45, 58.02),
		Spawner = vector3(1042.58, -776.45, 58.02),
		Deleter = vector3(1042.58, -776.45, 58.02),
		Heading = 58.46
	},
	Garasi_Panggung = {
		Marker = vector3(672.2714, 616.1487, 128.9111),
		Spawner = vector3(672.2714, 616.1487, 128.9111),
		Deleter = vector3(672.2714, 616.1487, 128.9111),
		Heading = 242.7490
	},
	Garasi_Bahamas = {
		Marker = vector3( -1420.2856, -643.6573, 28.6736),
		Spawner = vector3( -1420.2856, -643.6573, 28.6736),
		Deleter = vector3( -1420.2856, -643.6573, 28.6736),
		Heading = 215.3513
	},
	Garasi_Bandara = {
		Marker = vector3( -904.29, -2042.56, 9.3),
		Spawner = vector3( -904.29, -2042.56, 9.3),
		Deleter = vector3( -904.29, -2042.56, 9.3),
		Heading = 170.63
	},
	Garasi_Polantas = {
		Marker = vector3(391.36, -1666.46, 27.3),
		Spawner = vector3(391.36, -1666.46, 27.3),
		Deleter = vector3(391.36, -1666.46, 27.3),
		Heading = 37.97
	},
	Garasi_Megamall = {
		Marker = vector3( -31.43, -1677.67, 29.47),
		Spawner = vector3( -31.43, -1677.67, 29.47),
		Deleter = vector3( -31.43, -1677.67, 29.47),
		Heading = 241.39
	},
	Garasi_Stadion = {
		Marker = vector3( -74.87, -2019.86, 18.02),
		Spawner = vector3( -74.87, -2019.86, 18.02),
		Deleter = vector3( -74.87, -2019.86, 18.02),
		Heading = 77.51
	},
	Garasi_Walikota = {
		Marker = vector3( -412.69, 1205.31, 325.64),
		Spawner = vector3( -412.69, 1205.31, 325.64),
		Deleter = vector3( -412.69, 1205.31, 325.64),
		Heading = 159.38
	},
	Garasi_Petani2 = {
		Marker = vector3( -1139.94, 2676.02, 18.09),
		Spawner = vector3( -1139.94, 2676.02, 18.09),
		Deleter = vector3( -1139.94, 2676.02, 18.09),
		Heading = 18.09
	},
	Garasi_Asuransi = {
		Marker = vector3(582.68, 2722.26, 42.06),
		Spawner = vector3(582.68, 2722.26, 42.06),
		Deleter = vector3(582.68, 2722.26, 42.06),
		Heading = 270.52
	},
	Garasi_Import = {
		Marker = vector3(757.65, -3195.25, 6.07),
		Spawner = vector3(757.65, -3195.25, 6.07),
		Deleter = vector3(757.65, -3195.25, 6.07),
		Heading = 268.23
	},
	Sandy_Shores = {
		Marker = vector3(1709.66, 3595.3, 35.43),
		Spawner = vector3(1709.66, 3595.3, 35.43),
		Deleter = vector3(1709.66, 3595.3, 35.43),
		Heading = 213.89
	},
	Garasi_Paleto = {
		Marker = vector3(63.0641, 6404.0239, 31.2258),
		Spawner = vector3(63.0641, 6404.0239, 31.2258),
		Deleter = vector3(63.0641, 6404.0239, 31.2258),
		Heading = 147.2834
	},
	Garasi_Masjid = {
		Marker = vector3( -1394.64, -1211.83, 4.47),
		Spawner = vector3( -1394.64, -1211.83, 4.47),
		Deleter = vector3( -1394.64, -1211.83, 4.47),
		Heading = 73.41
	},
	Garasi_Teqila = {
		Marker = vector3( -570.1549, 312.4600, 84.4829),
		Spawner = vector3( -574.0791, 314.6586, 84.5592),
		Deleter = vector3( -570.1549, 312.4600, 84.4829),
		Heading = 93.76
	},
	Garasi_Nelayan = {
		Marker = vector3(3803.6741, 4453.6401, 4.4075),
		Spawner = vector3(3803.6741, 4453.6401, 4.4075),
		Deleter = vector3(3803.6741, 4453.6401, 4.4075),
		Heading = 66.2056
	},
	Garasi_Pemakaman = {
		Marker = vector3( -1662.44, -243.41, 54.92),
		Spawner = vector3( -1662.44, -243.41, 54.92),
		Deleter = vector3( -1662.44, -243.41, 54.92),
		Heading = 248.02
	},
	Garasi_RsOcean = {
		Marker = vector3( -1807.92, -383.75, 40.68),
		Spawner = vector3( -1807.92, -383.75, 40.68),
		Deleter = vector3( -1807.92, -383.75, 40.68),
		Heading = 133.55
	},
	Garasi_Gocart = {
		Marker = vector3( -1094.59, -3436.78, 13.95),
		Spawner = vector3( -1094.59, -3436.78, 13.95),
		Deleter = vector3( -1094.59, -3436.78, 13.95),
		Heading = 323.6
	}
}

ConfigGarasi.CarPounds = {
	Senora_Rd = {
		Marker = vector3(265.8, 2598.73, 43.92),
		Spawner = vector3(239.9415, 2601.7378, 45.1119),
		Heading = 16.6328
	},
	Paleto_Bay = {
		Marker = vector3( -355.08, 6066.16, 30.74),
		Spawner = vector3( -362.46, 6069.92, 31.5),
		Heading = 139.35
	}
}
-- End of Cars

-- Start of Private Cars
ConfigGarasi.PrivateCarGarages = {
	-- Maze Bank Building Garages
	RumahRwt2 = {
		Private = "Garasi Rumah Wayu",
		Marker = vector3(351.5515, 436.1059, 147.4946),
		Spawner = vector3(354.1019, 437.8407, 146.5008),
		Deleter = vector3(354.1019, 437.8407, 146.5008),
		Heading = 301.4889
	},
	-- End of VENT Custom Garages
}
-- End of Private Cars
