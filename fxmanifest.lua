-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
fx_version 'cerulean'
game 'gta5'

lua54 'yes'
use_experimental_fxv2_oal 'yes'

description 'Wasabi Backpack for Ox Inventory'
version '2.0.0-ALPHA'


files {
  'locales/*.lua'
}

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua'
}

client_scripts {
    'client/**.lua'
}

server_scripts {
  'server/**.lua'
}

dependencies {
  '/server:5848',
  '/onesync',
  'ox_lib',
  'ox_inventory'
}
