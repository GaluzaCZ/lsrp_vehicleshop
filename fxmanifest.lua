--[[ Main ]]
fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

--[[ Misc ]]
author 'mikigoalie @ LSRP (dsc.gg/lsrpeu)'
description '[OX only] Simple vehicleshop utilizing OX Library'
version '2.0.0'


--[[ Resource related ]]
files { 'locales/*.json' }
dependencies { 'oxmysql', 'ox_lib', 'ox_core' }
provide 'esx_vehicleshop'

shared_scripts { '@ox_lib/init.lua', 'config.lua' }
server_scripts { '@oxmysql/lib/MySQL.lua', '@ox_core/imports/server.lua', 'server/main.lua', 'server/fn.lua' }
client_scripts { '@ox_core/imports/client.lua', 'client/main.lua' }
