fx_version 'cerulean'
games { 'gta5' }
author 'Base code by c0deina, edited by Masi' -- https://github.com/c0deina/esx_robnpc

server_scripts {
    'config.lua',
    'server/main.lua'
}

client_scripts {
   '@es_extended/locale.lua',
   'locales/en.lua',
   'locales/fi.lua',
   'config.lua',
   'client/main.lua'
}

dependencies {
    'es_extended'
}