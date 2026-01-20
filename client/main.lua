local isUiOpen = false

--- Set the UI focus and state
--- @param state boolean
function SetUiState(state)
    isUiOpen = state
    SetNuiFocus(state, state)
    if not state then
        SendNUIMessage({ action = "closeUI" })
        DisplayRadar(true)
    else
        DisplayRadar(false)
    end
end

RegisterNetEvent("mechanic:client:openTablet", function(appType)
    local PlayerData = exports.qbx_core:GetPlayerData()
    
    if appType == "mechanic" and PlayerData.job.name ~= "mechanic" then
        exports.qbx_core:Notify("This tablet's OS is encrypted and only accessible by Mechanics.", "error")
        return
    end

    if appType == "admin" and not PlayerData.job.isboss then
        exports.qbx_core:Notify("Access Denied: Administrator privileges required.", "error")
        return
    end

    SetUiState(true)
    SendNUIMessage({
        action = "openSpecificApp",
        app = appType,
        userData = {
            name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            job = PlayerData.job.label,
            isBoss = PlayerData.job.isboss,
            citizenid = PlayerData.citizenid
        }
    })
end)

RegisterNUICallback("close", function(data, cb)
    SetUiState(false)
    cb("ok")
end)

-- Diagnostic Scanner Functionality
RegisterNUICallback("runDiagnostic", function(data, cb)
    local vehicle = lib.getClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, false)
    if not vehicle then
        exports.qbx_core:Notify("No vehicle detected nearby", "error")
        return cb(nil)
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    lib.callback("mechanic:server:scanVehicle", false, function(mods)
        if mods then
            SendNUIMessage({
                action = "setDiagnosticResult",
                plate = plate,
                engine = GetVehicleEngineHealth(vehicle),
                body = GetVehicleBodyHealth(vehicle),
                mods = mods
            })
        else
            exports.qbx_core:Notify("Vehicle not found in registry", "warning")
        end
    end, plate)
    cb("ok")
end)

CreateThread(function()
    while true do
        local sleep = 500
        if isUiOpen then
            sleep = 0
            if IsControlJustReleased(0, 322) then -- ESC
                SetUiState(false)
            end
        end
        Wait(sleep)
    end
end)