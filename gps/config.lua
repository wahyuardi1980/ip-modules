ConfigGps = {}

ConfigGps.selfBlip = true -- use classic arrow or job specified blip?
ConfigGps.useRflxMulti = false -- server specific init
ConfigGps.useBaseEvents = false -- F for optimisation
ConfigGps.prints = true -- server side prints (on/off duty)

-- looks
ConfigGps.font = {
    useCustom = false, -- use custom font? Has to be specified below, also can be buggy with player tags
    name = 'Russo One', -- > this being inserted into <font face='nameComesHere'> eg. (<font face='Russo One'>) --> Your font has to be streamed and initialized on ur server
}
ConfigGps.notifications = {
    enable = true,
    useMythic = true,
    onDutyText = 'Gps nyala', -- pretty straight foward
    offDutyText = 'Gps mati', -- pretty straight foward
}
ConfigGps.blipGroup = {
    renameGroup = true,
    groupName = '~b~Anggota'
}

-- blips
ConfigGps.bigmapTags = false -- Playername tags when bigmap enabled?
ConfigGps.blipCone = true -- use that wierd FOV indicators thing?

ConfigGps.useCharacterName = true -- use IC name or OOC name, chose your warrior
ConfigGps.usePrefix = true
ConfigGps.namePrefix = {
    -- global name prefixes by grade_name
    tamtama1 = 'Tamtama Sabhara - ',
    tamtama2 = 'Tamtama Brimob - ',
    tamtama3 = 'Tamtama Polantas - ',
    bripda1 = 'Bripda Sabhara - ',
    bripda2 = 'Bripda Brimob - ',
    bripda3 = 'Bripda Polantas - ',
    briptu1 = 'Briptu Sabhara - ',
    briptu2 = 'Briptu Brimob - ',
    briptu3 = 'Britu Polantas - ',
    brigpol1 = 'Brigpol Sabhara - ',
    brigpol2 = 'Brigpol Brimob - ',
    brigpol3 = 'Brigpol Polantas - ',
    bripka1 = 'Bripka Sabhara - ',
    bripka2 = 'Bripka Brimob - ',
    bripka3 = 'Bripka Polantas - ',
    aipda1 = 'Aipda Sabhara - ',
    aipda2 = 'Aipda Brimob - ',
    aipda3 = 'Aipda Polantas - ',
    aiptu1 = 'Aiptu Sabhara - ',
    aiptu2 = 'Aiptu Brimob - ',
    aiptu3 = 'Aiptu Polantas - ',
    ipda1 = 'Ipda Sabhara - ',
    ipda2 = 'Ipda Brimob - ',
    ipda3 = 'Ipda Polantas - ',
    iptu1 = 'Iptu Sabhara - ',
    iptu2 = 'Iptu Brimob - ',
    iptu3 = 'Iptu Polantas - ',
    akp1 = 'AKP Sabhara - ',
    akp2 = 'AKP Brimob - ',
    akp3 = 'AKP Polantas - ',
    kompol1 = 'Kompol Sabhara - ',
    kompol2 = 'Kompol Brimob - ',
    kompol3 = 'Kompol Polantas - ',
    akbp1 = 'AKBP Sabhara - ',
    akbp2 = 'AKBP Brimob - ',
    akbp3 = 'AKBP Polantas - ',
    kombes1 = 'Kombes Sabhara - ',
    kombes2 = 'Kombes Brimob - ',
    kombes3 = 'Kombes Polantas - ',
    brigjen1 = 'Brigjen Sabhara - ',
    brigjen2 = 'Brigjen Brimob - ',
    brigjen3 = 'Brigjen Polantas - ',
    irjen1 = 'Irjen Sabhara - ',
    irjen2 = 'Irjen Brimob - ',
    irjen3 = 'Irjen Polantas - ',
    komjen = 'Komjen - ',
    jenderal = 'Jenderal Polisi - ',
    sekretaris1 = 'Sekretaris Sabhara - ',
    sekretaris2 = 'Sekretaris Brimob - ',
    sekretaris3 = 'Sekretaris Polantas - ',
    provos1 = 'Tamtama Provos - ',
    provos2 = 'Bripda Provos - ',
    provos3 = 'Briptu Provos - ',
    provos4 = 'Brigpol Provos - ',
    provos5 = 'Bripka Provos - ',
    provos6 = 'Aipda Provos - ',
    provos7 = 'Aiptu Provos - ',
    provos8 = 'Ipda Provos - ',
    provos9 = 'Iptu Provos - ',
    provos10 = 'AKP Provos - ',
    provos11 = 'Kompol Provos - ',
    provos12 = 'AKBP Provos - ',
    provos13 = 'Kombes Provos - ',
    provos14 = 'Brigjen Provos - ',
    provos15 = 'Irjen Provos - ',
    -- ems
    magangems = 'Training - ',
    anggotaems = 'Perawat - ',
    dokter = 'Dokter - ',
    spesialis = 'Dr.Spesialis - ',
    codirektur = 'Wakil Direktur - ',
    direktur = 'Direktur - ',
    -- bengkel
    magangmontir = 'Magang - ',
    amatir = 'Amatir - ',
    ahli = 'Ahli - ',
    comontir = 'Wakil Kepala - ',
    kepala = 'Kepala - ',
    -- pedagang
    magangpedagang = 'Magang - ',
    anggotapedagang = 'Anggota - ',
    koki = 'Koki - ',
    colead = 'Wakil Kepala - ',
    lead = 'Kepala -',
    -- taxi
    magangtaxi = 'Magang - ',
    driver = 'Driver - ',
    uber = 'Uber - ',
    cotaxi = 'Wakil Kepala - ',
    leader = 'Kepala - ',
    -- Tni
    tni1 = 'Tentara #INDOPUBLIC - ',
}

--[[
  Full ConfigGps template:

    ['police'] = { --> job name in database
        ignoreDuty = true, -- if ignore, you don't need to call onDuty or offDuty by exports or event, player is on map while he has that job
        blip = {
            sprite = 60, -- on foot blip sprite (required)
            color = 29, -- on foot blip color (required)
            scale = 0.8, -- global blip scale 1.0 by default (not required)
            flashColors = { -- blip flash when siren ON! You can define as many colors as you want! //// If you don't want to use flash, then just delete it (not required)
                59,
                29,
            }
        },
        vehBlip = { -- in vehicle blip ConfigGps, if you don't want to use it, just delete it (not required)
            ['default'] = { -- global in vehicle blip (required if you have "vehBlip" defined)
                sprite = 56,
                color = 29,
            },
            [`ambluance`] = { -- this overrides 'default' blip by vehicle hash, hash has to be between ` eg. `spawnnamehere`
                sprite = 56,
                color = 29,
            },
            [`police2`] = {
                sprite = 56,
                color = 29,
            }
        },
        gradePrefix = { -- global ConfigGps.namePrefix override (not required)
            [0] = 'CAD.', -- 0 = grade number in database | 'CAD. ' is label obv..
        },
        canSee = { -- What job can see this job, when not defined they'll see only self job --> police will see only police blips (not required)
            ['police'] = true,
            ['sheriff'] = true,
            ['shreck'] = true, --> this cfg has to be in specified format "['jobname'] = true"
        }
    },
--]]
ConfigGps.emergencyJobs = {
    ['police'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 3,
            -- flashColors = {
            --     59,
            --     29,
            -- }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 29,
            },
            [`coolpdcar`] = {
                sprite = 56,
                color = 29,
            },
        },
        gradePrefix = { -- global ConfigGps.namePrefix override (not required)
            [0] = 'Tamtama1 ', -- 0 = grade number in database | 'CAD. ' is label obv..
            [1] = 'Tamtama2 ',
            [2] = 'Tamtama3 ',
            [3] = 'Bripda1 ',
            [4] = 'Bripda2 ',
            [5] = 'Bripda3 ',
            [7] = 'Briptu1 ',
            [8] = 'Briptu2 ',
            [9] = 'Briptu3 ',
            [10] = 'Brigpol1 ',
            [11] = 'Brigpol2 ',
            [12] = 'Brigpol3 ',
            [13] = 'Bripka1 ',
            [14] = 'Bripka2 ',
            [15] = 'Bripka3 ',
            [16] = 'Aipda1 ',
            [17] = 'Aipda2 ',
            [18] = 'Aipda3 ',
            [19] = 'Aiptu1 ',
            [20] = 'Aiptu2 ',
            [21] = 'Aiptu3 ',
            [22] = 'Ipda1 ',
            [23] = 'Ipda2 ',
            [24] = 'Ipda3 ',
            [25] = 'Iptu1 ',
            [26] = 'Iptu2 ',
            [27] = 'Iptu3 ',
            [28] = 'Akp1 ',
            [29] = 'Akp2 ',
            [30] = 'Akp3 ',
            [31] = 'Kompol1 ',
            [32] = 'Kompol2 ',
            [33] = 'Kompol3 ',
            [34] = 'Akbp1 ',
            [35] = 'Akbp2 ',
            [36] = 'Akbp3 ',
            [37] = 'Kombes1 ',
            [38] = 'Kombes2 ',
            [39] = 'Kombes3 ',
            [40] = 'Brigjen1 ',
            [41] = 'Brigjen2 ',
            [42] = 'Brigjen3 ',
            [43] = 'Irjen1 ',
            [44] = 'Irjen2 ',
            [45] = 'Irjen3 ',
            [46] = 'Komjen ',
            [47] = 'Jenderal ',
            [48] = 'Sekretaris1 ',
            [49] = 'Sekretaris2 ',
            [50] = 'Sekretaris3 ',
            [51] = 'provos1 ',
            [52] = 'provos2 ',
            [53] = 'provos3 ',
            [54] = 'provos4',
            [55] = 'provos4 ',
            [56] = 'provos5 ',
            [57] = 'provos6 ',
            [58] = 'provos7 ',
            [59] = 'provos8 ',
            [60] = 'provos9 ',
            [61] = 'provos10 ',
            [62] = 'provos11 ',
            [63] = 'provos12 ',
            [64] = 'provos13 ',
            [65] = 'provos14 ',
            [66] = 'provos15 ',

        },
        canSee = {
            ['police'] = true
        }
    },
    ['ambulance'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 41,
            -- flashColors = {
            --     0,
            --     59,
            -- }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 41,
            },
            [`supervolito2`] = {
                sprite = 43,
                color = 59,
            },
        },
        gradePrefix = { -- global ConfigGps.namePrefix override (not required)
            [0] = 'Training ', -- 0 = grade number in database | 'CAD. ' is label obv..
            [1] = 'Perawat ',
            [2] = 'Dokter ',
            [3] = 'Dr.Spesialis ',
            [4] = 'Wakil Direktur ',
            [5] = 'Direktur ',
        },
        canSee = {
            ['ambulance'] = true
        }
    },
    ['montir'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 25,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 25,
            },
            [`supervolito3`] = {
                sprite = 43,
                color = 59,
            },
        },
        gradePrefix = { -- global ConfigGps.namePrefix override (not required)
            [0] = 'Magang ', -- 0 = grade number in database | 'CAD. ' is label obv..
            [1] = 'Amatir ',
            [2] = 'Ahli ',
            [3] = 'Comontir ',
            [4] = 'Kepala ',
        },
        canSee = {
            ['montir'] = true
        }
    },
    ['pedagang'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 47,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 47,
            },
            [`supervolito4`] = {
                sprite = 43,
                color = 59,
            },
        },
        gradePrefix = { -- global ConfigGps.namePrefix override (not required)
            [0] = 'Magang ', -- 0 = grade number in database | 'CAD. ' is label obv..
            [1] = 'Anggota ',
            [2] = 'Koki ',
            [3] = 'Colead ',
            [4] = 'lead ',
        },
        canSee = {
            ['pedagang'] = true
        }
    },
    ['taxi'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 46,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 46,
            },
            [`supervolito5`] = {
                sprite = 43,
                color = 46,
            },
        },
        gradePrefix = { -- global ConfigGps.namePrefix override (not required)
            [0] = 'Magang ', -- 0 = grade number in database | 'CAD. ' is label obv..
            [1] = 'Driver ',
            [2] = 'Uber ',
            [3] = 'Cotaxi ',
            [4] = 'leader ',
        },
        canSee = {
            -- ['police'] = true,
            ['taxi'] = true,
        }
    },
    ['tni'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 52,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 52,
            },
            [`supervolito6`] = {
                sprite = 43,
                color = 52,
            },
        },
        gradePrefix = { -- global ConfigGps.namePrefix override (not required)
            [0] = 'Tni ', -- 0 = grade number in database | 'CAD. ' is label obv..
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['montir'] = true,
            ['pedagang'] = true,
            ['taxi'] = true,
            ['tni'] = true,
        }
    }
}
