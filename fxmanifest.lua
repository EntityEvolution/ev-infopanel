fx_version 'cerulean'

game 'gta5'

lua54 'yes'

description 'A simple NUI rp panel developed by Entity Evolution'

version '1.0.0'

client_script 'cl.lua'

server_script {
    '@es_extended/imports.lua',
    'sv.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/*.ttf',
    'html/script.js'
}