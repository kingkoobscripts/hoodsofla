-- Handle Business Management Data
exports.qbx_core:CreateCallback("mechanic:server:getBusinessData", function(source, cb, shopName)
    local result = MySQL.single.await("SELECT * FROM mechanic_shops WHERE name = ?", {shopName})
    if result then
        result.employees = json.decode(result.employees) or {}
        
        -- Get recent logs for this shop
        local logs = MySQL.query.await("SELECT * FROM mechanic_logs WHERE shop_name = ? ORDER BY timestamp DESC LIMIT 20", {shopName})
        result.logs = logs
    end
    cb(result)
end)

-- Employee Management: Hire
RegisterNetEvent("mechanic:server:hireEmployee", function(targetId)
    local src = source
    local boss = exports.qbx_core:GetPlayer(src)
    if not boss.PlayerData.job.isboss then return end

    local employee = exports.qbx_core:GetPlayer(targetId)
    if not employee then 
        exports.qbx_core:Notify(src, "Player not found", "error")
        return 
    end

    local shop = MySQL.single.await("SELECT name, employees FROM mechanic_shops WHERE owner = ?", {boss.PlayerData.citizenid})
    if not shop then 
        exports.qbx_core:Notify(src, "You do not own a registered business", "error")
        return 
    end

    local employees = json.decode(shop.employees) or {}
    
    for _, emp in ipairs(employees) do
        if emp.citizenid == employee.PlayerData.citizenid then
            exports.qbx_core:Notify(src, "Already employed here", "error")
            return
        end
    end

    table.insert(employees, {
        citizenid = employee.PlayerData.citizenid,
        name = employee.PlayerData.charinfo.firstname .. " " .. employee.PlayerData.charinfo.lastname,
        grade = 0
    })

    MySQL.update.await("UPDATE mechanic_shops SET employees = ? WHERE name = ?", {json.encode(employees), shop.name})
    
    exports.qbx_core:SetJob(targetId, "mechanic", 0)
    exports.qbx_core:Notify(src, "Successfully hired " .. employee.PlayerData.charinfo.firstname, "success")
    exports.qbx_core:Notify(targetId, "You have been hired by " .. shop.name, "success")
end)

-- Employee Management: Fire
RegisterNetEvent("mechanic:server:fireEmployee", function(citizenid)
    local src = source
    local boss = exports.qbx_core:GetPlayer(src)
    if not boss.PlayerData.job.isboss then return end

    local shop = MySQL.single.await("SELECT name, employees FROM mechanic_shops WHERE owner = ?", {boss.PlayerData.citizenid})
    if not shop then return end

    local employees = json.decode(shop.employees) or {}
    local newEmployees = {}
    local found = false

    for _, emp in ipairs(employees) do
        if emp.citizenid ~= citizenid then
            table.insert(newEmployees, emp)
        else
            found = true
        end
    end

    if found then
        MySQL.update.await("UPDATE mechanic_shops SET employees = ? WHERE name = ?", {json.encode(newEmployees), shop.name})
        
        local employee = exports.qbx_core:GetPlayerByCitizenId(citizenid)
        if employee then
            exports.qbx_core:SetJob(employee.PlayerData.source, "unemployed", 0)
        end
        exports.qbx_core:Notify(src, "Employee terminated", "success")
    end
end)

-- Financial Management: Withdraw
RegisterNetEvent("mechanic:server:withdrawMoney", function(amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player or not Player.PlayerData.job.isboss then return end

    local shop = MySQL.single.await("SELECT name, balance FROM mechanic_shops WHERE owner = ?", {Player.PlayerData.citizenid})
    if not shop or shop.balance < amount then
        exports.qbx_core:Notify(src, "Insufficient business funds", "error")
        return
    end

    if MySQL.update.await("UPDATE mechanic_shops SET balance = balance - ? WHERE name = ?", {amount, shop.name}) > 0 then
        Player.Functions.AddMoney("cash", amount, "shop-withdrawal")
        exports.qbx_core:Notify(src, "Withdrew $" .. amount .. " from " .. shop.name, "success")
    end
end)

-- Diagnostic Scanner Logic
exports.qbx_core:CreateCallback("mechanic:server:scanVehicle", function(source, cb, plate)
    local result = MySQL.single.await("SELECT mods FROM player_vehicles WHERE plate = ?", {plate})
    if result then
        cb(json.decode(result.mods))
    else
        cb(nil)
    end
end)

-- NEW: Stock Management Logic
exports.qbx_core:CreateCallback("mechanic:server:getShopStock", function(source, cb)
    local stock = {}
    for itemName, data in pairs(Config.Parts) do
        local count = exports.ox_inventory:GetItemCount(source, data.item)
        table.insert(stock, {
            name = data.label,
            item = data.item,
            amount = count,
            price = data.price
        })
    end
    cb(stock)
end)

-- NEW: Invoicing System
RegisterNetEvent("mechanic:server:sendInvoice", function(targetId, amount, reason)
    local src = source
    local mechanic = exports.qbx_core:GetPlayer(src)
    local customer = exports.qbx_core:GetPlayer(targetId)

    if not customer then return end

    local shop = MySQL.single.await("SELECT name FROM mechanic_shops WHERE JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))", {
        mechanic.PlayerData.citizenid
    })

    if not shop then return end

    -- Using ox_lib for the confirmation dialog on customer side
    TriggerClientEvent("mechanic:client:receiveInvoice", targetId, {
        shopName = shop.name,
        amount = amount,
        reason = reason,
        mechanicSource = src
    })
end)

RegisterNetEvent("mechanic:server:payInvoice", function(data)
    local src = source
    local customer = exports.qbx_core:GetPlayer(src)
    
    if customer.Functions.RemoveMoney("bank", data.amount, "mechanic-invoice") then
        MySQL.update.await("UPDATE mechanic_shops SET balance = balance + ? WHERE name = ?", {data.amount, data.shopName})
        exports.qbx_core:Notify(src, "Invoice Paid: $" .. data.amount, "success")
        exports.qbx_core:Notify(data.mechanicSource, "Customer paid the invoice of $" .. data.amount, "success")
    else
        exports.qbx_core:Notify(src, "Insufficient funds to pay invoice", "error")
        exports.qbx_core:Notify(data.mechanicSource, "Customer failed to pay the invoice", "error")
    end
end)