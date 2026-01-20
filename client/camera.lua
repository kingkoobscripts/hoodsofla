local cam = nil

--- Creates a cinematic camera focused on the vehicle
--- @param vehicle number Entity handle
function CreateTuningCamera(vehicle)
    local camPos = GetOffsetFromEntityInWorldCoords(vehicle, -2.5, 3.5, 1.5)
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
    PointCamAtEntity(cam, vehicle, 0.0, 0.0, 0.0, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, true)
end

--- Smoothly destroys the tuning camera
function DestroyTuningCamera()
    if not cam then return end
    RenderScriptCams(false, true, 1000, true, true)
    DestroyCam(cam, false)
    cam = nil
end

--- Moves camera to specific vehicle parts
--- @param vehicle number Entity handle
--- @param type string 'engine' | 'rear' | 'body'
function MoveTuningCamera(vehicle, type)
    if not cam then return end
    local offset = vector3(-2.0, 3.0, 1.0)
    
    if type == "performance" then
        offset = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.5, 1.2)
    elseif type == "cosmetic" then
        offset = GetOffsetFromEntityInWorldCoords(vehicle, -2.5, -2.5, 1.0)
    end

    SetCamCoord(cam, offset.x, offset.y, offset.z)
    PointCamAtEntity(cam, vehicle, 0.0, 0.0, 0.0, true)
end