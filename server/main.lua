local QBCore = exports["qb-core"]:GetCoreObject()

--- SQL Table Initialization
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

    -- Engine Swaps & Performance Metadata Table
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS vehicle_engines (
            plate VARCHAR(15) PRIMARY KEY,
            engine_type VARCHAR(50) DEFAULT "v6_stock",
            nitro_level INT DEFAULT 0,
            reliability FLOAT DEFAULT 1.0,
            metadata JSON DEFAULT '{}',
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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

--- Stress Relief Logic for Mechanics (QBX Style)
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
        exports.qbx_core:Notify(source, "The precision work helps you focus. Stress relieved.", "inform", 2500, nil, nil, { "#141517", "#ffffff" }, "brain", "#0F52BA")
    end
end

--- Modular query builder for vehicle updates (Finalized for Persistence)
--- @param vehicleId string Plate
--- @param options table Data to save
local function buildSaveVehicleQuery(vehicleId, options)
    local crumbs = {}
    local placeholders = {}

    if options.state ~= nil then
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

-- Engine Swap Logic with 300MPH Metadata Injection
RegisterNetEvent("mechanic:server:swapEngine", function(plate, engineType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local blockData = Config.EngineBlocks[engineType]
    if not blockData then return end

    local hasItem = exports.ox_inventory:GetItemCount(src, blockData.item)
    if hasItem < 1 then
        exports.qbx_core:Notify(src, "Missing " .. blockData.label .. " in inventory", "error")
        return
    end

    exports.ox_inventory:RemoveItem(src, blockData.item, 1)

    -- Inject High-Performance Handling Metadata
    local metadata = { 
        topSpeedMultiplier = engineType == "v12_racing" and 1.6 or (engineType == "v8_crate" and 1.3 or 1.1), 
        accelerationBonus = engineType == "electric_tesla" and 2.5 or 1.5,
        isProBuild = true,
        installedBy = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    }
    
    MySQL.query.await([[
        INSERT INTO vehicle_engines (plate, engine_type, metadata) 
        VALUES (?, ?, ?) 
        ON DUPLICATE KEY UPDATE engine_type = ?, metadata = ?, updated_at = CURRENT_TIMESTAMP
    ]], {plate, engineType, json.encode(metadata), engineType, json.encode(metadata)})

    relieveMechanicStress(src, 15, 25)
    exports.qbx_core:Notify(src, "Performance Engine Swapped: " .. blockData.label, "success")
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
        exports.qbx_core:Notify(src, "Missing components: " .. table.concat(missingItems, ", "), "error")
        return
    end

    -- Deduct parts
    for _, mod in ipairs(cart) do
        local requiredItem = Config.ModRequirements[tonumber(mod.modId)]
        if requiredItem then exports.ox_inventory:RemoveItem(src, requiredItem, 1) end
    end

    -- Persistent DB Save
    local query, placeholders = buildSaveVehicleQuery(props.plate, { props = props })
    MySQL.update.await(query, placeholders)

    relieveMechanicStress(src, 5, 15)

    -- Business Balance Logic
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

    exports.qbx_core:Notify(src, "Installation complete. Database updated.", "success")
end)