local QBCore = exports["qb-core"]:GetCoreObject()

-- Vehicle Catalog
local ShowroomVehicles = {
    { model = "panto", label = "Panto Sport", price = 15000, category = "compact" },
    { model = "adder", label = "Truffade Adder", price = 1000000, category = "super" },
    { model = "elegy2", label = "Elegy Retro", price = 150000, category = "sport" }
}

-- Fetch showroom for NUI
QBCore.Functions.CreateCallback("mechanic:server:getShowroom", function(source, cb)
    cb(ShowroomVehicles)
end)

-- Purchase Logic
RegisterNetEvent("mechanic:server:buyVehicle", function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local vehicleData = nil

    for _, v in ipairs(ShowroomVehicles) do
        if v.model == model then vehicleData = v break end
    end

    if not vehicleData then return end

    if Player.Functions.RemoveMoney("bank", vehicleData.price, "vehicle-purchase") then
        local plate = GeneratePlate()
        
        -- Following the context pattern for creating player vehicles
        MySQL.insert.await([[
            INSERT INTO player_vehicles 
            (license, citizenid, vehicle, hash, mods, plate, state, fuel, engine, body) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ]], {
            Player.PlayerData.license,
            Player.PlayerData.citizenid,
            vehicleData.model,
            joaat(vehicleData.model),
            "{}",
            plate,
            1,      -- state (in garage)
            100,    -- fuel
            1000,   -- engine
            1000    -- body
        })

        TriggerClientEvent("QBCore:Notify", src, "Congratulations! Your " .. vehicleData.label .. " (Plate: "..plate..") is in the garage.", "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Insufficient funds in bank", "error")
    end
end)

function GeneratePlate()
    local plate = string.upper(lib.string.random("AA11AA11"))
    local result = MySQL.scalar.await("SELECT plate FROM player_vehicles WHERE plate = ?", {plate})
    if result then return GeneratePlate() end
    return plate
end