local showroomActive = false
local currentVehicle = nil

function OpenShowroom()
    showroomActive = true
    SetUiState(true)
    
    lib.callback("mechanic:server:getShowroom", false, function(vehicles)
        SendNUIMessage({
            action = "openShowroom",
            vehicles = vehicles
        })
    end)
end

RegisterNUICallback("previewVehicle", function(data, cb)
    if currentVehicle then DeleteEntity(currentVehicle) end
    
    local model = joaat(data.model)
    lib.requestModel(model)
    
    currentVehicle = CreateVehicle(model, Config.ShowroomCoords.x, Config.ShowroomCoords.y, Config.ShowroomCoords.z, Config.ShowroomCoords.w, false, false)
    SetEntityAlpha(currentVehicle, 255, false)
    SetVehicleModKit(currentVehicle, 0)
    
    CreateTuningCamera(currentVehicle)
    cb("ok")
end)

RegisterNUICallback("buyVehicle", function(data, cb)
    TriggerServerEvent("mechanic:server:buyVehicle", data.model)
    SetUiState(false)
    if currentVehicle then DeleteEntity(currentVehicle) end
    cb("ok")
end)