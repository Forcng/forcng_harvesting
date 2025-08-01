Config = Config or {}

Config.HarvestingLocations = {
    {
        id = 1,
        label = "Water",
        drugName = "water", -- Spawn Code Of Drug
        Coordinates = vector3(-612.8409, 208.7998, 74.1816),
        radius = 1.5,
        jobRequired = "unemployed", -- Job Required To See Harvesting Location -- if you want no job just set it to jobRequired = false
        harvestTime = 5000, -- Time in milliseconds to harvest (5 Seconds )
        harvestAmount = math.random(2, 4),
    },

    -- Example Of No Job Required Config
    {
        id = 2,
        label = "Water",
        drugName = "water", -- Spawn Code Of Drug
        Coordinates = vector3(-612.8409, 208.7998, 74.1816),
        radius = 1.5,
        jobRequired = false, -- Job Required To See Harvesting Location -- if you want no job just set it to jobRequired = false
        harvestTime = 5000, -- Time in milliseconds to harvest (5 Seconds)
        harvestAmount = math.random(2, 4),
    },
}