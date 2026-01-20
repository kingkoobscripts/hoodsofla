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

    -- Invoices Table
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS mechanic_invoices (
            id INT AUTO_INCREMENT PRIMARY KEY,
            shop_name VARCHAR(50),
            citizenid VARCHAR(50),
            amount INT,
            reason TEXT,
            status VARCHAR(20) DEFAULT 'unpaid',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])

    -- Seed default shop if empty
    local count = MySQL.scalar.await("SELECT COUNT(*) FROM mechanic_shops")
    if count == 0 then
        MySQL.insert.await("INSERT INTO mechanic_shops (name, owner, balance) VALUES (?, ?, ?)", 
        {"Benny's Motorworks", "none", 50000})
    end
end

MySQL.ready(function()
    initializeDatabase()
end)

-- Save Vehicle Props
RegisterNetEvent("mechanic:server:saveVehicleProps", function(props)
    local src = source
    if not props.plate then return end

    MySQL.update.await("UPDATE player_vehicles SET mods = ? WHERE plate = ?", {
        json.encode(props),
        props.plate
    })
    
    TriggerClientEvent("QBCore:Notify", src, "Vehicle modifications registered", "success")
end)

-- Business Data Callback
lib.callback.register("mechanic:server:getBusinessData", function(source, shopId)
    local Player = QBCore.Functions.GetPlayer(source)
    local result = MySQL.single.await("SELECT * FROM mechanic_shops WHERE name = ?", {shopId})
    
    if result then
        result.isOwner = result.owner == Player.PlayerData.citizenid or Player.PlayerData.job.isboss
    end
    
    return result
end)