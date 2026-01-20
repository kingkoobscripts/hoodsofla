local QBCore = exports["qb-core"]:GetCoreObject()

--- Fetch Business Data for Admin and Mechanic Tablets
exports.qbx_core:CreateCallback("mechanic:server:getBusinessData", function(source, cb, shopName)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return cb(nil) end

    local result = MySQL.single.await("SELECT * FROM mechanic_shops WHERE name = ?", {shopName})
    if result then
        result.employees = json.decode(result.employees) or {}
        local logs = MySQL.query.await("SELECT * FROM mechanic_logs WHERE shop_name = ? ORDER BY timestamp DESC LIMIT 20", {shopName})
        result.logs = logs
    end
    cb(result)
end)

--- Wholesale Ordering Logic
RegisterNetEvent("mechanic:server:orderPart", function(partKey)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    -- Check if it's a standard part or an engine block
    local partData = Config.Parts[partKey] or Config.EngineBlocks[partKey]
    if not partData then return end

    -- Find which shop the player works for
    local shop = MySQL.single.await("SELECT name, balance FROM mechanic_shops WHERE JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))", {
        Player.PlayerData.citizenid
    })

    if not shop then
        exports.qbx_core:Notify(src, "You are not authorized to purchase for any shop", "error")
        return
    end

    if shop.balance < partData.price then
        exports.qbx_core:Notify(src, "Insufficient business funds ($" .. partData.price .. " required)", "error")
        return
    end

    if exports.ox_inventory:CanCarryItem(src, partData.item, 1) then
        local success = MySQL.update.await("UPDATE mechanic_shops SET balance = balance - ? WHERE name = ?", {partData.price, shop.name})
        if success then
            exports.ox_inventory:AddItem(src, partData.item, 1)
            exports.qbx_core:Notify(src, "Ordered " .. partData.label .. " for $" .. partData.price, "success")
            
            -- Log the business expense
            MySQL.insert.await("INSERT INTO mechanic_logs (shop_name, mechanic_name, plate, details, cost) VALUES (?, ?, ?, ?, ?)", {
                shop.name,
                Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname,
                "WHOLESALE",
                json.encode({ action = "purchase", item = partData.item }),
                -partData.price
            })
        end
    else
        exports.qbx_core:Notify(src, "You cannot carry this part", "error")
    end
end)

--- Employee Management: Hire
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
        exports.qbx_core:Notify(src, "Business registry not found", "error")
        return 
    end

    local employees = json.decode(shop.employees) or {}
    table.insert(employees, {
        citizenid = employee.PlayerData.citizenid,
        name = employee.PlayerData.charinfo.firstname .. " " .. employee.PlayerData.charinfo.lastname,
        grade = 0
    })

    MySQL.update.await("UPDATE mechanic_shops SET employees = ? WHERE name = ?", {json.encode(employees), shop.name})
    exports.qbx_core:SetJob(targetId, "mechanic", 0)
    exports.qbx_core:Notify(src, "Hired " .. employee.PlayerData.charinfo.firstname, "success")
end)

--- Financial Management: Withdraw
RegisterNetEvent("mechanic:server:withdrawMoney", function(amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player or not Player.PlayerData.job.isboss then return end

    local shop = MySQL.single.await("SELECT name, balance FROM mechanic_shops WHERE owner = ?", {Player.PlayerData.citizenid})
    if not shop or shop.balance < amount then
        exports.qbx_core:Notify(src, "Insufficient business funds", "error")
        return
    end

    MySQL.update.await("UPDATE mechanic_shops SET balance = balance - ? WHERE name = ?", {amount, shop.name})
    Player.Functions.AddMoney("cash", amount, "shop-withdrawal")
    exports.qbx_core:Notify(src, "Withdrew $" .. amount, "success")
end)