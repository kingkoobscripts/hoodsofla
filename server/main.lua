local QBCore = exports["qb-core"]:GetCoreObject()

local function initializeDatabase()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS mechanic_shops (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(50) UNIQUE,
            owner VARCHAR(50),
            balance INT DEFAULT 0,
            employees JSON DEFAULT '[]'
        )
    ]])

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

--- Handles the final installation and item consumption
RegisterNetEvent("mechanic:server:completeBuild", function(props, cart)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local totalCost = 0
    local missingItems = {}

    -- 1. Validate Items
    for _, mod in ipairs(cart) do
        local requiredItem = Config.ModRequirements[tonumber(mod.modId)]
        if requiredItem then
            local count = exports.ox_inventory:GetItemCount(src, requiredItem)
            if count < 1 then
                table.insert(missingItems, QBCore.Shared.Items[requiredItem].label)
            end
        end
        totalCost = totalCost + mod.price
    end

    if #missingItems > 0 then
        TriggerClientEvent("QBCore:Notify", src, "Missing parts: " .. table.concat(missingItems, ", "), "error")
        return
    end

    -- 2. Consume Items
    for _, mod in ipairs(cart) do
        local requiredItem = Config.ModRequirements[tonumber(mod.modId)]
        if requiredItem then
            exports.ox_inventory:RemoveItem(src, requiredItem, 1)
        end
    end

    -- 3. Save to DB
    MySQL.update.await("UPDATE player_vehicles SET mods = ? WHERE plate = ?", {
        json.encode(props),
        props.plate
    })

    -- 4. Log the service
    MySQL.insert.await("INSERT INTO mechanic_logs (shop_name, mechanic_name, plate, details, cost) VALUES (?, ?, ?, ?, ?)", {
        Player.PlayerData.job.label,
        Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
        props.plate,
        json.encode(cart),
        totalCost
    })

    TriggerClientEvent("QBCore:Notify", src, "Build finalized and parts installed!", "success")
end)