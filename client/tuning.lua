local QBCore = exports["qb-core"]:GetCoreObject()
local originalProps = nil
local currentShoppingCart = {}

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
        { id = 23, name = "Wheels" },
        { id = 48, name = "Liveries" }
    },
    colors = {
        { id = "primary", name = "Primary Paint" },
        { id = "secondary", name = "Secondary Paint" },
        { id = "pearlescent", name = "Pearlescent" },
        { id = "wheels", name = "Wheel Color" }
    }
}

--- Captures the vehicle state before tuning starts
function StartTuningSession(vehicle)
    originalProps = QBCore.Functions.GetVehicleProperties(vehicle)
    currentShoppingCart = {}
end

--- Reverts changes if user cancels
function CancelTuningSession(vehicle)
    if originalProps then
        QBCore.Functions.SetVehicleProperties(vehicle, originalProps)
    end
    originalProps = nil
    currentShoppingCart = {}
end

--- Fetches all available mods
local function getVehicleMods(vehicle)
    local mods = { performance = {}, cosmetic = {}, colors = {} }
    SetVehicleModKit(vehicle, 0)

    for _, mod in ipairs(ModCategories.performance) do
        local count = GetNumVehicleMods(vehicle, mod.id)
        mods.performance[#mods.performance + 1] = {
            modId = mod.id,
            name = mod.name,
            count = count,
            current = GetVehicleMod(vehicle, mod.id),
            price = Config.Prices.performance
        }
    end

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

-- NUI Callbacks
RegisterNUICallback("requestVehicleData", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        if not originalProps then StartTuningSession(vehicle) end
        local mods = getVehicleMods(vehicle)
        SendNUIMessage({ action = "setVehicleMods", mods = mods })
    end
    cb("ok")
end)

--- PREVIEW ONLY: Does not save to DB
RegisterNUICallback("previewMod", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if not vehicle or vehicle == 0 then return cb("fail") end

    if data.modId == 18 then
        ToggleVehicleMod(vehicle, 18, true)
    elseif data.modId == "primary" then
        local _, s = GetVehicleColours(vehicle)
        SetVehicleColours(vehicle, data.level, s)
    else
        SetVehicleMod(vehicle, tonumber(data.modId), tonumber(data.level), false)
    end
    
    cb("ok")
end)

--- FINALIZE: The actual installation process
RegisterNUICallback("confirmBuild", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local cart = data.cart -- List of mods {modId, level, price}
    
    if lib.progressBar({
        duration = #cart * 2000,
        label = "Installing Modifications...",
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true },
        anim = { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig5@", clip = "working_free_area" }
    }) then
        local props = QBCore.Functions.GetVehicleProperties(vehicle)
        TriggerServerEvent("mechanic:server:completeBuild", props, cart)
        originalProps = nil -- Commit successful
        SetUiState(false)
    else
        CancelTuningSession(vehicle)
    end
    cb("ok")
end)