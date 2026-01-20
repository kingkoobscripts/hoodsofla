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

Config.ShowroomCoords = vector4(-215.5, -1320.5, 30.5, 120.0)

Config.Parts = {
    ["engine_block"] = { label = "Engine Block", price = 2500, description = "Essential for engine rebuilds" },
    ["brake_pads"] = { label = "Ceramic Brake Pads", price = 450, description = "High performance stopping power" },
    ["turbo_kit"] = { label = "Stage 1 Turbo Kit", price = 8000, description = "Increased induction for forced air" },
    ["suspension_kit"] = { label = "Lowering Springs", price = 1200, description = "Better handling and stance" }
}

Config.Prices = {
    performance = 5000,
    cosmetic = 1200,
    paint = 800
}