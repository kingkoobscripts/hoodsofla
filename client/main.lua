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
    
    -- Security Check
    if appType == "mechanic" and PlayerData.job.name ~= "mechanic" then
        exports.qbx_core:Notify("This tablet's OS is encrypted and only accessible by Mechanics.", "error")
        return
    end

    SetUiState(true)
    SendNUIMessage({
        action = "openSpecificApp",
        app = appType,
        userData = {
            name = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            job = PlayerData.job.label,
            isBoss = PlayerData.job.isboss
        }
    })
end)

RegisterNUICallback("close", function(data, cb)
    SetUiState(false)
    cb("ok")
end)

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