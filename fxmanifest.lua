fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'ElectricSkateboardFiveM'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua',
    '@es_extended/locale.lua',
    'locales/en.lua',
    '**/config/*.lua',
    '**/shared/*.lua',
    '**/config*.lua',

}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    '@PolyZone/CircleZone.lua',
    '**/client/*.lua',
    '**/bridge/**/client.lua',
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '**/bridge/**/server.lua',
    '**/server/*.lua',

}

exports {
    'CooldownToTable',
    'CooldownToString',
    'GetCoolDown',
    'GetTime',
    'GetFuel',
    'SetFuel'
}

server_exports {
    'CooldownToTable',
    'CooldownToString',
    'TimeToString',
    'TimeToTable',
    'GetCooldown',
    'GetTime',
    'SetCooldown'
}

-- dependencies {
--     'es_extended'
-- }
