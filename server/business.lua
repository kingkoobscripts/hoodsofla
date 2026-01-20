local QBCore = exports["qb-core"]:GetCoreObject()

--- Fetch Business Data for Admin and Mechanic Tablets
exports.qbx_core:CreateCallback("mechanic:server:getBusinessData", function(source, cb, shopName)
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return cb(nil) end

    local query = "SELECT * FROM mechanic_shops WHERE name = ?"
    local params = {shopName}

    if not shopName then
        query = "SELECT * FROM mechanic_shops WHERE JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))"
        params = {Player.PlayerData.citizenid}
    end

    local result = MySQL.single.await(query, params)
    if result then
        result.employees = json.decode(result.employees) or {}
        local logs = MySQL.query.await("SELECT * FROM mechanic_logs WHERE shop_name = ? ORDER BY timestamp DESC LIMIT 20", {result.name})
        result.logs = logs
        
        -- Send data to NUI if this was a refresh request
        TriggerClientEvent("mechanic:client:updateAdminData", source, result)
    end
    cb(result)
end)

-- Admin Data Request Handler
RegisterNUICallback("requestBusinessData", function(data, cb)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    local shop = MySQL.single.await("SELECT name FROM mechanic_shops WHERE JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))", {
        Player.PlayerData.citizenid
    })

    if shop then
        local business = MySQL.single.await("SELECT * FROM mechanic_shops WHERE name = ?", {shop.name})
        business.employees = json.decode(business.employees) or {}
        business.logs = MySQL.query.await("SELECT * FROM mechanic_logs WHERE shop_name = ? ORDER BY timestamp DESC LIMIT 20", {shop.name})
        
        SendNUIMessage({
            action = "setBusinessData",
            business = business
        })
    end
    cb("ok")
end)

--- Fetch Shop Stock (Wholesale Pricing)
exports.qbx_core:CreateCallback("mechanic:server:getShopStock", function(source, cb)
    local stock = {}
    for k, v in pairs(Config.Parts) do
        table.insert(stock, {
            item = k,
            name = v.label,
            price = v.price,
            category = v.category
        })
    end
    cb(stock)
end)

--- Wholesale Ordering Logic
RegisterNetEvent("mechanic:server:orderPart", function(partKey)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    local partData = Config.Parts[partKey] or Config.EngineBlocks[partKey]
    if not partData then return end

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
RegisterNetEvent("mechanic:server:hireEmployee", function(data)
    local src = source
    local boss = exports.qbx_core:GetPlayer(src)
    if not boss.PlayerData.job.isboss then return end

    local employee = exports.qbx_core:GetPlayer(data.targetId)
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
    exports.qbx_core:SetJob(data.targetId, "mechanic", 0)
    exports.qbx_core:Notify(src, "Hired " .. employee.PlayerData.charinfo.firstname, "success")
end)

--- Employee Management: Fire
RegisterNetEvent("mechanic:server:fireEmployee", function(data)
    local src = source
    local boss = exports.qbx_core:GetPlayer(src)
    if not boss.PlayerData.job.isboss then return end

    local shop = MySQL.single.await("SELECT name, employees FROM mechanic_shops WHERE owner = ?", {boss.PlayerData.citizenid})
    if not shop then return end

    local employees = json.decode(shop.employees) or {}
    local newList = {}
    for _, emp in ipairs(employees) do
        if emp.citizenid ~= data.citizenid then
            table.insert(newList, emp)
        end
    end

    MySQL.update.await("UPDATE mechanic_shops SET employees = ? WHERE name = ?", {json.encode(newList), shop.name})
    
    -- Attempt to set job to unemployed if player is online
    local target = exports.qbx_core:GetPlayerByCitizenId(data.citizenid)
    if target then
        exports.qbx_core:SetJob(target.PlayerData.source, "unemployed", 0)
    end
    
    exports.qbx_core:Notify(src, "Employee terminated", "inform")
end)

--- Financial Management: Withdraw
RegisterNetEvent("mechanic:server:withdrawMoney", function(data)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player or not Player.PlayerData.job.isboss then return end

    local shop = MySQL.single.await("SELECT name, balance FROM mechanic_shops WHERE owner = ?", {Player.PlayerData.citizenid})
    if not shop or shop.balance < data.amount then
        exports.qbx_core:Notify(src, "Insufficient business funds", "error")
        return
    end

    MySQL.update.await("UPDATE mechanic_shops SET balance = balance - ? WHERE name = ?", {data.amount, shop.name})
    Player.Functions.AddMoney("cash", data.amount, "shop-withdrawal")
    exports.qbx_core:Notify(src, "Withdrew $" .. data.amount, "success")
end)