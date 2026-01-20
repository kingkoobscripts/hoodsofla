local QBCore = exports["qb-core"]:GetCoreObject()
local originalProps = nil

local ModCategories = {
    performance = {
        { id = 11, name = "Engine Tuning", price = 5000 },
        { id = 12, name = "Brake Systems", price = 3000 },
        { id = 13, name = "Transmission", price = 4500 },
        { id = 15, name = "Suspension", price = 2500 },
        { id = 18, name = "Turbocharger", price = 8000 }
    }
}

--- PREVIEW: Apply visually but don't save
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
    cb("ok")
end)

--- FINALIZE: Process build and server-side validation
RegisterNUICallback("confirmBuild", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    
    if lib.progressBar({
        duration = 5000,
        label = "Finalizing Vehicle Build...",
        useWhileDead = false,
        canCancel = true,
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

RegisterNUICallback("requestVehicleData", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return cb("fail") end
    
    local mods = { performance = {} }
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
    
    SendNUIMessage({ action = "setVehicleMods", mods = mods })
    cb("ok")
end)