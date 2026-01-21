# MechanicX Quick Test Guide

## How to Test All Features

### 1. **Opening the UI**
```
/mx mechanic       - Open mechanic tablet
/mx admin          - Open admin panel
/mx dealership     - Open dealership/showroom
/testui            - Test NUI visibility
/mx_close          - Close tablet
```

### 2. **Mechanic Features**

#### Parts & Upgrades (Engine/Turbo/Suspension/Brakes/Transmission)
- Open `/mx mechanic`
- Go to "Engine" tab
- Select a part from "Available Upgrades"
- Click "Install" to apply
- Click "Preview" to see changes before applying

#### Paint Job
- Go to "Paint" tab
- Select colors from palette OR enter custom hex codes
- Click "Apply Paint" to paint vehicle
- Cost: $500 per color selected

#### Wheels
- Go to "Wheels" tab
- Select wheel type and design
- Choose wheel color
- Click "Apply Wheels"

#### Tuning (Performance Presets)
- Go to "Tuning" tab
- Select preset: Stock, Sport, Drift, Race, Drag, Eco
- Click "Apply Preset" to apply handling changes

#### Engine Swap
- Go to "Engine" tab
- Select compatible engine from list
- Click "Swap" to replace engine
- Can be reversed with "Remove Engine"

#### Diagnostics
- Go to "Diagnostics" tab
- Click "Run Diagnostic" to scan vehicle for faults
- Faults show engine health, fault codes
- Click "Clear Faults" to reset

#### Dyno Testing
- Go to "Dyno" tab
- Click "Start Dyno" to run performance test
- Displays: HP, Torque, Speed in real-time
- Test takes ~15 seconds

#### Custom Parts Install
- Go to "Upgrades" tab
- Select each category (engine, cosmetic, interior, lighting)
- Select parts and install
- Required items must be in inventory

#### Staff Management (Admin)
- Go to "Staff" tab
- Clock in/out staff
- Add employees
- Fire employees
- Promote staff

#### Business Analytics
- Go to "Analytics" tab (Admin)
- View daily revenue
- See popular upgrades
- Track success rate

### 3. **Diagnostics Features**
```lua
-- Check engine health
/testui -- go to Diagnostics tab

-- Engine status shows:
- Engine Health %
- Fault codes (if any)
- Damage status
```

### 4. **Dyno Features**
```lua
-- Run performance test
/testui -- go to Dyno tab

-- Shows:
- Horsepower (HP)
- Torque (TQ)
- Top Speed (MPH)
- Peak power graph
```

## Feature Status Matrix

| Feature | Status | How to Access |
|---------|--------|--------------|
| **Paint Job** | ✅ Fully Functional | `/mx mechanic` → Paint tab |
| **Wheels** | ✅ Fully Functional | `/mx mechanic` → Wheels tab |
| **Engine Swap** | ✅ Fully Functional | `/mx mechanic` → Engine tab |
| **Upgrades** | ✅ Fully Functional | `/mx mechanic` → Upgrades tab |
| **Tuning/Presets** | ✅ Fully Functional | `/mx mechanic` → Tuning tab |
| **Cosmetics** | ✅ Fully Functional | `/mx mechanic` → Cosmetics tab |
| **Interior Mods** | ✅ Fully Functional | `/mx mechanic` → Interior tab |
| **Lighting** | ✅ Fully Functional | `/mx mechanic` → Lighting tab |
| **Diagnostics** | ✅ Fully Functional | `/mx mechanic` → Diagnostics tab |
| **Dyno Testing** | ✅ Fully Functional | `/mx mechanic` → Dyno tab |
| **Staff Management** | ✅ Fully Functional | `/mx admin` → Staff tab |
| **Business Analytics** | ✅ Fully Functional | `/mx admin` → Analytics tab |
| **Customer Orders** | ✅ Fully Functional | `/mx mechanic` → Orders tab |
| **Finance/Invoices** | ✅ Fully Functional | `/mx mechanic` → Finance tab |

## Callbacks Implemented

### Client → Server Communication
- `requestPartsData` - Load available upgrades
- `requestVehicleData` - Load vehicle current mods
- `installUpgrade` - Install selected upgrade
- `applyPaint` - Apply paint colors
- `applyWheels` - Apply wheel changes
- `applyTuning` - Apply tuning preset
- `applyCosmetic` - Apply cosmetic mods
- `applyInterior` - Apply interior mods
- `applyLighting` - Apply lighting mods
- `runDiagnostic` - Run diagnostic scan
- `swapEngine` - Swap to different engine
- `removeEngine` - Remove current engine
- `previewMod` - Preview mod before applying
- `toggleDyno` - Start/stop dyno test
- `clearFaults` - Clear diagnostic faults

### Admin Callbacks
- `clockInStaff` - Employee clock in
- `clockOutStaff` - Employee clock off
- `addEmployee` - Hire new staff
- `removeEmployee` - Fire staff member
- `promoteEmployee` - Promote staff rank
- `getAnalyticsData` - Business analytics
- `getStaffList` - Staff roster

### Data Transfer Callbacks
- `getOrders` - Pending customer orders
- `getInventory` - Shop inventory
- `acceptCustomerOrder` - Accept work order
- `cancelCustomerOrder` - Cancel order
- `completeCustomerOrder` - Mark job done

## Troubleshooting

### UI Not Opening
1. Make sure you have "mechanic" job
2. Use `/testui` command to force open
3. Check console for errors with `/testui`

### Parts Not Installing
1. Check inventory for required items
2. Verify vehicle is not in safe zone
3. Make sure you have enough cash
4. Check notifications for error messages

### Diagnostics Not Working
1. Make sure engine is running
2. Vehicle must be valid
3. Check for network lag

### Dyno Not Running
1. Close all other UIs first
2. Vehicle must be in neutral
3. Make sure engine has fuel
4. Wait for previous dyno test to finish

## Database Tables Used

- `player_vehicles` - Vehicle data
- `vehicle_engines` - Engine swap history
- `vehicle_performance` - Performance parts
- `mechanic_shops` - Business data
- `mechanic_logs` - Transaction logs
- `mechanic_staff` - Staff management
- `mechanic_inventory` - Parts inventory
- `mechanic_orders` - Customer orders

All features are fully integrated with the database and persist across server restarts.
