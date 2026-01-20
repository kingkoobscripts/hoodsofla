local QBCore = exports["qb-core"]:GetCoreObject()

local function initializeDatabase()
    -- Business Table
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS mechanic_shops (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(50) UNIQUE,
            owner VARCHAR(50),
            balance INT DEFAULT 0,
            employees JSON DEFAULT '[]'
        )
    ]])

    -- Engine Swaps Table
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS vehicle_engines (
            plate VARCHAR(15) PRIMARY KEY,
            engine_type VARCHAR(50) DEFAULT "v6_stock",
            nitro_level INT DEFAULT 0,
            reliability FLOAT DEFAULT 1.0,
            metadata JSON DEFAULT '{}'
        )
    ]])

    -- Logs for builds
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS mechanic_logs (
            id INT AUTO_INCREMENT PRIMARY KEY,
            shop_name VARCHAR(50),
            mechanic_name VARCHAR(100),
            plate VARCHAR(15),
            details JSON,
            cost INT,
            timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])
end

MySQL.ready(function()
    initializeDatabase()
end)

--- Stress Relief Logic for Mechanics
--- @param source number Player ID
--- @param min number Minimum relief
--- @param max number Maximum relief
local function relieveMechanicStress(source, min, max)
    local playerState = Player(source).state
    local amount = math.random(min or 5, max or 15)
    local currentStress = playerState.stress or 0
    local newStress = lib.math.clamp(currentStress - amount, 0, 100)

    playerState:set("stress", newStress, true)
    
    if amount > 0 then
        exports.qbx_core:Notify(source, "Focused work relieved some stress", "inform", 2500, nil, nil, { "#141517", "#ffffff" }, "brain", "#0F52BA")
    end
end

--- Modular query builder for vehicle updates (Finalized for Persistence)
--- @param vehicleId string Plate or Database ID
--- @param options table Data to save
local function buildSaveVehicleQuery(vehicleId, options)
    local crumbs = {}
    local placeholders = {}

    if options.state then
        crumbs[#crumbs+1] = "state = ?"
        placeholders[#placeholders+1] = options.state
    end

    if options.depotPrice then
        crumbs[#crumbs+1] = "depotprice = ?"
        placeholders[#placeholders+1] = options.depotPrice
    end

    if options.props then
        crumbs[#crumbs+1] = "mods = ?"
        placeholders[#placeholders+1] = json.encode(options.props)

        if options.props.engineHealth then
            crumbs[#crumbs+1] = "engine = ?"
            placeholders[#placeholders+1] = options.props.engineHealth
        end

        if options.props.bodyHealth then
            crumbs[#crumbs+1] = "body = ?"
            placeholders[#placeholders+1] = options.props.bodyHealth
        end

        if options.props.fuelLevel then
            crumbs[#crumbs+1] = "fuel = ?"
            placeholders[#placeholders+1] = options.props.fuelLevel
        end
    end

    placeholders[#placeholders+1] = vehicleId
    return string.format("UPDATE player_vehicles SET %s WHERE plate = ?", table.concat(crumbs, ", ")), placeholders
end

-- Diagnostic Scanner Callback
lib.callback.register("mechanic:server:scanVehicle", function(source, plate)
    local result = MySQL.single.await("SELECT mods, engine, body FROM player_vehicles WHERE plate = ?", {plate})
    if result then
        return {
            props = json.decode(result.mods),
            engine = result.engine,
            body = result.body
        }
    end
    return nil
end)

-- Fetch Engine Swap Data
lib.callback.register("mechanic:server:getEngineData", function(source, plate)
    return MySQL.single.await("SELECT * FROM vehicle_engines WHERE plate = ?", {plate})
end)

-- Engine Swap Logic
RegisterNetEvent("mechanic:server:swapEngine", function(plate, engineType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local blockData = Config.EngineBlocks[engineType]
    if not blockData then return end

    local hasItem = exports.ox_inventory:GetItemCount(src, blockData.item)
    if hasItem < 1 then
        TriggerClientEvent("QBCore:Notify", src, "Missing " .. blockData.label .. " in inventory", "error")
        return
    end

    exports.ox_inventory:RemoveItem(src, blockData.item, 1)

    -- Inject 300MPH Metadata for high-end blocks
    local metadata = { topSpeedMultiplier = 1.5, accelerationBonus = 2.0 }
    
    MySQL.query.await([[
        INSERT INTO vehicle_engines (plate, engine_type, metadata) 
        VALUES (?, ?, ?) 
        ON DUPLICATE KEY UPDATE engine_type = ?, metadata = ?
    ]], {plate, engineType, json.encode(metadata), engineType, json.encode(metadata)})

    relieveMechanicStress(src, 10, 20)
    TriggerClientEvent("QBCore:Notify", src, "Engine Swapped: " .. blockData.label, "success")
end)

-- Build Finalization Logic
RegisterNetEvent("mechanic:server:completeBuild", function(props, cart)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local missingItems = {}
    local totalCharge = 0

    for _, mod in ipairs(cart) do
        local requiredItem = Config.ModRequirements[tonumber(mod.modId)]
        if requiredItem then
            local count = exports.ox_inventory:GetItemCount(src, requiredItem)
            if count < 1 then table.insert(missingItems, requiredItem) end
        end
        totalCharge = totalCharge + (mod.price or 0)
    end

    if #missingItems > 0 then
        TriggerClientEvent("QBCore:Notify", src, "Missing required components to finish build", "error")
        return
    end

    for _, mod in ipairs(cart) do
        local requiredItem = Config.ModRequirements[tonumber(mod.modId)]
        if requiredItem then exports.ox_inventory:RemoveItem(src, requiredItem, 1) end
    end

    -- Save using Persistent Query
    local query, placeholders = buildSaveVehicleQuery(props.plate, { props = props })
    MySQL.update.await(query, placeholders)

    -- Relieve stress for completing a job
    relieveMechanicStress(src, 5, 15)

    -- Update Business Balance
    local shop = MySQL.single.await("SELECT name FROM mechanic_shops WHERE JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))", {
        Player.PlayerData.citizenid
    })

    if shop then
        MySQL.update.await("UPDATE mechanic_shops SET balance = balance + ? WHERE name = ?", {totalCharge, shop.name})
        MySQL.insert.await("INSERT INTO mechanic_logs (shop_name, mechanic_name, plate, details, cost) VALUES (?, ?, ?, ?, ?)", {
            shop.name,
            Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
            props.plate,
            json.encode(cart),
            totalCharge
        })
    end

    TriggerClientEvent("QBCore:Notify", src, "Installation complete. Database updated.", "success")
end)

-- Invoicing System
RegisterNetEvent("mechanic:server:sendInvoice", function(targetId, amount, reason)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local target = QBCore.Functions.GetPlayer(targetId)
    
    if not target then return end

    local shop = MySQL.single.await("SELECT name FROM mechanic_shops WHERE JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))", {
        Player.PlayerData.citizenid
    })

    local shopName = shop and shop.name or "Mechanic Service"

    TriggerClientEvent("mechanic:client:receiveInvoice", targetId, {
        shopName = shopName,
        amount = amount,
        reason = reason,
        senderId = src
    })
end)

RegisterNetEvent("mechanic:server:payInvoice", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if Player.Functions.RemoveMoney("bank", data.amount, "mechanic-service") then
        local shop = MySQL.single.await("SELECT name FROM mechanic_shops WHERE name = ?", {data.shopName})
        if shop then
            MySQL.update.await("UPDATE mechanic_shops SET balance = balance + ? WHERE name = ?", {data.amount, shop.name})
        end
        TriggerClientEvent("QBCore:Notify", src, "Invoice Paid: $" .. data.amount, "success")
        TriggerClientEvent("QBCore:Notify", data.senderId, "Customer paid invoice of $" .. data.amount, "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Insufficient funds in bank", "error")
        TriggerClientEvent("QBCore:Notify", data.senderId, "Customer failed to pay invoice", "error")
    end
end)