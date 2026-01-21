-- ============================================
-- MECHANICXDEALER - DATABASE SETUP
-- ============================================
-- Run this SQL file in your database to set up everything

-- ============================================
-- 1. MECHANIC SHOPS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `mechanic_shops` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50) UNIQUE NOT NULL,
    `owner` VARCHAR(100) DEFAULT 'System',
    `balance` INT DEFAULT 50000,
    `employees` JSON DEFAULT '[]',
    `settings` JSON DEFAULT '{}',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO `mechanic_shops` (`name`, `owner`, `balance`, `employees`) VALUES
('bennys', 'System', 50000, '[]')
ON DUPLICATE KEY UPDATE `name` = `name`;

-- ============================================
-- 2. ECONOMY TUNING TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `economy_tuning` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `inflation` FLOAT DEFAULT 1.00,
    `shop_mult` FLOAT DEFAULT 1.00,
    `vehicle_mult` FLOAT DEFAULT 1.00,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default economy values if table is empty
INSERT INTO `economy_tuning` (`inflation`, `shop_mult`, `vehicle_mult`)
SELECT 1.00, 1.00, 1.00 FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `economy_tuning` LIMIT 1);

-- ============================================
-- 3. VEHICLE FINANCING TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `vehicle_financing` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `citizenid` VARCHAR(50) NOT NULL,
    `vehicle` VARCHAR(50) NOT NULL,
    `total_price` INT NOT NULL,
    `down_payment` INT NOT NULL,
    `term_length` INT NOT NULL,
    `monthly_payment` INT NOT NULL,
    `remaining_balance` INT NOT NULL,
    `trade_in_value` INT DEFAULT 0,
    `payments_made` INT DEFAULT 0,
    `status` VARCHAR(20) DEFAULT 'active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX `idx_citizenid` (`citizenid`),
    INDEX `idx_status` (`status`)
);

-- ============================================
-- 4. VEHICLE PERFORMANCE TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `vehicle_performance` (
    `plate` VARCHAR(15) PRIMARY KEY,
    `installed_parts` JSON DEFAULT '[]',
    `drivetrain` VARCHAR(10) DEFAULT 'rwd',
    `forced_induction` VARCHAR(50) DEFAULT NULL,
    `tire_compound` VARCHAR(20) DEFAULT 'stock',
    `performance_stats` JSON DEFAULT '{}',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================
-- 5. VEHICLE ENGINES TABLE (Engine Swaps)
-- ============================================
CREATE TABLE IF NOT EXISTS `vehicle_engines` (
    `plate` VARCHAR(15) PRIMARY KEY,
    `engine_type` VARCHAR(50) DEFAULT 'v6_stock',
    `nitro_level` INT DEFAULT 0,
    `reliability` FLOAT DEFAULT 1.0,
    `metadata` JSON DEFAULT '{}',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================
-- 6. MECHANIC LOGS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `mechanic_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `shop_name` VARCHAR(50),
    `mechanic_name` VARCHAR(100),
    `plate` VARCHAR(15),
    `details` JSON,
    `cost` INT,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 7. CUSTOMER ORDERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS `mechanic_orders` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `shop_name` VARCHAR(50) NOT NULL,
    `customer_citizenid` VARCHAR(50) NOT NULL,
    `customer_name` VARCHAR(100),
    `vehicle_plate` VARCHAR(15),
    `vehicle_model` VARCHAR(50),
    `order_type` VARCHAR(30) DEFAULT 'repair',
    `details` JSON DEFAULT '{}',
    `total_cost` INT DEFAULT 0,
    `status` VARCHAR(20) DEFAULT 'pending',
    `assigned_mechanic` VARCHAR(50) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `completed_at` TIMESTAMP NULL,
    INDEX `idx_shop` (`shop_name`),
    INDEX `idx_customer` (`customer_citizenid`),
    INDEX `idx_status` (`status`)
);

-- ============================================
-- 8. ADD ITEMS TO OX_INVENTORY (if using database items)
-- ============================================
-- Note: Only run this if your ox_inventory uses database for items
-- Comment out if you're using items.lua file instead

-- INSERT INTO `items` (`name`, `label`, `weight`, `close`, `description`) VALUES
--     ('mtablet', 'Mechanic Tablet', 500, 1, 'A tablet used by mechanics to manage work orders and tuning.'),
--     ('atablet', 'Admin Tablet', 500, 1, 'A tablet with administrator access to manage shop operations.'),
--     ('dtablet', 'Dealership Tablet', 500, 1, 'A tablet to browse and purchase vehicles from the dealership.')
-- ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);

-- ============================================
-- 3. ADD SAMPLE VEHICLES TO DEALERSHIP
-- ============================================
INSERT INTO `dealership_vehicles` (`model`, `label`, `price`, `enabled`, `tuned`, `topspeed`) VALUES
-- Sports Cars
('t20', 'Progen T20', 2200000, 1, 0, 195),
('zentorno', 'Pegassi Zentorno', 2725000, 1, 0, 190),
('adder', 'Truffade Adder', 1000000, 1, 0, 185),
('entityxf', 'Overflod Entity XF', 795000, 1, 0, 190),
('turismor', 'Grotti Turismo R', 500000, 1, 0, 185),
('osiris', 'Pegassi Osiris', 1950000, 1, 0, 190),
('reaper', 'Pegassi Reaper', 1595000, 1, 0, 185),
('fmj', 'Vapid FMJ', 1750000, 1, 0, 190),
('italigtb', 'Progen Itali GTB', 1189000, 1, 0, 185),
('nero', 'Truffade Nero', 1440000, 1, 0, 195),

-- Tuned 300mph+ Vehicles
('t20tuned', 'Progen T20 (Tuned 300mph)', 5500000, 1, 1, 300),
('neroxtuned', 'Truffade Nero X (Tuned 300mph)', 6000000, 1, 1, 300),

-- Muscle Cars
('dominator', 'Vapid Dominator', 35000, 1, 0, 145),
('dominator2', 'Vapid Dominator GTX', 725000, 1, 0, 150),
('dominator3', 'Vapid Dominator GTT', 975000, 1, 0, 155),
('gauntlet', 'Bravado Gauntlet', 32000, 1, 0, 140),
('gauntlet2', 'Bravado Gauntlet Classic', 615000, 1, 0, 145),
('gauntlet3', 'Bravado Gauntlet Hellfire', 745000, 1, 0, 155),
('buffalo', 'Bravado Buffalo', 35000, 1, 0, 140),
('buffalo2', 'Bravado Buffalo S', 96000, 1, 0, 145),
('sabregt', 'Declasse Sabre Turbo', 15000, 1, 0, 135),
('vigero', 'Declasse Vigero', 21000, 1, 0, 135),

-- Tuned Muscle (300mph)
('dominatortuned', 'Vapid Dominator (Tuned 300mph)', 2500000, 1, 1, 300),
('dominator3tuned', 'Vapid Dominator GTT (Tuned 300mph)', 3500000, 1, 1, 300),

-- Sedans
('fugitive', 'Cheval Fugitive', 24000, 1, 0, 125),
('tailgater', 'Obey Tailgater', 55000, 1, 0, 130),
('schafter2', 'Benefactor Schafter V12', 116000, 1, 0, 145),
('oracle', 'Übermacht Oracle', 80000, 1, 0, 130),
('oracle2', 'Übermacht Oracle XS', 82000, 1, 0, 132),
('emperor', 'Albany Emperor', 10000, 1, 0, 100),
('stanier', 'Vapid Stanier', 10000, 1, 0, 105),

-- SUVs
('baller', 'Gallivanter Baller', 90000, 1, 0, 125),
('baller2', 'Gallivanter Baller LE', 118000, 1, 0, 130),
('cavalcade', 'Albany Cavalcade', 60000, 1, 0, 115),
('granger', 'Declasse Granger', 35000, 1, 0, 110),
('dubsta', 'Benefactor Dubsta', 110000, 1, 0, 120),
('landstalker', 'Dundreary Landstalker', 58000, 1, 0, 115),

-- Compacts
('blista', 'Dinka Blista', 15000, 1, 0, 105),
('brioso', 'Grotti Brioso R/A', 155000, 1, 0, 115),
('dilettante', 'Karin Dilettante', 25000, 1, 0, 95),
('issi2', 'Weeny Issi', 18000, 1, 0, 100),
('panto', 'Benefactor Panto', 85000, 1, 0, 90),
('prairie', 'Bollokan Prairie', 30000, 1, 0, 105),

-- Coupes
('exemplar', 'Dewbauchee Exemplar', 205000, 1, 0, 140),
('f620', 'Ocelot F620', 80000, 1, 0, 135),
('felon', 'Lampadati Felon', 90000, 1, 0, 130),
('felon2', 'Lampadati Felon GT', 95000, 1, 0, 135),
('jackal', 'Ocelot Jackal', 60000, 1, 0, 130),
('oracle', 'Übermacht Oracle', 80000, 1, 0, 130),
('sentinel', 'Übermacht Sentinel', 95000, 1, 0, 135),
('sentinel2', 'Übermacht Sentinel XS', 60000, 1, 0, 130),
('zion', 'Übermacht Zion', 60000, 1, 0, 130),
('zion2', 'Übermacht Zion Cabrio', 65000, 1, 0, 130),

-- Motorcycles  
('bati', 'Pegassi Bati 801', 15000, 1, 0, 150),
('bati2', 'Pegassi Bati 801RR', 18000, 1, 0, 155),
('akuma', 'Dinka Akuma', 9000, 1, 0, 140),
('double', 'Dinka Double T', 12000, 1, 0, 145),
('hakuchou', 'Shitzu Hakuchou', 82000, 1, 0, 165),
('hakuchou2', 'Shitzu Hakuchou Drag', 976000, 1, 0, 175),
('nemesis', 'Principe Nemesis', 12000, 1, 0, 135),
('pcj', 'Shitzu PCJ-600', 9000, 1, 0, 130),
('ruffian', 'Pegassi Ruffian', 9000, 1, 0, 125),
('sanchez', 'Maibatsu Sanchez', 8000, 1, 0, 95),
('shotaro', 'Nagasaki Shotaro', 2225000, 1, 0, 170)

ON DUPLICATE KEY UPDATE `label` = VALUES(`label`), `price` = VALUES(`price`);

-- ============================================
-- 4. MECHANIC JOB (Add to qbx_core if not exists)
-- ============================================
-- Note: This is for reference - add to qbx_core/shared/jobs.lua manually
/*
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
*/

-- ============================================
-- SETUP COMPLETE!
-- ============================================
-- After running this SQL:
-- 1. Add the mechanic job to qbx_core/shared/jobs.lua
-- 2. Add the tablet items to ox_inventory/data/items.lua
-- 3. Restart your server
-- 4. Use /setjob [id] mechanic 4 to make yourself the owner
-- 5. Give yourself tablets: /giveitem [id] mtablet 1
