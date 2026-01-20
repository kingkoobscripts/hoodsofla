local QBCore = exports["qb-core"]:GetCoreObject()
local originalProps = nil

local ModCategories = {
    performance = {
        { id = 11, name = "Engine Tuning", price = 5000 },
        { id = 12, name = "Brake Systems", price = 3000 },
        { id = 13, name = "Transmission", price = 4500 },
        { id = 15, name = "Suspension", price = 2500 },
        { id = 18, name = "Turbocharger", price = 8000 }
    },
    cosmetic = {
        { id = 0, name = "Spoilers", price = 1500 },
        { id = 1, name = "Front Bumper", price = 1200 },
        { id = 2, name = "Rear Bumper", price = 1200 },
        { id = 3, name = "Side Skirts", price = 1000 },
        { id = 4, name = "Exhaust", price = 2000 },
        { id = 7, name = "Hood", price = 1800 },
        { id = 48, name = "Livery", price = 2500 }
    }
}

--- PREVIEW: Apply visually and move camera
RegisterNUICallback("previewMod", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if not vehicle or vehicle == 0 then return cb("fail") end

    if not originalProps then
        originalProps = QBCore.Functions.GetVehicleProperties(vehicle)
    end

    SetVehicleModKit(vehicle, 0)
    
    if data.modId == 18 then
        ToggleVehicleMod(vehicle, 18, data.level ~= -1)
    else
        SetVehicleMod(vehicle, tonumber(data.modId), tonumber(data.level), false)
    end

    -- Move Camera based on category
    MoveTuningCamera(vehicle, data.type)
    
    cb("ok")
end)

--- FINALIZE: Process build and server-side validation
RegisterNUICallback("confirmBuild", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    
    if lib.progressBar({
        duration = 5000,
        label = "Installing Components...",
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true },
        anim = { dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig5@", clip = "working_free_area" }
    }) then
        local props = QBCore.Functions.GetVehicleProperties(vehicle)
        TriggerServerEvent("mechanic:server:completeBuild", props, data.cart)
        originalProps = nil
        SetUiState(false)
    else
        -- Revert on cancel
        if originalProps then
            QBCore.Functions.SetVehicleProperties(vehicle, originalProps)
            originalProps = nil
        end
    end
    cb("ok")
end)

--- DATA REQUEST: Send vehicle mod list to NUI
RegisterNUICallback("requestVehicleData", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return cb("fail") end
    
    local mods = { performance = {}, cosmetic = {} }
    SetVehicleModKit(vehicle, 0)

    for _, cat in ipairs(ModCategories.performance) do
        table.insert(mods.performance, {
            modId = cat.id,
            name = cat.name,
            count = GetNumVehicleMods(vehicle, cat.id),
            current = GetVehicleMod(vehicle, cat.id),
            price = cat.price
        })
    end

    for _, cat in ipairs(ModCategories.cosmetic) do
        local count = GetNumVehicleMods(vehicle, cat.id)
        if count > 0 then
            table.insert(mods.cosmetic, {
                modId = cat.id,
                name = cat.name,
                count = count,
                current = GetVehicleMod(vehicle, cat.id),
                price = cat.price
            })
        end
    end
    
    -- Get Engine Swap Data
    local plate = GetVehicleNumberPlateText(vehicle)
    lib.callback("mechanic:server:getEngineData", false, function(engineData)
        SendNUIMessage({ 
            action = "setVehicleMods", 
            mods = mods,
            engineData = engineData or { type = "Stock", health = 100 }
        })
    end, plate)

    cb("ok")
end)

--- ENGINE SWAP ACTION
RegisterNUICallback("swapEngine", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return cb("fail") end

    if lib.progressBar({
        duration = 10000,
        label = "Swapping Engine Block...",
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true },
        anim = { dict = "mp_car_bomb", clip = "car_bomb_mechanic" }
    }) then
        TriggerServerEvent("mechanic:server:swapEngine", GetVehicleNumberPlateText(vehicle), data.engineType)
        SetUiState(false)
    end
    cb("ok")
end)