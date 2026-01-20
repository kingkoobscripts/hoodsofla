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

-- Mechanic Tablet Usage
exports("use_mechanic_tablet", function(event, item, inventory, slot, data)
    if event == "usingItem" then
        local src = inventory.id
        TriggerClientEvent("mechanic:client:openTablet", src, "mechanic")
        return false 
    end
end)

-- Admin/Business Tablet Usage
exports("use_admin_tablet", function(event, item, inventory, slot, data)
    if event == "usingItem" then
        local src = inventory.id
        TriggerClientEvent("mechanic:client:openTablet", src, "admin")
        return false
    end
end)

-- Build Finalization Logic
RegisterNetEvent("mechanic:server:completeBuild", function(props, cart)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local totalCost = 0
    local missingItems = {}

    -- 1. Validate Items & Calculate Cost
    for _, mod in ipairs(cart) do
        local requiredItem = Config.ModRequirements[tonumber(mod.modId)]
        if requiredItem then
            local count = exports.ox_inventory:GetItemCount(src, requiredItem)
            if count < 1 then
                table.insert(missingItems, requiredItem)
            end
        end
        totalCost = totalCost + (mod.price or 0)
    end

    if #missingItems > 0 then
        TriggerClientEvent("QBCore:Notify", src, "Missing required parts in inventory", "error")
        return
    end

    -- 2. Consume Items
    for _, mod in ipairs(cart) do
        local requiredItem = Config.ModRequirements[tonumber(mod.modId)]
        if requiredItem then
            exports.ox_inventory:RemoveItem(src, requiredItem, 1)
        end
    end

    -- 3. Update Vehicle Database
    MySQL.update.await("UPDATE player_vehicles SET mods = ? WHERE plate = ?", {
        json.encode(props),
        props.plate
    })

    -- 4. Log the Transaction & Pay the Shop
    local shop = MySQL.single.await("SELECT name FROM mechanic_shops WHERE JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))", {
        Player.PlayerData.citizenid
    })

    if shop then
        MySQL.update.await("UPDATE mechanic_shops SET balance = balance + ? WHERE name = ?", {totalCost, shop.name})
        
        MySQL.insert.await("INSERT INTO mechanic_logs (shop_name, mechanic_name, plate, details, cost) VALUES (?, ?, ?, ?, ?)", {
            shop.name,
            Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
            props.plate,
            json.encode(cart),
            totalCost
        })
    end

    TriggerClientEvent("QBCore:Notify", src, "Build finalized. Components installed successfully.", "success")
end)