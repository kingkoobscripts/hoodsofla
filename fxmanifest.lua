fx_version "cerulean"
game "gta5"

author "SwisserAI"
description "mechanicxdealer - Advanced Modular Mechanic & Dealership Resource. Generated with SwisserAI - https://ai.swisser.dev"
version "1.1.0"

lua54 "yes"

dependency "ox_lib"
dependency "oxmysql"
dependency "qbx_core"

-- Set the UI entry point
ui_page "web/dist/index.html"

files {
    "web/dist/index.html",
    "web/dist/style.css",
    "web/dist/script.js",
    "web/dist/assets/*.png", -- Icons and logos
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