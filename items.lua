--[[
    ============================================
    MECHANICXDEALER - OX_INVENTORY ITEMS SETUP
    ============================================
    
    You need to add these items to your ox_inventory for the tablets to work.
    
    ============================================
    OPTION 1: Add to ox_inventory/data/items.lua
    ============================================
    
    Open: resources/[ox]/ox_inventory/data/items.lua
    Add the following items to the table:
    
    ['mtablet'] = {
        label = 'Mechanic Tablet',
        weight = 500,
        stack = false,
        close = true,
        description = 'A tablet used by mechanics to manage work orders and tuning.',
        client = {
            image = 'tablet.png',
        }
    },
    
    ['atablet'] = {
        label = 'Admin Tablet',
        weight = 500,
        stack = false,
        close = true,
        description = 'A tablet with administrator access to manage shop operations.',
        client = {
            image = 'tablet.png',
        }
    },
    
    ['dtablet'] = {
        label = 'Dealership Tablet',
        weight = 500,
        stack = false,
        close = true,
        description = 'A tablet to browse and purchase vehicles from the dealership.',
        client = {
            image = 'tablet.png',
        }
    },
    
    ============================================
    OPTION 2: SQL Insert (if using database items)
    ============================================
    
    Run this SQL in your database:
    
    INSERT INTO `items` (`name`, `label`, `weight`, `close`, `description`) VALUES
        ('mtablet', 'Mechanic Tablet', 500, 1, 'A tablet used by mechanics to manage work orders and tuning.'),
        ('atablet', 'Admin Tablet', 500, 1, 'A tablet with administrator access to manage shop operations.'),
        ('dtablet', 'Dealership Tablet', 500, 1, 'A tablet to browse and purchase vehicles from the dealership.');
    
    ============================================
    OPTION 3: Give items for testing
    ============================================
    
    In F8 console or server console:
    
    /giveitem [player_id] mtablet 1
    /giveitem [player_id] atablet 1
    /giveitem [player_id] dtablet 1
    
    Or use ox_inventory command:
    /additem [player_id] mtablet 1
    
    ============================================
    MECHANIC JOB SETUP (QBX Core)
    ============================================
    
    Add this job to qbx_core/shared/jobs.lua:
    
    ['mechanic'] = {
        label = 'Mechanic',
        defaultDuty = true,
        offDutyPay = false,
        grades = {
            [0] = { name = 'Trainee', payment = 50 },
            [1] = { name = 'Mechanic', payment = 75 },
            [2] = { name = 'Senior Mechanic', payment = 100 },
            [3] = { name = 'Shop Manager', payment = 150, isboss = true },
            [4] = { name = 'Owner', payment = 200, isboss = true },
        },
    },
    
    ============================================
    DATABASE SETUP
    ============================================
    
    The resource automatically creates these tables on first start:
    - mechanic_shops
    - mechanic_logs  
    - economy_tuning
    - dealership_vehicles
    - vehicle_engines
    - vehicle_financing
    - vehicle_performance
    
    To create a default shop, run this SQL:
    
    INSERT INTO `mechanic_shops` (`name`, `owner`, `balance`, `employees`) VALUES
    ('bennys', 'System', 50000, '[]');
    
]]--

-- This file is documentation only
-- The actual item registration happens via ox_inventory:usedItem event in server/main.lua
return {}
