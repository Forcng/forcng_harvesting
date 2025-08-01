local ESX = exports['es_extended']:getSharedObject()
local PlayerData = {}
local isHarvesting = false

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

local function GetPlayerJob()
    if not PlayerData.job then
        PlayerData = ESX.GetPlayerData()
    end
    return PlayerData.job and PlayerData.job.name or "unemployed"
end

local function StartHarvesting(zone)
    isHarvesting = true
    local playerPed = PlayerPedId()

    local animDict = "pickup_object"
    local animName = "pickup_low"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(10) end

    FreezeEntityPosition(playerPed, true)
    TriggerServerEvent("forcng:harvestStart", zone.id)

    CreateThread(function()
        while isHarvesting do
            TaskPlayAnim(playerPed, animDict, animName, 8.0, -8.0, -1, 0, 0, false, false, false)
            Wait(2000)
        end
    end)

    local ok = lib.progressCircle({
        duration = zone.harvestTime,
        label = "Harvesting " .. zone.label .. "...",
        useWhileDead = false,
        canCancel = false,
        position = 'bottom',
        disable = {
            move = true,
            car = true,
        }
    })

    isHarvesting = false
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)

    if ok then
        TriggerServerEvent("forcng:harvest", zone.id)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, zone in pairs(Config.HarvestingLocations) do
            if GetPlayerJob() == zone.jobRequired then
                local dist = #(playerCoords - zone.Coordinates)

                if dist <= 20.0 then
                    DrawMarker(1, zone.Coordinates.x, zone.Coordinates.y, zone.Coordinates.z - 1.0,
                        0, 0, 0, 0, 0, 0,
                        1.5, 1.5, 0.3, 0, 255, 0, 150,
                        false, true, 2, false, nil, nil, false)
                end

                if dist <= zone.radius then
                    ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to harvest " .. zone.label)
                    if IsControlJustReleased(0, 38) and not isHarvesting then
                        StartHarvesting(zone)
                    end
                end
            end
        end
    end
end)