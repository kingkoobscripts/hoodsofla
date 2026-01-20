fx_version "cerulean"
game "gta5"

author "SwisserAI"
description "mechanicxdealer - Advanced Modular Mechanic & Dealership Resource. Generated with SwisserAI - https://ai.swisser.dev"
version "1.2.0"

lua54 "yes"

dependency "ox_lib"
dependency "oxmysql"
dependency "qbx_core"

-- Set the UI entry point (Main Shell)
ui_page "web/index.html"

files {
    "web/index.html",
    "web/style.css",
    "web/script.js",
    "web/apps/mechanic/mechanic.html",
    "web/apps/mechanic/mechanic.js",
    "web/apps/dealership/dealership.html",
    "web/apps/dealership/dealership.js",
    "web/assets/*.png",
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