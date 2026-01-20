local currentZone = nil

-- Initialize Zones from Config
CreateThread(function()
    for shopId, data in pairs(Config.Shops) do
        lib.zones.sphere({
            coords = data.coords,
            radius = data.radius,
            debug = false,
            inside = function()
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    lib.showTextUI("[E] - Open MechanicX Tablet", {position = "left-center"})
                    if IsControlJustReleased(0, 38) then
                        openMechanicTablet(shopId)
                    end
                end
            end,
            onExit = function()
                lib.hideTextUI()
                if isUiOpen then SetUiState(false) end
            end
        })
    end
end)

function openMechanicTablet(shopId)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    local PlayerData = exports.qbx_core:GetPlayerData()
    local isMechanic = PlayerData.job.name == "mechanic"

    if not isMechanic then
        exports.qbx_core:Notify("You are not authorized to use this tablet", "error")
        return
    end

    lib.callback("mechanic:server:getBusinessData", false, function(business)
        local health = { engine = 100, body = 100 }
        if vehicle ~= 0 then
            health = {
                engine = GetVehicleEngineHealth(vehicle),
                body = GetVehicleBodyHealth(vehicle)
            }
            CreateTuningCamera(vehicle) -- Pro Mode: Cinematic Cam
        end

        local shopData = {
            shopName = business and business.name or "LS Customs",
            mechanic = PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname,
            isOwner = PlayerData.job.isboss,
            isInVehicle = vehicle ~= 0,
            health = health,
            balance = business and business.balance or 0
        }

        SetUiState(true)
        SendNUIMessage({
            action = "openMechanicMenu",
            data = shopData
        })
    end, shopId)
end

-- Override SetUiState to handle cameras
local originalSetUiState = SetUiState
function SetUiState(state)
    originalSetUiState(state)
    if not state then
        DestroyTuningCamera()
    end
end

-- NUI Callbacks
RegisterNUICallback("changeCam", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        MoveTuningCamera(vehicle, data.type)
    end
    cb("ok")
end)

RegisterNUICallback("requestPartsData", function(data, cb)
    lib.callback("mechanic:server:getShopStock", false, function(stock)
        SendNUIMessage({ action = "setShopStock", stock = stock })
    end)
    cb("ok")
end)

RegisterNUICallback("sendInvoice", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle == 0 then return cb("fail") end

    local passenger = GetPedInVehicleSeat(vehicle, 0) -- Front passenger seat
    if passenger == 0 then 
        exports.qbx_core:Notify("No customer detected in the passenger seat", "error")
        return cb("fail") 
    end

    local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger))
    TriggerServerEvent("mechanic:server:sendInvoice", targetId, data.amount, data.reason)
    cb("ok")
end)

-- Client Side Invoice Receiver
RegisterNetEvent("mechanic:client:receiveInvoice", function(data)
    local alert = lib.alertDialog({
        header = "Service Invoice: " .. data.shopName,
        content = ("You have been billed **$%s** for: \n*%s*"):format(data.amount, data.reason),
        centered = true,
        cancel = true,
        labels = {
            confirm = "Pay Now",
            cancel = "Decline"
        }
    })

    if alert == "confirm" then
        TriggerServerEvent("mechanic:server:payInvoice", data)
    end
end)

RegisterNUICallback("orderPart", function(data, cb)
    TriggerServerEvent("mechanic:server:orderPart", data.part)
    cb("ok")
end)

RegisterNUICallback("withdrawFunds", function(data, cb)
    TriggerServerEvent("mechanic:server:withdrawMoney", data.amount)
    cb("ok")
end)