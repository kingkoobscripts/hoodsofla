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

--- Finalized Create Player Vehicle Handler
--- @param request table {citizenid, model, garage, props}
local function createPlayerVehicle(request)
    assert(request.model ~= nil, "missing required field: model")

    local props = request.props or {}
    if not props.plate then
        props.plate = GeneratePlate()
    end
    
    props.engineHealth = props.engineHealth or 1000
    props.bodyHealth = props.bodyHealth or 1000
    props.fuelLevel = props.fuelLevel or 100
    props.model = joaat(request.model)

    return MySQL.insert.await([[
        INSERT INTO player_vehicles 
        (license, citizenid, vehicle, hash, mods, plate, state, fuel, engine, body, garage) 
        VALUES (
            (SELECT license FROM players WHERE citizenid = ?), 
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        )
    ]], {
        request.citizenid,
        request.citizenid,
        request.model,
        props.model,
        json.encode(props),
        props.plate,
        1, -- State: In Garage
        props.fuelLevel,
        props.engineHealth,
        props.bodyHealth,
        request.garage or "pillbox"
    })
end

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
        local success = createPlayerVehicle({
            citizenid = Player.PlayerData.citizenid,
            model = vehicleData.model,
            garage = "pillbox",
            props = {
                plate = GeneratePlate(),
                color1 = 0,
                color2 = 0
            }
        })

        if success then
            TriggerClientEvent("QBCore:Notify", src, "Congratulations! Your " .. vehicleData.label .. " is in the garage.", "success")
        end
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