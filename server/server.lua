local ESX = exports['es_extended']:getSharedObject()

local lastHarvestStart = {}

AddEventHandler('playerDropped', function()
    lastHarvestStart[source] = nil
end)

RegisterNetEvent("forcng:harvestStart", function(zoneId)
    local src = source
    if not Config.HarvestingLocations[zoneId] then return end
    lastHarvestStart[src] = { t = os.time(), zoneId = zoneId }
end)

RegisterNetEvent("forcng:harvest", function(zoneId)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local start = lastHarvestStart[src]
    if not start or start.zoneId ~= zoneId or (os.time() - start.t) > 20 then
        DropPlayer(src, "WARNING: Exploit detected.")
        return
    end
    lastHarvestStart[src] = nil

    local zone = Config.HarvestingLocations[zoneId]
    if not zone then return end

    if xPlayer.job?.name ~= zone.jobRequired then
        return
    end

    local item = zone.drugName
    local amount = zone.harvestAmount

    -- Only drugs that are inside Config.HarvestingLocations
    local allowed = false
    for _, v in pairs(Config.HarvestingLocations) do
        if v.drugName == item then
            allowed = true
            break
        end
    end

    if not allowed then
        return
    end

    xPlayer.addInventoryItem(item, amount)
end)