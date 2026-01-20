fx_version "cerulean"
game "gta5"

author "SwisserAI"
description "mechanicxdealer - Advanced Modular Mechanic & Dealership Resource. Generated with SwisserAI - https://ai.swisser.dev"
version "1.0.0"

lua54 "yes"

dependency "ox_lib"
dependency "oxmysql"
dependency "qbx_core"

ui_page "html/ui.html"

files {
    "html/ui.html",
    "html/style.css",
    "html/script.js",
}

shared_scripts {
    "config.lua"
}

client_scripts {
    "client/main.lua",
    "client/mechanic.lua",
    "client/tuning.lua",
    "client/camera.lua",
    "client/dealership.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua",
    "server/dealership.lua",
    "server/business.lua"
}