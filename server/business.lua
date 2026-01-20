-- Handle Business Management Data
exports.qbx_core:CreateCallback("mechanic:server:getBusinessData", function(source, cb, shopName)
    local result = MySQL.single.await("SELECT * FROM mechanic_shops WHERE name = ?", {shopName})
    if result then
        result.employees = json.decode(result.employees) or {}
        
        -- Get Unpaid Invoices for the shop
        local invoices = MySQL.query.await("SELECT * FROM mechanic_invoices WHERE shop_name = ? AND status = 'unpaid'", {shopName})
        result.invoices = invoices
    end
    cb(result)
end)

-- Employee Management
RegisterNetEvent("mechanic:server:hireEmployee", function(targetId)
    local src = source
    local boss = exports.qbx_core:GetPlayer(src)
    if not boss.PlayerData.job.isboss then return end

    local employee = exports.qbx_core:GetPlayer(targetId)
    if not employee then return end

    local shop = MySQL.single.await("SELECT name, employees FROM mechanic_shops WHERE owner = ?", {boss.PlayerData.citizenid})
    if not shop then return end

    local employees = json.decode(shop.employees) or {}
    table.insert(employees, {
        citizenid = employee.PlayerData.citizenid,
        name = employee.PlayerData.charinfo.firstname .. " " .. employee.PlayerData.charinfo.lastname,
        grade = 0
    })

    MySQL.update.await("UPDATE mechanic_shops SET employees = ? WHERE name = ?", {json.encode(employees), shop.name})
    exports.qbx_core:Notify(src, "Hired " .. employee.PlayerData.charinfo.firstname, "success")
end)

-- Parts Ordering Logic
RegisterNetEvent("mechanic:server:orderPart", function(partId)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    local partData = Config.Parts[partId]
    if not partData then return end

    local shop = MySQL.single.await("SELECT balance, name FROM mechanic_shops WHERE owner = ? OR JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))", {
        Player.PlayerData.citizenid,
        Player.PlayerData.citizenid
    })

    if not shop then
        exports.qbx_core:Notify(src, "You are not linked to a registered shop", "error")
        return
    end

    if shop.balance >= partData.price then
        MySQL.update.await("UPDATE mechanic_shops SET balance = balance - ? WHERE name = ?", {partData.price, shop.name})
        exports.ox_inventory:AddItem(src, partId, 1)
        exports.qbx_core:Notify(src, "Ordered " .. partData.label, "success")
    else
        exports.qbx_core:Notify(src, "Shop balance too low", "error")
    end
end)

RegisterNetEvent("mechanic:server:withdrawMoney", function(amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player.PlayerData.job.isboss then return end

    local shop = MySQL.single.await("SELECT balance, name FROM mechanic_shops WHERE owner = ?", {Player.PlayerData.citizenid})
    if shop and shop.balance >= amount then
        MySQL.update.await("UPDATE mechanic_shops SET balance = balance - ? WHERE name = ?", {amount, shop.name})
        Player.Functions.AddMoney("cash", amount, "shop-withdrawal")
        exports.qbx_core:Notify(src, "Withdrew $" .. amount, "success")
    else
        exports.qbx_core:Notify(src, "Insufficient shop funds", "error")
    end
end)