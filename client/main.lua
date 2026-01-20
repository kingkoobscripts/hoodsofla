local isUiOpen = false

--- Set the UI focus and state
--- @param state boolean
function SetUiState(state)
    isUiOpen = state
    SetNuiFocus(state, state)
    if not state then
        SendNUIMessage({ action = "closeUI" })
    else
        DisplayRadar(false)
    end
    
    if not state then
        DisplayRadar(true)
    end
end

-- NUI Callbacks
RegisterNUICallback("close", function(data, cb)
    SetUiState(false)
    cb("ok")
end)

-- ESC Key backup
CreateThread(function()
    while true do
        local sleep = 500
        if isUiOpen then
            sleep = 0
            if IsControlJustReleased(0, 322) then
                SetUiState(false)
            end
        end
        Wait(sleep)
    end
end)

--- Helper to get vehicle health percentage
function GetVehicleHealth(vehicle)
    local engine = GetVehicleEngineHealth(vehicle)
    local body = GetVehicleBodyHealth(vehicle)
    return {
        engine = math.floor(engine / 10),
        body = math.floor(body / 10)
    }
end