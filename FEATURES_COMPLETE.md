# MechanicX Dealership - Complete Feature Implementation Guide

## System Overview

The MechanicX system is a comprehensive mechanics/dealership management system for FiveM. All core features are fully implemented, integrated with the database, and ready for use.

## How to Access the UI

### Opening the Mechanic Tablet
```
/mx mechanic      - Open mechanic shop interface
/mx admin         - Open admin/boss management panel  
/mx dealership    - Open dealership/showroom
/testui           - Test UI visibility (admin only)
/closeui or ESC   - Close any open UI
/customer         - Open customer vehicle designer (in/near vehicle)
```

### Requirements
- Must be in the mechanic job to open mechanic tablet
- Must be job boss/admin to open admin panel
- Commands are admin-restricted by default

## Complete Feature List

### 1. **PERFORMANCE UPGRADES & PARTS** ✅
**Location:** `/mx mechanic` → "Engine" tab

**Features:**
- **Engine Upgrades** - 5 stages of engine tuning
  - Increases horsepower and acceleration
  - Prices range from $1,500-$7,500
  - Database persistent

- **Brakes** - 5 upgrade levels
  - Improves braking distance and response
  - Prices scale by level

- **Transmission** - 5 upgrade levels  
  - Improves acceleration and top speed
  - Automatic gear shifting

- **Suspension** - 5 upgrade levels
  - Better handling and cornering
  - Reduced body roll

- **Turbo** - 3 upgrade levels
  - Massive acceleration boost
  - High-end performance mod

**How to Use:**
1. Get in a vehicle
2. Open mechanic tablet (`/mx mechanic`)
3. Go to "Engine" tab
4. Select upgrade category
5. Click upgrade to see stats
6. Click "Install" to apply (requires cash)
7. Changes save to database immediately

---

### 2. **PAINT CUSTOMIZATION** ✅
**Location:** `/mx mechanic` → "Paint" tab

**Features:**
- **32+ Color Palette** - Pre-selected colors
- **Custom Hex Colors** - Enter any hex code (#RRGGBB)
- **Primary/Secondary Colors** - Two-tone paint
- **Pearl Colors** - Metallic/pearlescent finishes
- **Liveries** - Pre-designed patterns

**Pricing:**
- Primary color: $500
- Secondary color: $500
- Pearl color: $300
- Livery application: $700

**How to Use:**
1. Select colors from palette OR enter hex codes
2. Click "Preview Paint" to see changes
3. Click "Apply Paint" to finalize
4. Cost deducted from player cash

---

### 3. **WHEEL CUSTOMIZATION** ✅
**Location:** `/mx mechanic` → "Wheels" tab

**Features:**
- **100+ Wheel Types** - Different rim styles
- **Wheel Designs** - Various finishes
- **Wheel Colors** - Custom rim colors
- **Smoke Colors** - Tire smoke customization
- **Tire Compounds** - Different tire types (Street, Sport, Racing, etc.)

**Pricing:**
- Wheel change: $800-$2,000
- Custom color: $300
- Smoke color: $250

**How to Use:**
1. Select wheel type from list
2. Choose wheel design
3. Pick rim color (or custom hex)
4. Select tire compound
5. Click "Apply Wheels"

---

### 4. **COSMETIC MODS** ✅
**Location:** `/mx mechanic` → "Cosmetics" tab

**Features:**
- **Bumpers** - Front and rear options
- **Side Skirts** - Body side modifications
- **Spoilers** - Aerodynamic add-ons (13 types)
- **Hoods** - Engine cover styles
- **Fenders** - Reinforced options
- **Grilles** - Custom intake designs
- **Doors** - Replacement panels
- **Roofs** - Removable/carbon options

**How to Use:**
1. Select cosmetic category
2. Preview before applying
3. Click "Apply" to install
4. Cost is deducted, part is saved

---

### 5. **INTERIOR MODS** ✅
**Location:** `/mx mechanic` → "Interior" tab

**Features:**
- **Seats** - 7 interior styles
- **Steering Wheels** - Custom wheel options
- **Gear Shift Knobs** - Transmission knob styles
- **Gauge Clusters** - Dashboard upgrades
- **Custom Trim** - Interior panels

**Pricing:** $400-$1,500 per modification

**How to Use:**
1. Browse interior options
2. Click "Preview" to see inside vehicle
3. Click "Apply Interior" to confirm purchase
4. Changes persist in database

---

### 6. **LIGHTING MODS** ✅
**Location:** `/mx mechanic` → "Lighting" tab

**Features:**
- **Neon Colors** - Underglow customization (15+ colors)
- **Headlight Colors** - Custom headlight tints
- **Taillight Colors** - Rear light customization
- **Light Patterns** - Animated light sequences
- **Xenon Bulbs** - Bright white headlights

**Pricing:** $200-$800 per lighting upgrade

**How to Use:**
1. Select lighting type
2. Choose color from palette
3. Click "Apply Lighting"
4. Color saves immediately

---

### 7. **TUNING/PERFORMANCE PRESETS** ✅
**Location:** `/mx mechanic` → "Tuning" tab

**Pre-Built Presets:**
- **Stock** - Factory settings
- **Sport** - Balanced performance (20% improvement)
- **Drift** - High handling, low stability
- **Race** - Maximum acceleration and speed
- **Drag** - Instant acceleration, top speed focus
- **Eco** - Fuel efficient, reduced performance

**Custom Tuning:**
- **Power Slider** (0-100%)
- **Torque Slider** (0-100%)
- **Boost Slider** (0-100%)
- **Rev Limiter** (0-100%)
- **Launch Control** (0-100%)
- **AFR (Air-Fuel Ratio)** - Fine-tune fuel mixture
- **Suspension** (0-100%)
- **Braking** (0-100%)

**How to Use:**
1. Select preset OR manually adjust sliders
2. Click "Apply Preset"
3. Handling values update in real-time
4. Changes persist in database

**Custom Preset Saving:**
- Click "Save Preset" to name and save
- Export preset as JSON file
- Import presets from JSON

---

### 8. **ENGINE SWAP** ✅
**Location:** `/mx mechanic` → "Engine" tab (bottom)

**Available Engines:**
- **V8 Performance** - +100 HP, $15,000
- **Turbo V12** - +150 HP, $25,000
- **Electric Motor** - Clean energy, $30,000
- **Supercharged V6** - +80 HP, $18,000
- **Stock Engine** - Factory default, Free

**Requirements:**
- Must have required item in inventory
- Must have cash
- Vehicle must be in mechanic shop zone

**How to Use:**
1. Go to "Engine" tab
2. Scroll to "Engine Swap" section
3. Select engine from list
4. Click "Swap Engine"
5. Old engine removed, new installed
6. Can reverse with "Remove Engine"

---

### 9. **DIAGNOSTICS** ✅
**Location:** `/mx mechanic` → "Diagnostics" tab

**Features:**
- **Engine Health Check** - Shows engine condition %
- **Fault Code Reader** - Displays error codes
- **Performance Analysis** - Detailed vehicle stats
- **Damage Report** - Body part damage levels
- **Clear Faults** - Reset diagnostic codes

**How to Use:**
1. Click "Run Diagnostic"
2. System scans engine for faults
3. Displays health percentage
4. Shows any fault codes found
5. Click "Clear Faults" to reset codes

**What It Shows:**
- Engine health (0-100%)
- Transmission status
- Suspension condition
- Brake wear level
- Fault codes if present

---

### 10. **DYNO TESTING** ✅
**Location:** `/mx mechanic` → "Dyno" tab

**Features:**
- **Real-time HP/Torque Measurement**
- **Top Speed Calculation**
- **Power Graph** - Visual performance curve
- **Peak Power Display** - Maximum output values
- **Historical Data** - Track vehicle improvements

**How to Use:**
1. Click "Start Dyno"
2. Vehicle runs through acceleration test (~15 seconds)
3. Real-time HP/Torque displayed on graph
4. Peak values shown at top
5. Click "Stop Dyno" to end test
6. Click "Reset" to clear historical data

**Test Parameters:**
- Automatic throttle simulation
- Variable gear ratios tested
- Environmental factors applied
- Realistic physics calculations

---

### 11. **STAFF MANAGEMENT** ✅
**Location:** `/mx admin` → "Staff" tab (Boss/Admin Only)

**Features:**
- **Hire Staff** - Add employees to shop
  - Assign roles (mechanic, manager, etc.)
  - Set initial salary
  - Database tracked

- **Clock In/Out** - Track work hours
  - Real-time status
  - Work hour logging
  - Automatic shift tracking

- **Fire Staff** - Remove employees
  - Instant termination
  - Clear from roster
  - Logged in system

- **Promote** - Increase staff rank
  - Change job roles
  - Update permissions
  - Salary adjustments

- **Staff List** - View all employees
  - Current status (on duty/off duty)
  - Experience points
  - Performance ratings

**How to Use:**
1. Open admin panel (`/mx admin`)
2. Go to "Staff" tab
3. Click "Add Employee" to hire
4. Enter citizen ID (or nearby player)
5. Click "Fire" to terminate
6. Click "Clock In" to start shift
7. Click "Clock Out" to end shift

---

### 12. **BUSINESS ANALYTICS** ✅
**Location:** `/mx admin` → "Analytics" tab (Boss/Admin Only)

**Displays:**
- **Daily Revenue** - Total income today
- **Popular Upgrades** - Most-purchased mods
- **Success Rate** - Install success percentage
- **Productivity Metrics** - Staff performance
- **Transaction History** - Recent activity log
- **Graph Charts** - Visual data representation

**Metrics Tracked:**
- Total income per day
- Number of installations
- Average job time
- Customer satisfaction (if integrated)
- Staff productivity scores

---

### 13. **CUSTOMER ORDERS** ✅
**Location:** `/mx mechanic` → "Orders" tab

**Features:**
- **View Pending Orders** - Customer service requests
  - Vehicle info
  - Requested work
  - Payment amount
  - Time received

- **Accept Order** - Take customer job
  - Adds to your queue
  - Locks vehicle
  - Starts timer

- **Complete Order** - Finish job
  - Apply all modifications
  - Mark as complete
  - Receive payment

- **Cancel Order** - Decline job
  - Remove from queue
  - Notify customer
  - Free up mechanic

**How to Use:**
1. Open mechanic tablet
2. Go to "Orders" tab
3. View list of pending customer orders
4. Click "Accept" to take job
5. Perform requested upgrades
6. Click "Complete" when done
7. Receive payment automatically

---

### 14. **FINANCE/INVOICING** ✅
**Location:** `/mx mechanic` → "Finance" tab

**Features:**
- **Send Invoice** - Create payment request
  - Specify amount
  - Add description
  - Send to player
  
- **Track Payments** - Monitor received money
  - Invoice history
  - Paid/unpaid status
  - Payment dates

- **Shop Balance** - View business funds
  - Daily income
  - Expenses
  - Net profit

- **Withdrawal** - Owner can withdraw cash
  - Deduct from shop balance
  - Add to personal wallet
  - Logged in system

**How to Use:**
1. Go to "Finance" tab
2. Enter amount for invoice
3. Click "Send Invoice"
4. Track payments received
5. View shop balance at top
6. Click "Withdraw" to take cash

---

## Database Integration

All features are fully integrated with the database. Changes persist across server restarts.

**Key Tables:**
- `player_vehicles` - Vehicle modifications and data
- `vehicle_engines` - Engine swap history
- `vehicle_performance` - Installed performance parts
- `mechanic_shops` - Business data and balances
- `mechanic_logs` - Transaction history
- `mechanic_staff` - Employee records
- `mechanic_inventory` - Parts inventory
- `mechanic_orders` - Customer service orders

## Server Events & Callbacks

All NUI interactions trigger server-side callbacks for validation and persistence:

**Available Callbacks:**
```lua
-- Upgrades
TriggerCallback("mechanic:server:installUpgrade", ...)
TriggerCallback("mechanic:server:removeUpgrade", ...)

-- Paint/Wheels
TriggerCallback("mechanic:server:applyPaint", ...)
TriggerCallback("mechanic:server:applyWheels", ...)

-- Engine
TriggerCallback("mechanic:server:swapEngine", ...)
TriggerCallback("mechanic:server:removeEngine", ...)

-- Diagnostics
TriggerCallback("mechanic:server:runDiagnostic", ...)
TriggerCallback("mechanic:server:clearFaults", ...)

-- Dyno
TriggerCallback("mechanic:server:toggleDyno", ...)

-- Staff (Admin)
TriggerCallback("mechanic:server:clockInStaff", ...)
TriggerCallback("mechanic:server:clockOutStaff", ...)
TriggerCallback("mechanic:server:addEmployee", ...)
TriggerCallback("mechanic:server:removeEmployee", ...)

-- Orders
TriggerCallback("mechanic:server:acceptCustomerOrder", ...)
TriggerCallback("mechanic:server:completeCustomerOrder", ...)
TriggerCallback("mechanic:server:cancelOrder", ...)
```

## Permission System

**Role-Based Access Control (RBAC):**
- **Admin/Owner** - Full access to all features
- **Mechanic** - Can install/modify vehicles
- **Manager** - Can manage staff and orders
- **Customer** - Can request services

**Permission Checks:**
- Server-side validation on all sensitive actions
- Client-side permission mirroring for UX
- Ownership validation for vehicle modifications
- RBAC enforcement for admin actions

## Troubleshooting

### Issue: UI won't open
**Solution:**
1. Check job: `/job` should show "mechanic"
2. Try `/testui` command
3. Check console for errors (F8)
4. Make sure you're not in cutscene

### Issue: Parts not installing
**Solution:**
1. Check inventory: `/inventory`
2. Make sure you have enough cash
3. Vehicle must be accessible (not impounded)
4. Check notification messages for errors

### Issue: Dyno not running
**Solution:**
1. Close other UIs first
2. Make sure vehicle engine is running
3. Vehicle must be in neutral gear
4. Check fuel level

### Issue: Diagnostics showing error
**Solution:**
1. Vehicle must have valid engine
2. Engine must be running
3. Try "Clear Faults" first
4. Restart vehicle

### Issue: Staff changes not saving
**Solution:**
1. Make sure you're boss/admin
2. Check database connection
3. Verify target player is online
4. Check server logs for errors

## Custom Configuration

Edit `config.lua` to customize:
- Shop names and locations
- Upgrade prices and availability
- Color palettes
- Staff roles and permissions
- Order management settings

## Support

For issues or questions:
1. Check console output (F8) for error messages
2. Review server logs
3. Verify all dependencies are installed
4. Check configuration settings

---

**All Features Status: ✅ FULLY FUNCTIONAL AND DATABASE-INTEGRATED**

Version: 1.4.0 | Last Updated: January 2026
