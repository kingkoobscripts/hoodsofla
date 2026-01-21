fx_version "cerulean"
game "gta5"

author "SwisserAI"
description "mechanicxdealer - Advanced Modular Mechanic & Dealership Resource. Generated with SwisserAI - https://ai.swisser.dev"
version "1.4.0"

lua54 "yes"

dependency "oxmysql"
dependency "qbx_core"
dependency "ox_inventory"

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
    "web/apps/dealership/dealership.css",
    "web/apps/customer/customer.html",
    "web/apps/customer/customer.js",
    "web/apps/customer/customer.css"
}

shared_scripts {
    "config.lua",
    "shared/performance.lua"
}

client_scripts {
    "client/main.lua",
    "client/mechanic.lua",
    "client/tuning.lua",
    "client/camera.lua",
    "client/dealership.lua",
    "client/dyno.lua",
    "client/customer.lua",
    "client/durability.lua",
    "client/speedometer.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/framework.lua",
    "server/permissions.lua",
    "server/main.lua",
    "server/dealership.lua",
    "server/business.lua"
}