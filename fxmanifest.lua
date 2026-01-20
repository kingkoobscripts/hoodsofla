fx_version "cerulean"
game "gta5"

author "SwisserAI"
description "mechanicxdealer - Advanced Modular Mechanic & Dealership Resource. Generated with SwisserAI - https://ai.swisser.dev"
version "1.3.0"

lua54 "yes"

dependency "ox_lib"
dependency "oxmysql"
dependency "qbx_core"

-- UI Entry Points
ui_page "web/index.html"

files {
    "web/index.html",
    "web/style.css",
    "web/script.js",
    "web/apps/mechanic/mechanic.html",
    "web/apps/mechanic/mechanic.js",
    "web/apps/mechanic/mechanic.css",
    "web/apps/admin/admin.html",
    "web/apps/admin/admin.js",
    "web/apps/admin/admin.css",
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