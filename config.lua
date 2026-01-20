Config = {}

Config.TaxRate = 0.15 
Config.InvoiceExpiry = 60 

-- Showroom Spawn Coords
Config.ShowroomCoords = vector4(-215.54, -1328.21, 30.89, 270.0)

Config.Shops = {
    ["Benny's Motorworks"] = {
        coords = vector3(-211.55, -1324.55, 30.89),
        radius = 15.0,
        label = "Benny's Main Shop"
    }
}

Config.Prices = {
    performance = 5000,
    cosmetic = 1200,
    paint = 800,
    livery = 1500,
    wheels = 2000
}

Config.Parts = {
    -- Performance Items (Ordered via Wholesale)
    ["engine_part"] = { label = "Engine Block", price = 2500, item = "engine_part", category = "performance" },
    ["brake_part"] = { label = "Ceramic Brake Pads", price = 450, item = "brake_part", category = "performance" },
    ["transmission_part"] = { label = "High-Torque Gears", price = 1500, item = "transmission_part", category = "performance" },
    ["turbo_part"] = { label = "Stage 1 Turbo Kit", price = 8000, item = "turbo_part", category = "performance" },
    ["suspension_part"] = { label = "Sport Suspension", price = 1200, item = "suspension_part", category = "performance" },
    
    -- Cosmetic Items
    ["paint_can"] = { label = "Industrial Paint", price = 100, item = "paint_can", category = "cosmetic" },
    ["body_panel"] = { label = "Carbon Fiber Panel", price = 800, item = "body_panel", category = "cosmetic" }
}

-- Mapping Mod IDs to required items in inventory
Config.ModRequirements = {
    [11] = "engine_part",
    [12] = "brake_part",
    [13] = "transmission_part",
    [15] = "suspension_part",
    [18] = "turbo_part"
}

-- Engine Swap Items (Wholesale only)
Config.EngineBlocks = {
    ["v8_crate"] = { label = "V8 Crate Engine", item = "engine_v8", price = 15000 },
    ["v12_racing"] = { label = "V12 Racing Block", item = "engine_v12", price = 25000 },
    ["electric_tesla"] = { label = "E-Performance Kit", item = "engine_electric", price = 20000 }
}