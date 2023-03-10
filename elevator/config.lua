-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

ConfigElevator = {}

ConfigElevator.checkForUpdates = true -- Check for Updates?

ConfigElevator.Elevators = {
    PillboxElevatorNorth = {
        [1] = {
            coords = vec3(-1843.2, -341.81, 49.45), -- Coords, if you're new; last number is heading
            heading = 137.6,                        -- Heading of how will spawn on floor
            title = 'Lantai 0',                     -- Title
            description = 'Lantai 0',               -- Description
            target = {
                width = 5,
                length = 4
            },
        },
        [2] = {
            coords = vec3(-1846.03, -342.26, 41.25), -- Coords, if you're new; last number is heading
            heading = 141.23,
            title = 'Lantai -2',
            description = 'Lantai -2',
            target = {
                width = 5,
                length = 4
            }
        },
        [3] = {
            coords = vec3(-1836.88, -336.76, 53.78), -- Coords, if you're new; last number is heading
            heading = 141.14,
            title = 'Lantai 1',
            description = 'Lantai 1',
            target = {
                width = 5,
                length = 4
            }
        },
        [4] = {
            coords = vec3(-1870.09, -309.3, 58.16), -- Coords, if you're new; last number is heading
            heading = 140.31,
            title = 'Lantai 2',
            description = 'Lantai 2',
            target = {
                width = 5,
                length = 4
            }
        },
        [5] = {
            coords = vec3(-1829.09, -336.63, 84.06), -- Coords, if you're new; last number is heading
            heading = 143.91,
            title = 'Lantai 8',
            description = 'Lantai 8',
            target = {
                width = 5,
                length = 4
            }
        },
    },
    HumanLab = {
        [1] = {
            coords = vec3(3540.6, 3675.38, 28.12), -- Coords, if you're new; last number is heading
            heading = 169.52,                      -- Heading of how will spawn on floor
            title = 'Lantai 1',                    -- Title
            description = 'Lantai 1',              -- Description
            target = {
                width = 5,
                length = 4
            },
        },
        [2] = {
            coords = vec3(3540.64, 3675.64, 20.99), -- Coords, if you're new; last number is heading
            heading = 170.26,
            title = 'Lantai 0',
            description = 'Lantai 0',
            target = {
                width = 5,
                length = 4
            }
        },
    },
}
