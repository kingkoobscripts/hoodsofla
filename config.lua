Config = {}

Config.TaxRate = 0.15 
Config.InvoiceExpiry = 60 
Config.Debug = true -- Enable debug prints and zone visualization
Config.RequireMechanicJob = false -- Set to true to require mechanic job to use tablet

-- Showroom Spawn Coords
Config.ShowroomCoords = vector4(-215.54, -1328.21, 30.89, 270.0)

-- ==========================================
-- TABLET ITEMS (ox_inventory items)
-- ==========================================
Config.Tablets = {
    mechanic = "mtablet",      -- Mechanic Tablet - opens mechanic UI
    admin = "atablet",         -- Admin Tablet - opens admin UI
    dealership = "dtablet"     -- Dealership Tablet - opens dealership UI
}

-- ==========================================
-- CUSTOMER ORDER LOCATIONS (Blips & Markers)
-- One blip per shop, multiple bays per shop
-- ==========================================
Config.MechanicShops = {
    ["bennys"] = {
        label = "Benny's Original Motorworks",
        blipCoords = vector3(-211.55, -1324.55, 30.89),
        blip = {
            sprite = 446,
            color = 47, -- Orange
            scale = 0.85,
            display = 4
        },
        bays = {
            {
                coords = vector3(-211.55, -1324.55, 30.89),
                radius = 5.0,
                label = "Bay 1"
            },
            {
                coords = vector3(-222.38, -1330.08, 30.89),
                radius = 5.0,
                label = "Bay 2"
            },
            {
                coords = vector3(-205.82, -1312.56, 30.89),
                radius = 5.0,
                label = "Front Lot"
            }
        }
    },
    ["lsc_downtown"] = {
        label = "LS Customs Downtown",
        blipCoords = vector3(-356.09, -132.44, 39.01),
        blip = {
            sprite = 446,
            color = 5, -- Yellow
            scale = 0.85,
            display = 4
        },
        bays = {
            {
                coords = vector3(-356.09, -132.44, 39.01),
                radius = 5.0,
                label = "Bay 1"
            },
            {
                coords = vector3(-337.36, -136.92, 39.01),
                radius = 5.0,
                label = "Bay 2"
            }
        }
    },
    ["lsc_airport"] = {
        label = "LS Customs Airport",
        blipCoords = vector3(-1155.0, -2007.18, 13.18),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.85,
            display = 4
        },
        bays = {
            {
                coords = vector3(-1155.0, -2007.18, 13.18),
                radius = 5.0,
                label = "Bay 1"
            }
        }
    },
    ["lsc_lamesa"] = {
        label = "LS Customs La Mesa",
        blipCoords = vector3(731.87, -1088.82, 22.17),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.85,
            display = 4
        },
        bays = {
            {
                coords = vector3(731.87, -1088.82, 22.17),
                radius = 5.0,
                label = "Bay 1"
            },
            {
                coords = vector3(724.72, -1073.54, 22.17),
                radius = 5.0,
                label = "Bay 2"
            }
        }
    },
    ["harmony"] = {
        label = "Harmony LS Customs",
        blipCoords = vector3(1175.04, 2640.21, 37.75),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.85,
            display = 4
        },
        bays = {
            {
                coords = vector3(1175.04, 2640.21, 37.75),
                radius = 5.0,
                label = "Bay 1"
            }
        }
    },
    ["paleto"] = {
        label = "Paleto Bay LS Customs",
        blipCoords = vector3(110.99, 6626.39, 31.79),
        blip = {
            sprite = 446,
            color = 5,
            scale = 0.85,
            display = 4
        },
        bays = {
            {
                coords = vector3(110.99, 6626.39, 31.79),
                radius = 5.0,
                label = "Bay 1"
            }
        }
    }
}

-- ==========================================
-- DEALERSHIP LOCATION (Blip & Marker)
-- ==========================================
Config.DealershipLocation = {
    coords = vector3(-215.54, -1328.21, 30.89),
    label = "Premium Deluxe Motorsport",
    blip = {
        sprite = 523,  -- Car dealership
        color = 2,     -- Green
        scale = 0.9,
        display = 4
    }
}

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
    wheels = 2000,
    engine_swap = 10000,
    body_kit = 3500,
    interior = 2500
}

-- ==========================================
-- PERFORMANCE PARTS
-- ==========================================
Config.Parts = {
    -- Engine Parts
    ["engine_part"] = { label = "Engine Block", price = 2500, item = "engine_part", category = "engine" },
    ["engine_stage1"] = { label = "Stage 1 Engine Upgrade", price = 5000, item = "engine_stage1", category = "engine" },
    ["engine_stage2"] = { label = "Stage 2 Engine Upgrade", price = 10000, item = "engine_stage2", category = "engine" },
    ["engine_stage3"] = { label = "Stage 3 Engine Upgrade", price = 20000, item = "engine_stage3", category = "engine" },
    ["engine_stage4"] = { label = "Stage 4 Race Engine", price = 35000, item = "engine_stage4", category = "engine" },
    
    -- Turbo Parts
    ["turbo_part"] = { label = "Stage 1 Turbo Kit", price = 8000, item = "turbo_part", category = "turbo" },
    ["turbo_stage2"] = { label = "Stage 2 Twin Turbo", price = 15000, item = "turbo_stage2", category = "turbo" },
    ["turbo_stage3"] = { label = "Stage 3 Quad Turbo", price = 25000, item = "turbo_stage3", category = "turbo" },
    
    -- Supercharger Parts
    ["supercharger_stage1"] = { label = "Stage 1 Supercharger", price = 12000, item = "supercharger_stage1", category = "supercharger" },
    ["supercharger_stage2"] = { label = "Stage 2 Supercharger", price = 22000, item = "supercharger_stage2", category = "supercharger" },
    
    -- ★★★ DUAL SUPERCHARGER TURBO KIT (BEST ENGINE MOD) ★★★
    ["dual_supercharger_turbo"] = { 
        label = "Dual Supercharger Turbo Kit", 
        price = 75000, 
        item = "dual_supercharger_turbo", 
        category = "ultimate",
        description = "The ultimate forced induction setup - combines twin turbos with dual superchargers for instant boost and top-end power",
        stats = {
            horsepower = "+450 HP",
            torque = "+380 TQ",
            boost = "32 PSI",
            weight = "+85 lbs"
        },
        requirements = { "engine_stage3", "transmission_stage2", "cooling_stage2" }, -- Must have these installed first
        incompatible = { "turbo_stage3", "supercharger_stage2", "nitrous_stage2" } -- Can't use with these
    },
    
    -- Brake Parts
    ["brake_part"] = { label = "Ceramic Brake Pads", price = 450, item = "brake_part", category = "brakes" },
    ["brake_stage1"] = { label = "Stage 1 Brake Kit", price = 1500, item = "brake_stage1", category = "brakes" },
    ["brake_stage2"] = { label = "Stage 2 Racing Brakes", price = 3500, item = "brake_stage2", category = "brakes" },
    ["brake_stage3"] = { label = "Stage 3 Carbon Ceramic", price = 8000, item = "brake_stage3", category = "brakes" },
    
    -- Transmission Parts  
    ["transmission_part"] = { label = "High-Torque Gears", price = 1500, item = "transmission_part", category = "transmission" },
    ["transmission_stage1"] = { label = "Stage 1 Short Throw", price = 3000, item = "transmission_stage1", category = "transmission" },
    ["transmission_stage2"] = { label = "Stage 2 Close Ratio", price = 6000, item = "transmission_stage2", category = "transmission" },
    ["transmission_stage3"] = { label = "Stage 3 Sequential", price = 15000, item = "transmission_stage3", category = "transmission" },
    ["transmission_stage4"] = { label = "Stage 4 DCT Race", price = 25000, item = "transmission_stage4", category = "transmission" },
    
    -- Suspension Parts
    ["suspension_part"] = { label = "Sport Suspension", price = 1200, item = "suspension_part", category = "suspension" },
    ["suspension_stage1"] = { label = "Stage 1 Lowering Kit", price = 2500, item = "suspension_stage1", category = "suspension" },
    ["suspension_stage2"] = { label = "Stage 2 Coilovers", price = 5000, item = "suspension_stage2", category = "suspension" },
    ["suspension_stage3"] = { label = "Stage 3 Air Ride", price = 12000, item = "suspension_stage3", category = "suspension" },
    ["suspension_stage4"] = { label = "Stage 4 Active Suspension", price = 20000, item = "suspension_stage4", category = "suspension" },
    
    -- Exhaust Parts
    ["exhaust_stage1"] = { label = "Stage 1 Cat-Back", price = 2000, item = "exhaust_stage1", category = "exhaust" },
    ["exhaust_stage2"] = { label = "Stage 2 Headers", price = 4000, item = "exhaust_stage2", category = "exhaust" },
    ["exhaust_stage3"] = { label = "Stage 3 Full System", price = 8000, item = "exhaust_stage3", category = "exhaust" },
    ["exhaust_stage4"] = { label = "Stage 4 Titanium Race", price = 15000, item = "exhaust_stage4", category = "exhaust" },
    
    -- Nitrous
    ["nitrous_stage1"] = { label = "Stage 1 Nitrous (50 shot)", price = 5000, item = "nitrous_stage1", category = "nitrous" },
    ["nitrous_stage2"] = { label = "Stage 2 Nitrous (100 shot)", price = 10000, item = "nitrous_stage2", category = "nitrous" },
    ["nitrous_stage3"] = { label = "Stage 3 Nitrous (200 shot)", price = 20000, item = "nitrous_stage3", category = "nitrous" },
    ["nitrous_refill"] = { label = "Nitrous Refill", price = 500, item = "nitrous_refill", category = "nitrous" },
    
    -- Armor
    ["armor_stage1"] = { label = "Stage 1 Armor (20%)", price = 3000, item = "armor_stage1", category = "armor" },
    ["armor_stage2"] = { label = "Stage 2 Armor (40%)", price = 6000, item = "armor_stage2", category = "armor" },
    ["armor_stage3"] = { label = "Stage 3 Armor (60%)", price = 12000, item = "armor_stage3", category = "armor" },
    ["armor_stage4"] = { label = "Stage 4 Armor (80%)", price = 20000, item = "armor_stage4", category = "armor" },
    ["armor_stage5"] = { label = "Stage 5 Armor (100%)", price = 35000, item = "armor_stage5", category = "armor" },
    
    -- ECU/Tuning
    ["ecu_stage1"] = { label = "Stage 1 ECU Flash", price = 2000, item = "ecu_stage1", category = "ecu" },
    ["ecu_stage2"] = { label = "Stage 2 ECU Tune", price = 5000, item = "ecu_stage2", category = "ecu" },
    ["ecu_stage3"] = { label = "Stage 3 Race ECU", price = 12000, item = "ecu_stage3", category = "ecu" },
    ["standalone_ecu"] = { label = "Standalone ECU", price = 25000, item = "standalone_ecu", category = "ecu" },
    
    -- Cooling System
    ["cooling_stage1"] = { label = "Stage 1 Intercooler", price = 2500, item = "cooling_stage1", category = "cooling" },
    ["cooling_stage2"] = { label = "Stage 2 Full Cooling Kit", price = 6000, item = "cooling_stage2", category = "cooling" },
    ["cooling_stage3"] = { label = "Stage 3 Race Cooling", price = 12000, item = "cooling_stage3", category = "cooling" },
    
    -- Fuel System
    ["fuel_stage1"] = { label = "Stage 1 Fuel Pump", price = 1500, item = "fuel_stage1", category = "fuel" },
    ["fuel_stage2"] = { label = "Stage 2 Injectors", price = 4000, item = "fuel_stage2", category = "fuel" },
    ["fuel_stage3"] = { label = "Stage 3 E85 Conversion", price = 8000, item = "fuel_stage3", category = "fuel" },
    
    -- Drivetrain
    ["clutch_stage1"] = { label = "Stage 1 Performance Clutch", price = 2000, item = "clutch_stage1", category = "drivetrain" },
    ["clutch_stage2"] = { label = "Stage 2 Twin Disc Clutch", price = 5000, item = "clutch_stage2", category = "drivetrain" },
    ["diff_stage1"] = { label = "Stage 1 Limited Slip Diff", price = 3500, item = "diff_stage1", category = "drivetrain" },
    ["diff_stage2"] = { label = "Stage 2 Welded Diff", price = 2000, item = "diff_stage2", category = "drivetrain" },
    ["driveshaft_carbon"] = { label = "Carbon Fiber Driveshaft", price = 4500, item = "driveshaft_carbon", category = "drivetrain" },
    
    -- Drivetrain Conversion Kits
    ["drivetrain_rwd_kit"] = { label = "FWD to RWD Conversion Kit", price = 45000, item = "drivetrain_rwd_kit", category = "drivetrain_conversion" },
    ["drivetrain_awd_kit"] = { label = "RWD to AWD Conversion Kit", price = 65000, item = "drivetrain_awd_kit", category = "drivetrain_conversion" },
    ["drivetrain_fwd_awd_kit"] = { label = "FWD to AWD Conversion Kit", price = 70000, item = "drivetrain_fwd_awd_kit", category = "drivetrain_conversion" },
    ["drivetrain_rwd_delete"] = { label = "AWD to RWD Conversion Kit", price = 35000, item = "drivetrain_rwd_delete", category = "drivetrain_conversion" },
    
    -- ProCharger
    ["procharger"] = { label = "ProCharger Centrifugal SC", price = 18000, item = "procharger", category = "supercharger" },
    
    -- Cosmetic Items
    ["paint_can"] = { label = "Industrial Paint", price = 100, item = "paint_can", category = "cosmetic" },
    ["body_panel"] = { label = "Carbon Fiber Panel", price = 800, item = "body_panel", category = "cosmetic" }
}

-- ==========================================
-- COSMETIC / VISUAL MODS
-- ==========================================
Config.CosmeticMods = {
    -- Spoilers (Mod ID: 0)
    spoilers = {
        { id = 0, label = "Stock Spoiler", price = 0 },
        { id = 1, label = "Low Spoiler", price = 1500 },
        { id = 2, label = "Mid Spoiler", price = 2000 },
        { id = 3, label = "High Spoiler", price = 2500 },
        { id = 4, label = "GT Wing", price = 5000 },
        { id = 5, label = "Carbon GT Wing", price = 8000 },
        { id = 6, label = "Race Wing", price = 12000 },
        { id = 7, label = "Drift Wing", price = 6000 },
        { id = 8, label = "Competition Wing", price = 15000 }
    },
    
    -- Front Bumpers (Mod ID: 1)
    front_bumpers = {
        { id = 0, label = "Stock Bumper", price = 0 },
        { id = 1, label = "Sport Bumper", price = 2500 },
        { id = 2, label = "Aggressive Bumper", price = 3500 },
        { id = 3, label = "Wide Body Front", price = 8000 },
        { id = 4, label = "Carbon Front", price = 6000 },
        { id = 5, label = "Race Bumper", price = 10000 },
        { id = 6, label = "Track Bumper", price = 12000 },
        { id = 7, label = "Custom Splitter", price = 4500 }
    },
    
    -- Rear Bumpers (Mod ID: 2)
    rear_bumpers = {
        { id = 0, label = "Stock Rear", price = 0 },
        { id = 1, label = "Sport Rear", price = 2500 },
        { id = 2, label = "Diffuser Rear", price = 4000 },
        { id = 3, label = "Wide Body Rear", price = 8000 },
        { id = 4, label = "Carbon Rear", price = 6000 },
        { id = 5, label = "Race Rear", price = 10000 }
    },
    
    -- Side Skirts (Mod ID: 3)
    side_skirts = {
        { id = 0, label = "Stock Skirts", price = 0 },
        { id = 1, label = "Sport Skirts", price = 2000 },
        { id = 2, label = "Wide Skirts", price = 3500 },
        { id = 3, label = "Carbon Skirts", price = 5000 },
        { id = 4, label = "Race Skirts", price = 6500 },
        { id = 5, label = "Competition Skirts", price = 8000 }
    },
    
    -- Hoods (Mod ID: 7)
    hoods = {
        { id = 0, label = "Stock Hood", price = 0 },
        { id = 1, label = "Vented Hood", price = 3000 },
        { id = 2, label = "Carbon Fiber Hood", price = 6000 },
        { id = 3, label = "Ram Air Hood", price = 5000 },
        { id = 4, label = "Cowl Hood", price = 4500 },
        { id = 5, label = "Race Hood", price = 8000 },
        { id = 6, label = "Supercharger Hood", price = 7000 }
    },
    
    -- Fenders (Mod ID: 8/9)
    fenders = {
        { id = 0, label = "Stock Fenders", price = 0 },
        { id = 1, label = "Flared Fenders", price = 4000 },
        { id = 2, label = "Wide Body Fenders", price = 8000 },
        { id = 3, label = "Carbon Fenders", price = 6000 },
        { id = 4, label = "Race Fenders", price = 10000 },
        { id = 5, label = "Competition Fenders", price = 12000 }
    },
    
    -- Roof (Mod ID: 10)
    roof = {
        { id = 0, label = "Stock Roof", price = 0 },
        { id = 1, label = "Carbon Roof", price = 5000 },
        { id = 2, label = "Roof Scoop", price = 3500 },
        { id = 3, label = "Roof Rack", price = 2500 },
        { id = 4, label = "Light Bar Roof", price = 4000 }
    },
    
    -- Grilles (Mod ID: 6)
    grilles = {
        { id = 0, label = "Stock Grille", price = 0 },
        { id = 1, label = "Mesh Grille", price = 1500 },
        { id = 2, label = "Honeycomb Grille", price = 2000 },
        { id = 3, label = "Carbon Grille", price = 3500 },
        { id = 4, label = "Delete Grille", price = 1000 }
    },
    
    -- Exhaust Tips
    exhaust_tips = {
        { id = 0, label = "Stock Tips", price = 0 },
        { id = 1, label = "Dual Tips", price = 800 },
        { id = 2, label = "Quad Tips", price = 1500 },
        { id = 3, label = "Big Bore Tips", price = 1200 },
        { id = 4, label = "Titanium Tips", price = 2500 },
        { id = 5, label = "Carbon Tips", price = 3000 }
    },
    
    -- Roll Cage (Mod ID: 5)
    roll_cage = {
        { id = 0, label = "No Cage", price = 0 },
        { id = 1, label = "Half Cage", price = 4000 },
        { id = 2, label = "Full Cage", price = 8000 },
        { id = 3, label = "Competition Cage", price = 12000 }
    },
    
    -- Mirrors
    mirrors = {
        { id = 0, label = "Stock Mirrors", price = 0 },
        { id = 1, label = "Carbon Mirrors", price = 2000 },
        { id = 2, label = "M3 Style Mirrors", price = 2500 },
        { id = 3, label = "Aero Mirrors", price = 3000 },
        { id = 4, label = "Delete Mirrors", price = 500 }
    },
    
    -- Trunk/Boot
    trunk = {
        { id = 0, label = "Stock Trunk", price = 0 },
        { id = 1, label = "Carbon Trunk", price = 4000 },
        { id = 2, label = "Duckbill Trunk", price = 3500 },
        { id = 3, label = "Race Trunk", price = 5000 }
    }
}

-- ==========================================
-- INTERIOR MODS
-- ==========================================
Config.InteriorMods = {
    -- Seats
    seats = {
        { id = 0, label = "Stock Seats", price = 0 },
        { id = 1, label = "Sport Seats", price = 3000 },
        { id = 2, label = "Racing Buckets", price = 6000 },
        { id = 3, label = "Carbon Buckets", price = 10000 },
        { id = 4, label = "FIA Race Seats", price = 15000 }
    },
    
    -- Steering Wheels
    steering = {
        { id = 0, label = "Stock Wheel", price = 0 },
        { id = 1, label = "Sport Wheel", price = 1500 },
        { id = 2, label = "Flat Bottom", price = 2000 },
        { id = 3, label = "Quick Release", price = 2500 },
        { id = 4, label = "Racing Wheel", price = 3500 },
        { id = 5, label = "Carbon Racing", price = 5000 }
    },
    
    -- Shift Knobs
    shifter = {
        { id = 0, label = "Stock Shifter", price = 0 },
        { id = 1, label = "Short Shifter", price = 800 },
        { id = 2, label = "Weighted Knob", price = 500 },
        { id = 3, label = "Carbon Knob", price = 1200 },
        { id = 4, label = "Sequential Lever", price = 3000 }
    },
    
    -- Gauges
    gauges = {
        { id = 0, label = "Stock Gauges", price = 0 },
        { id = 1, label = "Digital Display", price = 2500 },
        { id = 2, label = "Racing Gauges", price = 4000 },
        { id = 3, label = "Full Digital Dash", price = 8000 }
    },
    
    -- Pedals
    pedals = {
        { id = 0, label = "Stock Pedals", price = 0 },
        { id = 1, label = "Aluminum Pedals", price = 600 },
        { id = 2, label = "Racing Pedals", price = 1200 },
        { id = 3, label = "Adjustable Pedals", price = 2000 }
    },
    
    -- Harnesses
    harness = {
        { id = 0, label = "Stock Belt", price = 0 },
        { id = 1, label = "4-Point Harness", price = 1500 },
        { id = 2, label = "5-Point Harness", price = 2500 },
        { id = 3, label = "6-Point Harness", price = 4000 }
    }
}

-- ==========================================
-- LIGHTING MODS
-- ==========================================
Config.LightingMods = {
    -- Headlights (Mod ID: 22)
    headlights = {
        { id = -1, label = "Stock Lights", price = 0 },
        { id = 0, label = "Xenon Lights", price = 2000 },
        { id = 1, label = "LED Lights", price = 3500 }
    },
    
    -- Neon Kits
    neon = {
        { id = 0, label = "No Neon", price = 0 },
        { id = 1, label = "Front Neon", price = 800 },
        { id = 2, label = "Rear Neon", price = 800 },
        { id = 3, label = "Side Neon", price = 1200 },
        { id = 4, label = "Full Neon Kit", price = 3000 }
    },
    
    -- Neon Colors
    neon_colors = {
        { color = {255, 255, 255}, label = "White", price = 500 },
        { color = {255, 0, 0}, label = "Red", price = 500 },
        { color = {0, 255, 0}, label = "Green", price = 500 },
        { color = {0, 0, 255}, label = "Blue", price = 500 },
        { color = {255, 255, 0}, label = "Yellow", price = 500 },
        { color = {255, 0, 255}, label = "Pink", price = 500 },
        { color = {0, 255, 255}, label = "Cyan", price = 500 },
        { color = {255, 128, 0}, label = "Orange", price = 500 },
        { color = {128, 0, 255}, label = "Purple", price = 500 }
    }
}

-- ==========================================
-- WHEELS & TIRES
-- ==========================================
Config.WheelTypes = {
    { id = 0, label = "Sport", price = 2000 },
    { id = 1, label = "Muscle", price = 2000 },
    { id = 2, label = "Lowrider", price = 2500 },
    { id = 3, label = "SUV", price = 2000 },
    { id = 4, label = "Offroad", price = 2500 },
    { id = 5, label = "Tuner", price = 3000 },
    { id = 6, label = "Biker", price = 1500 },
    { id = 7, label = "High End", price = 5000 },
    { id = 8, label = "Benny's Original", price = 8000 },
    { id = 9, label = "Benny's Bespoke", price = 10000 },
    { id = 10, label = "Racing", price = 6000 },
    { id = 11, label = "Street", price = 3500 }
}

Config.TireMods = {
    { id = 0, label = "Stock Tires", price = 0 },
    { id = 1, label = "Low Profile", price = 1500 },
    { id = 2, label = "Semi-Slick", price = 2500 },
    { id = 3, label = "Drag Radials", price = 3500 },
    { id = 4, label = "Full Slicks", price = 5000 },
    { id = 5, label = "Drift Tires", price = 3000 },
    { id = 6, label = "Offroad Tires", price = 2500 },
    { id = 7, label = "Bulletproof Tires", price = 8000 }
}

Config.TireSmokeColors = {
    { color = {255, 255, 255}, label = "White Smoke", price = 500 },
    { color = {0, 0, 0}, label = "Black Smoke", price = 500 },
    { color = {255, 0, 0}, label = "Red Smoke", price = 800 },
    { color = {0, 255, 0}, label = "Green Smoke", price = 800 },
    { color = {0, 0, 255}, label = "Blue Smoke", price = 800 },
    { color = {255, 255, 0}, label = "Yellow Smoke", price = 800 },
    { color = {255, 0, 255}, label = "Pink Smoke", price = 800 },
    { color = {0, 255, 255}, label = "Cyan Smoke", price = 800 },
    { color = {255, 128, 0}, label = "Orange Smoke", price = 800 },
    { color = {128, 0, 255}, label = "Purple Smoke", price = 800 }
}

-- ==========================================
-- PART COMPATIBILITY SYSTEM
-- ==========================================
-- Defines which parts CANNOT be used together
Config.PartIncompatibility = {
    -- Dual supercharger turbo conflicts
    ["dual_supercharger_turbo"] = {
        "turbo_stage3",           -- Can't have quad turbo with dual supercharger turbo
        "supercharger_stage2",    -- Already has superchargers built in
        "nitrous_stage2",         -- Too much boost for nitrous
        "nitrous_stage3"
    },
    
    -- Turbo conflicts
    ["turbo_stage3"] = {
        "supercharger_stage1",    -- Choose one: turbo or supercharger
        "supercharger_stage2",
        "dual_supercharger_turbo"
    },
    ["turbo_stage2"] = {
        "supercharger_stage2"     -- Heavy supercharger not compatible with twin turbo
    },
    
    -- Supercharger conflicts
    ["supercharger_stage2"] = {
        "turbo_stage2",
        "turbo_stage3",
        "dual_supercharger_turbo"
    },
    
    -- Suspension conflicts
    ["suspension_stage3"] = {      -- Air ride
        "suspension_stage4"        -- Can't have air ride AND active suspension
    },
    ["suspension_stage4"] = {
        "suspension_stage3"
    },
    
    -- Diff conflicts
    ["diff_stage2"] = {            -- Welded diff
        "diff_stage1"              -- LSD not compatible with welded
    },
    
    -- Exhaust conflicts (each stage replaces previous)
    ["exhaust_stage4"] = {
        "exhaust_stage1",
        "exhaust_stage2",
        "exhaust_stage3"
    }
}

-- Defines parts that REQUIRE other parts to be installed first
Config.PartRequirements = {
    ["dual_supercharger_turbo"] = {
        required = {"engine_stage3", "transmission_stage2", "cooling_stage2"},
        message = "Dual Supercharger Turbo requires: Stage 3 Engine, Stage 2 Transmission, Stage 2 Cooling"
    },
    ["turbo_stage3"] = {
        required = {"engine_stage2", "cooling_stage1"},
        message = "Quad Turbo requires: Stage 2 Engine, Stage 1 Cooling"
    },
    ["turbo_stage2"] = {
        required = {"engine_stage1"},
        message = "Twin Turbo requires: Stage 1 Engine"
    },
    ["supercharger_stage2"] = {
        required = {"engine_stage2", "cooling_stage1"},
        message = "Stage 2 Supercharger requires: Stage 2 Engine, Stage 1 Cooling"
    },
    ["nitrous_stage2"] = {
        required = {"nitrous_stage1", "fuel_stage1"},
        message = "Stage 2 Nitrous requires: Stage 1 Nitrous, Stage 1 Fuel System"
    },
    ["nitrous_stage3"] = {
        required = {"nitrous_stage2", "fuel_stage2", "cooling_stage1"},
        message = "Stage 3 Nitrous requires: Stage 2 Nitrous, Stage 2 Fuel, Stage 1 Cooling"
    },
    ["engine_stage4"] = {
        required = {"engine_stage3", "cooling_stage2"},
        message = "Stage 4 Engine requires: Stage 3 Engine, Stage 2 Cooling"
    },
    ["transmission_stage4"] = {
        required = {"transmission_stage3", "clutch_stage2"},
        message = "Stage 4 DCT requires: Stage 3 Sequential, Stage 2 Clutch"
    },
    ["standalone_ecu"] = {
        required = {"ecu_stage3"},
        message = "Standalone ECU requires: Stage 3 Race ECU base tune"
    }
}

-- ==========================================
-- MOD ID MAPPINGS (GTA Vehicle Mod IDs)
-- ==========================================
Config.ModRequirements = {
    [11] = "engine_part",      -- Engine
    [12] = "brake_part",       -- Brakes
    [13] = "transmission_part", -- Transmission
    [15] = "suspension_part",  -- Suspension
    [18] = "turbo_part"        -- Turbo
}

-- ==========================================
-- ENGINE SWAP OPTIONS
-- ==========================================
Config.EngineBlocks = {
    ["v8_crate"] = { 
        label = "V8 Crate Engine", 
        item = "engine_v8", 
        price = 15000,
        stats = { hp = 180, torque = 150 },
        compatible_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20 } -- All gas vehicles
    },
    ["v12_racing"] = { 
        label = "V12 Racing Block", 
        item = "engine_v12", 
        price = 45000,
        stats = { hp = 350, torque = 280 },
        compatible_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20 } -- All gas vehicles
    },
    ["electric_tesla"] = { 
        label = "E-Performance Kit", 
        item = "engine_electric", 
        price = 60000,
        stats = { hp = 400, torque = 500, instant_torque = true },
        compatible_classes = {}, -- Only for electric vehicles (checked by model)
        electric_only = true -- Special flag for electric-only vehicles
    },
    ["v10_supercar"] = {
        label = "V10 Supercar Engine",
        item = "engine_v10",
        price = 55000,
        stats = { hp = 320, torque = 260 },
        compatible_classes = { 6, 7 } -- Super, Sports only
    },
    ["i6_turbo"] = {
        label = "Inline-6 Turbo",
        item = "engine_i6",
        price = 25000,
        stats = { hp = 220, torque = 200 },
        compatible_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20 }
    },
    ["rb26_swap"] = {
        label = "RB26DETT Swap",
        item = "engine_rb26",
        price = 35000,
        stats = { hp = 280, torque = 240, legendary = true },
        compatible_classes = { 2, 3, 4, 5, 6, 7, 8 } -- Sports, Coupes, Sedans, Compacts, Super, Sports, Muscle
    },
    ["2jz_swap"] = {
        label = "2JZ-GTE Swap",
        item = "engine_2jz",
        price = 32000,
        stats = { hp = 320, torque = 320, legendary = true },
        compatible_classes = { 2, 3, 4, 5, 6, 7, 8 } -- Sports, Coupes, Sedans, Compacts, Super, Sports, Muscle
    },
    ["ls_swap"] = {
        label = "LS3 V8 Swap",
        item = "engine_ls3",
        price = 28000,
        stats = { hp = 430, torque = 420 },
        compatible_classes = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 17, 18, 19, 20 } -- Almost all vehicles
    },
    ["rotary_swap"] = {
        label = "13B Rotary Swap",
        item = "engine_rotary",
        price = 22000,
        stats = { hp = 255, torque = 159, high_rev = true },
        compatible_classes = { 2, 3, 4, 5, 6, 7 } -- Lighter vehicles only
    }
}

-- ==========================================
-- ELECTRIC VEHICLE MODELS
-- Only these models can receive the electric engine upgrade
-- ==========================================
Config.ElectricVehicles = {
    -- Tesla-style / Electric models
    "raiden",       -- Coil Raiden
    "cyclone",      -- Coil Cyclone
    "voltic",       -- Coil Voltic
    "voltic2",      -- Rocket Voltic
    "neon",         -- Pfister Neon
    "tezeract",     -- Pegassi Tezeract
    "imorgon",      -- Overflod Imorgon
    "dilettante",   -- Karin Dilettante
    "dilettante2",  -- Karin Dilettante (Security)
    "surge",        -- Cheval Surge
    "khamelion",    -- Hijak Khamelion
    "caddy",        -- Caddy (Golf Cart)
    "caddy2",       -- Caddy (Golf Cart)
    "caddy3",       -- Caddy (Golf Cart)
    "airtug",       -- Airtug
    -- Add more electric models as needed
}

-- Vehicle Class Reference:
-- 0 = Compacts, 1 = Sedans, 2 = SUVs, 3 = Coupes, 4 = Muscle, 5 = Sports Classics
-- 6 = Sports, 7 = Super, 8 = Motorcycles, 9 = Off-road, 10 = Industrial
-- 11 = Utility, 12 = Vans, 13 = Cycles, 14 = Boats, 15 = Helicopters
-- 16 = Planes, 17 = Service, 18 = Emergency, 19 = Military, 20 = Commercial

-- ==========================================
-- UPGRADE TIER SYSTEM (Prevents Stacking)
-- Higher tiers REPLACE lower tiers, not stack
-- ==========================================
Config.UpgradeTiers = {
    engine = { 
        tiers = { "engine_stage1", "engine_stage2", "engine_stage3", "engine_stage4" },
        gta_mod_id = 11  -- GTA engine mod
    },
    turbo = { 
        tiers = { "turbo_part", "turbo_stage2", "turbo_stage3" },
        gta_mod_id = 18  -- GTA turbo toggle
    },
    supercharger = { 
        tiers = { "supercharger_stage1", "supercharger_stage2" },
        gta_mod_id = nil  -- Custom handling
    },
    transmission = { 
        tiers = { "transmission_part", "transmission_stage1", "transmission_stage2", "transmission_stage3", "transmission_stage4" },
        gta_mod_id = 13
    },
    brakes = { 
        tiers = { "brake_part", "brake_stage1", "brake_stage2", "brake_stage3" },
        gta_mod_id = 12
    },
    suspension = { 
        tiers = { "suspension_part", "suspension_stage1", "suspension_stage2", "suspension_stage3", "suspension_stage4" },
        gta_mod_id = 15
    },
    exhaust = { 
        tiers = { "exhaust_stage1", "exhaust_stage2", "exhaust_stage3", "exhaust_stage4" },
        gta_mod_id = 4
    },
    nitrous = { 
        tiers = { "nitrous_stage1", "nitrous_stage2", "nitrous_stage3" },
        gta_mod_id = nil
    },
    ecu = { 
        tiers = { "ecu_stage1", "ecu_stage2", "ecu_stage3", "standalone_ecu" },
        gta_mod_id = nil
    },
    cooling = { 
        tiers = { "cooling_stage1", "cooling_stage2", "cooling_stage3" },
        gta_mod_id = nil
    },
    fuel = { 
        tiers = { "fuel_stage1", "fuel_stage2", "fuel_stage3" },
        gta_mod_id = nil
    },
    clutch = { 
        tiers = { "clutch_stage1", "clutch_stage2" },
        gta_mod_id = nil
    },
    diff = { 
        tiers = { "diff_stage1", "diff_stage2" },
        gta_mod_id = nil
    },
    armor = { 
        tiers = { "armor_stage1", "armor_stage2", "armor_stage3", "armor_stage4", "armor_stage5" },
        gta_mod_id = 16
    }
}

-- ==========================================
-- DRIVETRAIN SYSTEM (AWD/RWD/FWD)
-- ==========================================
Config.DrivetrainTypes = {
    ["fwd"] = {
        label = "Front-Wheel Drive",
        description = "Power to front wheels - better traction, understeer tendency",
        stats = {
            traction_bonus = 1.05,           -- 5% better base traction
            acceleration_mult = 0.95,        -- Slightly slower acceleration
            top_speed_mult = 0.98,           -- 2% top speed loss
            handling_mult = 1.03,            -- 3% better handling
            drift_difficulty = 1.4,          -- 40% harder to drift
            launch_traction = 1.10,          -- 10% better launch grip
            fuel_efficiency = 1.10,          -- 10% better fuel economy
            weight_offset = -50              -- Lighter (no rear diff/driveshaft)
        }
    },
    ["rwd"] = {
        label = "Rear-Wheel Drive",
        description = "Power to rear wheels - best for power/drift, oversteer tendency",
        stats = {
            traction_bonus = 0.95,           -- 5% less traction
            acceleration_mult = 1.08,        -- 8% better acceleration
            top_speed_mult = 1.05,           -- 5% top speed gain
            handling_mult = 1.00,            -- Neutral handling
            drift_difficulty = 0.7,          -- 30% easier to drift
            launch_traction = 0.85,          -- 15% worse launch (wheelspin)
            fuel_efficiency = 0.95,          -- 5% worse fuel
            weight_offset = 0
        }
    },
    ["awd"] = {
        label = "All-Wheel Drive",
        description = "Power to all wheels - best traction, heaviest system",
        stats = {
            traction_bonus = 1.18,           -- 18% better traction
            acceleration_mult = 1.12,        -- 12% better acceleration
            top_speed_mult = 0.95,           -- 5% top speed loss (parasitic)
            handling_mult = 1.05,            -- 5% better handling
            drift_difficulty = 1.2,          -- 20% harder to drift
            launch_traction = 1.25,          -- 25% better launch grip
            fuel_efficiency = 0.82,          -- 18% worse fuel economy
            weight_offset = 150              -- Heavier system
        }
    }
}

-- Drivetrain conversion kits
Config.DrivetrainConversions = {
    ["fwd_to_rwd"] = {
        label = "FWD to RWD Conversion",
        price = 45000,
        item = "drivetrain_rwd_kit",
        from = "fwd",
        to = "rwd",
        install_time = 30000,  -- 30 seconds
        requirements = { "transmission_stage2" },
        description = "Complete rear-wheel drive conversion with custom driveshaft"
    },
    ["rwd_to_awd"] = {
        label = "RWD to AWD Conversion",
        price = 65000,
        item = "drivetrain_awd_kit",
        from = "rwd",
        to = "awd",
        install_time = 45000,  -- 45 seconds
        requirements = { "transmission_stage3", "diff_stage1" },
        description = "Full AWD system with transfer case and front differential"
    },
    ["fwd_to_awd"] = {
        label = "FWD to AWD Conversion",
        price = 70000,
        item = "drivetrain_fwd_awd_kit",
        from = "fwd",
        to = "awd",
        install_time = 50000,
        requirements = { "transmission_stage2", "diff_stage1" },
        description = "Complete AWD conversion from FWD platform"
    },
    ["awd_to_rwd"] = {
        label = "AWD to RWD Conversion",
        price = 35000,
        item = "drivetrain_rwd_delete",
        from = "awd",
        to = "rwd",
        install_time = 25000,
        requirements = {},
        description = "Remove front drive components for weight savings"
    }
}

-- Default drivetrain by vehicle class
Config.DefaultDrivetrains = {
    [0] = "fwd",   -- Compacts
    [1] = "fwd",   -- Sedans
    [2] = "awd",   -- SUVs
    [3] = "rwd",   -- Coupes
    [4] = "rwd",   -- Muscle
    [5] = "rwd",   -- Sports Classics
    [6] = "rwd",   -- Sports
    [7] = "awd",   -- Super (mixed, default AWD)
    [8] = "rwd",   -- Motorcycles
    [9] = "awd",   -- Off-road
    [10] = "rwd",  -- Industrial
    [11] = "rwd",  -- Utility
    [12] = "fwd",  -- Vans
}

-- ==========================================
-- FORCED INDUCTION SYSTEM
-- Turbo vs Supercharger - Different characteristics
-- ==========================================
Config.ForcedInduction = {
    ["turbo"] = {
        label = "Turbocharger",
        description = "Exhaust-driven, power builds with RPM",
        characteristics = "Lag at low RPM, massive top-end power",
        stats = {
            -- RPM-based power delivery (multipliers)
            low_rpm_boost = 1.03,      -- 0-3000 RPM: 3% boost
            mid_rpm_boost = 1.12,      -- 3000-6000 RPM: 12% boost
            high_rpm_boost = 1.25,     -- 6000+ RPM: 25% boost
            
            -- Characteristics
            spool_time = 1.2,          -- Seconds to full boost
            boost_threshold_rpm = 0.4, -- RPM % where boost kicks in
            heat_generation = 1.25,    -- 25% more heat
            fuel_consumption = 1.15,   -- 15% more fuel
            
            -- Top speed impact
            top_speed_mult = 1.08,     -- 8% top speed increase
            
            -- Sound
            blow_off_valve = true,
            turbo_whine = true
        }
    },
    ["turbo_stage2"] = {
        label = "Twin Turbo",
        description = "Two smaller turbos for reduced lag",
        characteristics = "Better response, even more top-end",
        stats = {
            low_rpm_boost = 1.08,
            mid_rpm_boost = 1.18,
            high_rpm_boost = 1.35,
            spool_time = 0.8,
            boost_threshold_rpm = 0.3,
            heat_generation = 1.35,
            fuel_consumption = 1.22,
            top_speed_mult = 1.14,
            blow_off_valve = true,
            turbo_whine = true
        }
    },
    ["turbo_stage3"] = {
        label = "Quad Turbo",
        description = "Four turbos - sequential compound setup",
        characteristics = "Minimal lag, extreme power across all RPM",
        stats = {
            low_rpm_boost = 1.15,
            mid_rpm_boost = 1.28,
            high_rpm_boost = 1.45,
            spool_time = 0.5,
            boost_threshold_rpm = 0.2,
            heat_generation = 1.50,
            fuel_consumption = 1.35,
            top_speed_mult = 1.22,
            blow_off_valve = true,
            turbo_whine = true,
            requires_cooling = "cooling_stage2"
        }
    },
    ["supercharger_stage1"] = {
        label = "Supercharger",
        description = "Belt-driven, instant power delivery",
        characteristics = "Linear power, no lag, parasitic loss at high RPM",
        stats = {
            -- Supercharger has INSTANT power but less top-end
            low_rpm_boost = 1.18,      -- 18% instant boost from idle
            mid_rpm_boost = 1.20,      -- 20% mid-range
            high_rpm_boost = 1.12,     -- Only 12% at high RPM (parasitic drag)
            
            -- Characteristics
            spool_time = 0.0,          -- INSTANT response
            boost_threshold_rpm = 0.0, -- Works from idle
            heat_generation = 1.10,    -- Less heat than turbo
            fuel_consumption = 1.20,   -- 20% more fuel (engine-driven)
            
            -- Top speed (parasitic loss)
            top_speed_mult = 1.03,     -- Only 3% top speed (belt drag)
            
            -- Sound
            supercharger_whine = true,
            blow_off_valve = false
        }
    },
    ["supercharger_stage2"] = {
        label = "Stage 2 Supercharger",
        description = "Larger pulley, more boost",
        characteristics = "More power everywhere, especially low-mid",
        stats = {
            low_rpm_boost = 1.25,
            mid_rpm_boost = 1.28,
            high_rpm_boost = 1.15,
            spool_time = 0.0,
            boost_threshold_rpm = 0.0,
            heat_generation = 1.15,
            fuel_consumption = 1.28,
            top_speed_mult = 1.05,
            supercharger_whine = true,
            blow_off_valve = false
        }
    },
    ["procharger"] = {
        label = "ProCharger (Centrifugal)",
        description = "Centrifugal supercharger - best of both worlds",
        characteristics = "Belt-driven turbo behavior",
        stats = {
            low_rpm_boost = 1.10,
            mid_rpm_boost = 1.22,
            high_rpm_boost = 1.30,
            spool_time = 0.3,
            boost_threshold_rpm = 0.25,
            heat_generation = 1.12,
            fuel_consumption = 1.18,
            top_speed_mult = 1.10,
            supercharger_whine = true,
            blow_off_valve = true
        }
    },
    ["dual_supercharger_turbo"] = {
        label = "Dual Supercharger + Turbo",
        description = "Ultimate setup - superchargers + turbos",
        characteristics = "Instant power AND top-end monster",
        stats = {
            low_rpm_boost = 1.30,
            mid_rpm_boost = 1.40,
            high_rpm_boost = 1.50,
            spool_time = 0.0,
            boost_threshold_rpm = 0.0,
            heat_generation = 1.60,
            fuel_consumption = 1.45,
            top_speed_mult = 1.25,
            supercharger_whine = true,
            turbo_whine = true,
            blow_off_valve = true,
            requires_cooling = "cooling_stage3",
            requires_fuel = "fuel_stage3"
        }
    }
}

-- ==========================================
-- PERFORMANCE MODIFIERS (Non-Stacking)
-- Only the HIGHEST tier in each category applies
-- ==========================================
Config.PerformanceModifiers = {
    -- ENGINE UPGRADES (top_speed_mult, acceleration_mult)
    ["engine_stage1"] = { top_speed = 1.03, acceleration = 1.05, torque = 1.04 },
    ["engine_stage2"] = { top_speed = 1.08, acceleration = 1.12, torque = 1.10 },
    ["engine_stage3"] = { top_speed = 1.15, acceleration = 1.22, torque = 1.18 },
    ["engine_stage4"] = { top_speed = 1.22, acceleration = 1.32, torque = 1.28 },
    
    -- TRANSMISSION (acceleration focused)
    ["transmission_part"] = { acceleration = 1.02, shift_speed = 1.05 },
    ["transmission_stage1"] = { acceleration = 1.05, shift_speed = 1.12 },
    ["transmission_stage2"] = { acceleration = 1.10, shift_speed = 1.22 },
    ["transmission_stage3"] = { acceleration = 1.18, shift_speed = 1.35 },
    ["transmission_stage4"] = { acceleration = 1.25, shift_speed = 1.50 },
    
    -- BRAKES (braking power)
    ["brake_part"] = { braking = 1.05 },
    ["brake_stage1"] = { braking = 1.12 },
    ["brake_stage2"] = { braking = 1.22 },
    ["brake_stage3"] = { braking = 1.35 },
    
    -- SUSPENSION (handling & traction)
    ["suspension_part"] = { handling = 1.03, traction = 1.02 },
    ["suspension_stage1"] = { handling = 1.08, traction = 1.05 },
    ["suspension_stage2"] = { handling = 1.15, traction = 1.10 },
    ["suspension_stage3"] = { handling = 1.22, traction = 1.15 },
    ["suspension_stage4"] = { handling = 1.30, traction = 1.20 },
    
    -- EXHAUST (small power gains)
    ["exhaust_stage1"] = { top_speed = 1.01, acceleration = 1.02 },
    ["exhaust_stage2"] = { top_speed = 1.02, acceleration = 1.04 },
    ["exhaust_stage3"] = { top_speed = 1.04, acceleration = 1.06 },
    ["exhaust_stage4"] = { top_speed = 1.06, acceleration = 1.08 },
    
    -- ECU (overall optimization)
    ["ecu_stage1"] = { top_speed = 1.02, acceleration = 1.03, fuel_efficiency = 0.95 },
    ["ecu_stage2"] = { top_speed = 1.05, acceleration = 1.07, fuel_efficiency = 0.90 },
    ["ecu_stage3"] = { top_speed = 1.08, acceleration = 1.12, fuel_efficiency = 0.85 },
    ["standalone_ecu"] = { top_speed = 1.12, acceleration = 1.18, fuel_efficiency = 0.78 },
    
    -- COOLING (allows higher power mods)
    ["cooling_stage1"] = { heat_capacity = 1.20 },
    ["cooling_stage2"] = { heat_capacity = 1.45 },
    ["cooling_stage3"] = { heat_capacity = 1.75 },
    
    -- FUEL (required for high boost)
    ["fuel_stage1"] = { max_boost = 1.10 },
    ["fuel_stage2"] = { max_boost = 1.25 },
    ["fuel_stage3"] = { max_boost = 1.45 },
    
    -- CLUTCH (launch & shift)
    ["clutch_stage1"] = { launch = 1.08, shift_speed = 1.05 },
    ["clutch_stage2"] = { launch = 1.18, shift_speed = 1.12 },
    
    -- DIFFERENTIAL
    ["diff_stage1"] = { traction = 1.08, drift_factor = 1.15 },  -- LSD
    ["diff_stage2"] = { traction = 1.15, drift_factor = 1.45, handling = 0.92 },  -- Welded
    
    -- WEIGHT REDUCTION
    ["carbon_hood"] = { acceleration = 1.02, weight = -45 },
    ["carbon_trunk"] = { acceleration = 1.01, weight = -30 },
    ["carbon_body"] = { acceleration = 1.06, top_speed = 1.02, weight = -150 },
    ["roll_cage"] = { weight = 85, safety = 1.50 },
    
    -- NITROUS (temporary boost - handled separately)
    ["nitrous_stage1"] = { boost_power = 1.20, duration = 3.0, cooldown = 30.0 },
    ["nitrous_stage2"] = { boost_power = 1.35, duration = 4.0, cooldown = 25.0 },
    ["nitrous_stage3"] = { boost_power = 1.55, duration = 5.0, cooldown = 20.0 },
    
    -- TIRES (handling & traction)
    ["tires_sport"] = { traction = 1.05, handling = 1.03 },
    ["tires_semi_slick"] = { traction = 1.12, handling = 1.05, wet_penalty = 0.80 },
    ["tires_slick"] = { traction = 1.25, handling = 1.08, wet_penalty = 0.55 },
    ["tires_drag"] = { traction = 1.40, handling = 0.85, top_speed = 0.97 },
    ["tires_drift"] = { traction = 0.75, drift_factor = 1.65 }
}

-- ==========================================
-- AERODYNAMICS SYSTEM
-- ==========================================
Config.Aerodynamics = {
    -- Spoilers (GTA mod ID: 0)
    spoilers = {
        [0] = { label = "Stock", downforce = 1.00, drag = 1.00 },
        [1] = { label = "Low Spoiler", downforce = 1.05, drag = 1.01 },
        [2] = { label = "Mid Spoiler", downforce = 1.10, drag = 1.02 },
        [3] = { label = "High Spoiler", downforce = 1.18, drag = 1.04 },
        [4] = { label = "GT Wing", downforce = 1.28, drag = 1.08, top_speed_penalty = 0.97 },
        [5] = { label = "Carbon GT Wing", downforce = 1.32, drag = 1.06, top_speed_penalty = 0.98 },
        [6] = { label = "Race Wing", downforce = 1.40, drag = 1.10, top_speed_penalty = 0.95 }
    },
    -- Front splitters/bumpers affect front downforce
    front_aero = {
        [0] = { label = "Stock", downforce = 1.00 },
        [1] = { label = "Sport Bumper", downforce = 1.03 },
        [2] = { label = "Aggressive", downforce = 1.06 },
        [3] = { label = "Track Splitter", downforce = 1.12 },
        [4] = { label = "Carbon Splitter", downforce = 1.15 }
    }
}

-- ==========================================
-- TIRE COMPOUND SYSTEM
-- ==========================================
Config.TireCompounds = {
    ["stock"] = {
        label = "Stock Tires",
        traction = 1.00,
        handling = 1.00,
        wear_rate = 1.00,
        wet_performance = 1.00,
        temp_range = { min = 20, optimal = 60, max = 100 }
    },
    ["sport"] = {
        label = "Sport Tires",
        traction = 1.08,
        handling = 1.05,
        wear_rate = 1.15,
        wet_performance = 0.95,
        temp_range = { min = 30, optimal = 75, max = 110 }
    },
    ["semi_slick"] = {
        label = "Semi-Slick",
        traction = 1.18,
        handling = 1.10,
        wear_rate = 1.35,
        wet_performance = 0.70,
        temp_range = { min = 45, optimal = 90, max = 120 }
    },
    ["slick"] = {
        label = "Racing Slicks",
        traction = 1.35,
        handling = 1.18,
        wear_rate = 1.60,
        wet_performance = 0.40,
        temp_range = { min = 60, optimal = 100, max = 130 }
    },
    ["drag"] = {
        label = "Drag Radials",
        traction = 1.50,
        handling = 0.80,
        wear_rate = 2.00,
        wet_performance = 0.50,
        temp_range = { min = 50, optimal = 85, max = 115 }
    },
    ["drift"] = {
        label = "Drift Tires",
        traction = 0.70,
        handling = 1.05,
        wear_rate = 1.80,
        wet_performance = 0.85,
        temp_range = { min = 25, optimal = 70, max = 105 }
    },
    ["offroad"] = {
        label = "Off-Road Tires",
        traction = 0.90,  -- Less on pavement
        handling = 0.92,
        wear_rate = 0.80,
        wet_performance = 1.10,
        offroad_bonus = 1.40,
        temp_range = { min = 10, optimal = 50, max = 90 }
    }
}