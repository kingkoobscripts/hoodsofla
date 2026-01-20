local isDynoActive = false
local dynoVehicle = nil

--- Starts or stops the live dyno data stream
--- @param state boolean
function SetDynoState(state)
    isDynoActive = state
    if state then
        dynoVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        StartDynoLoop()
    else
        dynoVehicle = nil
    end
end

function StartDynoLoop()
    CreateThread(function()
        while isDynoActive do
            if not dynoVehicle or dynoVehicle == 0 or not IsPedInAnyVehicle(PlayerPedId(), false) then
                isDynoActive = false
                break
            end

            local rpm = GetVehicleCurrentRpm(dynoVehicle)
            local speed = GetEntitySpeed(dynoVehicle) * 2.236936 -- MPH
            local gear = GetVehicleCurrentGear(dynoVehicle)
            
            -- Simulated Torque/HP calculation based on RPM and Handling
            local maxTorque = GetVehicleHandlingFloat(dynoVehicle, "CHandlingData", "fInitialDriveForce")
            local torque = (rpm * maxTorque) * 500
            local hp = (torque * (rpm * 7000)) / 5252

            SendNUIMessage({
                action = "updateDyno",
                data = {
                    rpm = rpm,
                    speed = math.floor(speed),
                    gear = gear,
                    torque = math.floor(torque),
                    hp = math.floor(hp)
                }
            })
            
            Wait(100) -- 10Hz Refresh rate for UI performance
        end
    end)
end

RegisterNUICallback("toggleDyno", function(data, cb)
    SetDynoState(data.state)
    cb("ok")
end)