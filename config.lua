Config = {}

Config.TaxRate = 0.15 
Config.InvoiceExpiry = 60 

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
    -- Performance Items (Must be in inventory to install)
    ["engine_block"] = { label = "Engine Block", price = 2500, item = "engine_part" },
    ["brake_pads"] = { label = "Ceramic Brake Pads", price = 450, item = "brake_part" },
    ["transmission_gear"] = { label = "High-Torque Gears", price = 1500, item = "transmission_part" },
    ["turbo_kit"] = { label = "Stage 1 Turbo Kit", price = 8000, item = "turbo_part" },
    
    -- Cosmetic Items (Optional: Can be set to require items or just cash)
    ["paint_can"] = { label = "Industrial Paint", price = 100, item = "paint_can" }
}

-- Mapping Mod IDs to required items
Config.ModRequirements = {
    [11] = "engine_part",
    [12] = "brake_part",
    [13] = "transmission_part",
    [15] = "suspension_part",
    [18] = "turbo_part"
}