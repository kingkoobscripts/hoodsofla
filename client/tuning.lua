local QBCore = exports["qb-core"]:GetCoreObject()

--- Expanded list of all GTA vehicle modification categories
local ModCategories = {
    performance = {
        { id = 11, name = "Engine Tuning" },
        { id = 12, name = "Brake Systems" },
        { id = 13, name = "Transmission" },
        { id = 15, name = "Suspension" },
        { id = 18, name = "Turbocharger" }
    },
    cosmetic = {
        { id = 0, name = "Spoilers" },
        { id = 1, name = "Front Bumpers" },
        { id = 2, name = "Rear Bumpers" },
        { id = 3, name = "Side Skirts" },
        { id = 4, name = "Exhaust" },
        { id = 5, name = "Roll Cages" },
        { id = 6, name = "Grilles" },
        { id = 7, name = "Hoods" },
        { id = 8, name = "Fenders" },
        { id = 10, name = "Roof" },
        { id = 22, name = "Xenon Lights" },
        { id = 23, name = "Wheels" }
    }
}

--- Fetches all available mods with proper pricing and labels
--- @param vehicle number Entity handle
--- @return table mods
local function getVehicleMods(vehicle)
    local mods = { performance = {}, cosmetic = {}, paint = {} }
    SetVehicleModKit(vehicle, 0)

    -- Process Performance
    for _, mod in ipairs(ModCategories.performance) do
        local count = GetNumVehicleMods(vehicle, mod.id)
        if count > 0 or mod.id == 18 then
            mods.performance[#mods.performance + 1] = {
                modId = mod.id,
                name = mod.name,
                count = count,
                current = GetVehicleMod(vehicle, mod.id),
                price = Config.Prices.performance
            }
        end
    end

    -- Process Cosmetic
    for _, mod in ipairs(ModCategories.cosmetic) do
        local count = GetNumVehicleMods(vehicle, mod.id)
        if count > 0 then
            mods.cosmetic[#mods.cosmetic + 1] = {
                modId = mod.id,
                name = mod.name,
                count = count,
                current = GetVehicleMod(vehicle, mod.id),
                price = Config.Prices.cosmetic
            }
        end
    end

    return mods
end

RegisterNUICallback("requestVehicleData", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        local mods = getVehicleMods(vehicle)
        SendNUIMessage({ action = "setVehicleMods", mods = mods })
    end
    cb("ok")
end)

RegisterNUICallback("purchaseMod", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if not vehicle or vehicle == 0 then return cb("fail") end

    -- Apply the mod locally first
    if data.modId == 18 then
        ToggleVehicleMod(vehicle, 18, true)
    else
        SetVehicleMod(vehicle, data.modId, data.level, false)
    end

    -- Save to Database
    local props = QBCore.Functions.GetVehicleProperties(vehicle)
    TriggerServerEvent("mechanic:server:saveVehicleProps", props)
    
    cb("ok")
end)