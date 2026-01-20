-- Handle Business Management Data
exports.qbx_core:CreateCallback("mechanic:server:getBusinessData", function(source, cb, shopName)
    local result = MySQL.single.await("SELECT * FROM mechanic_shops WHERE name = ?", {shopName})
    if result then
        result.employees = json.decode(result.employees) or {}
        
        -- Get recent logs for this shop
        local logs = MySQL.query.await("SELECT * FROM mechanic_logs WHERE shop_name = ? ORDER BY timestamp DESC LIMIT 10", {shopName})
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
    if not employee then return end

    local shop = MySQL.single.await("SELECT name, employees FROM mechanic_shops WHERE owner = ?", {boss.PlayerData.citizenid})
    if not shop then return end

    local employees = json.decode(shop.employees) or {}
    
    -- Check if already hired
    for _, emp in ipairs(employees) do
        if emp.citizenid == employee.PlayerData.citizenid then
            exports.qbx_core:Notify(src, "Already employed", "error")
            return
        end
    end

    table.insert(employees, {
        citizenid = employee.PlayerData.citizenid,
        name = employee.PlayerData.charinfo.firstname .. " " .. employee.PlayerData.charinfo.lastname,
        grade = 0
    })

    MySQL.update.await("UPDATE mechanic_shops SET employees = ? WHERE name = ?", {json.encode(employees), shop.name})
    
    -- Set the job via framework
    exports.qbx_core:SetJob(targetId, "mechanic", 0)
    exports.qbx_core:Notify(src, "Successfully hired " .. employee.PlayerData.charinfo.firstname, "success")
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
    for _, emp in ipairs(employees) do
        if emp.citizenid ~= citizenid then
            table.insert(newEmployees, emp)
        end
    end

    MySQL.update.await("UPDATE mechanic_shops SET employees = ? WHERE name = ?", {json.encode(newEmployees), shop.name})
    
    -- If player is online, set them to unemployed
    local employee = exports.qbx_core:GetPlayerByCitizenId(citizenid)
    if employee then
        exports.qbx_core:SetJob(employee.PlayerData.source, "unemployed", 0)
    end
    
    exports.qbx_core:Notify(src, "Employee terminated", "success")
end)

-- Shop Financials: Deposit
RegisterNetEvent("mechanic:server:depositMoney", function(amount)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end

    if Player.Functions.RemoveMoney("cash", amount, "shop-deposit") then
        local shop = MySQL.single.await("SELECT name FROM mechanic_shops WHERE owner = ? OR JSON_CONTAINS(employees, JSON_OBJECT('citizenid', ?))", {
            Player.PlayerData.citizenid,
            Player.PlayerData.citizenid
        })
        
        if shop then
            MySQL.update.await("UPDATE mechanic_shops SET balance = balance + ? WHERE name = ?", {amount, shop.name})
            exports.qbx_core:Notify(src, "Deposited $" .. amount .. " to business account", "success")
        end
    end
end)