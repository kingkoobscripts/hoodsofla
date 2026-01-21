# Parts Consumption & Inventory System - Complete Implementation

**Status:** ✅ COMPLETE
**Time Invested:** ~2.5 hours
**Complexity:** Medium-High
**Impact:** Critical (enables supply chain management)

---

## What Was Implemented

### 1. Database Tables (Created)

#### `parts_consumption`
Tracks every part used in every order.

```sql
CREATE TABLE parts_consumption (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    shop_name VARCHAR(50) NOT NULL,
    part_name VARCHAR(50) NOT NULL,
    part_label VARCHAR(100),
    quantity_used INT NOT NULL DEFAULT 1,
    unit_cost INT DEFAULT 0,
    total_cost INT DEFAULT 0,
    consumed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    refunded_at TIMESTAMP NULL DEFAULT NULL,
    INDEX idx_order_id (order_id),
    INDEX idx_shop (shop_name),
    INDEX idx_consumed_at (consumed_at),
    FOREIGN KEY (order_id) REFERENCES mechanic_orders(id)
)
```

**Fields:**
- `order_id` - Which order the parts were used for
- `part_name` - Internal part identifier
- `part_label` - Human-readable part name
- `quantity_used` - How many units consumed
- `unit_cost` - Cost per unit at time of consumption
- `total_cost` - `quantity_used * unit_cost`
- `consumed_at` - When parts were taken from inventory
- `refunded_at` - When parts were returned (if order cancelled)

**Use Cases:**
- Calculate actual cost of completed orders
- Track profit margins per order
- Audit which parts went into which vehicle
- Cost analysis by service type

#### `inventory_alerts`
Historical record of low-stock alerts.

```sql
CREATE TABLE inventory_alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    shop_name VARCHAR(50) NOT NULL,
    part_name VARCHAR(50) NOT NULL,
    current_quantity INT NOT NULL,
    min_stock INT NOT NULL,
    alert_type VARCHAR(20) DEFAULT 'low_stock',
    acknowledged TINYINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_shop (shop_name),
    INDEX idx_acknowledged (acknowledged)
)
```

**Fields:**
- `part_name` - Which part triggered alert
- `current_quantity` - Inventory level when alert triggered
- `min_stock` - Minimum threshold setting
- `alert_type` - Type of alert (low_stock, out_of_stock, etc.)
- `acknowledged` - Has admin seen and dismissed alert

**Use Cases:**
- Alert history audit trail
- Identify parts with chronic low stock
- Spot trends in consumption rates

#### Enhanced `mechanic_inventory`
Updated with new fields for better tracking.

**New Fields Added:**
- `min_stock INT DEFAULT 5` - Low stock threshold per item
- `unit_cost INT DEFAULT 0` - Cost per unit for profit calculations

---

### 2. Server-Side Functions (server/main.lua)

#### Validation Function
```lua
ValidatePartsAvailability(orderId, shopName, parts)
    -- Checks if all required parts are in stock
    -- Returns: { success: bool, missing?: [...] }
    
-- Example response on failure:
{
    success = false,
    missing = {
        { name = "v8_engine", label = "V8 Engine Block", needed = 1, available = 0 },
        { name = "turbo_kit", label = "Turbo Kit Stage 2", needed = 2, available = 1 }
    }
}
```

#### Consumption Function
```lua
ConsumeParts(orderId, shopName, parts, changedBy)
    -- Deducts parts from inventory
    -- Records consumption in audit table
    -- Auto-triggers low-stock alerts
    -- Rolls back on failure
    -- Returns: { success: bool, consumed?: [...] }
    
-- Example response on success:
{
    success = true,
    consumed = {
        { name = "v8_engine", label = "V8 Engine Block", quantity = 1, unit_cost = 12000, total_cost = 12000 },
        { name = "turbo_kit", label = "Turbo Kit Stage 2", quantity = 1, unit_cost = 15000, total_cost = 15000 }
    }
}
```

#### Refund Function
```lua
RefundParts(orderId, shopName)
    -- Returns consumed parts to inventory
    -- Marks consumption as refunded in DB
    -- Logs refund action
    -- Returns: { success: bool, refunded?: number }
    
-- Called automatically when order is cancelled
```

#### Query Functions
```lua
GetShopInventory(shopName)
    -- Returns all items for a shop
    -- Includes quantity, min_stock, unit_cost, status

GetLowStockItems(shopName)
    -- Returns only items below min_stock threshold
    -- Includes "needed" quantity to reach min_stock + 10

GetOrderConsumption(orderId)
    -- Returns all parts used in an order
    -- For invoice/receipt generation

RestockItem(shopName, itemName, quantity, unitCost)
    -- Adds quantity to existing item
    -- Updates unit_cost
    -- Returns new quantity

GetLowStockItems(shopName)
    -- Returns all items needing restock
    -- Sorted by urgency
```

---

### 3. Server-Side Callbacks

#### Validation
```lua
RegisterCallback("mechanic:server:validatePartsAvailability", function(source, orderId, shopName, parts)
    -- Pre-flight check before accepting order
    -- Returns missing parts if any
    -- Permission: acceptOrder
```

#### Consumption
```lua
RegisterCallback("mechanic:server:consumePartsForOrder", function(source, orderId, shopName, parts)
    -- Called when work starts on order
    -- Deducts parts from inventory
    -- Records audit trail
    -- Permission: acceptOrder
```

#### Refunds
```lua
RegisterCallback("mechanic:server:refundOrderParts", function(source, orderId, shopName)
    -- Called when order is cancelled
    -- Returns all consumed parts
    -- Auto-called from cancelOrderWithReason()
```

#### Inventory Management
```lua
RegisterCallback("mechanic:server:getShopInventory", function(source, shopName)
    -- Get all inventory for a shop
    -- Returns full inventory state

RegisterCallback("mechanic:server:getLowStockItems", function(source, shopName)
    -- Get only items below threshold
    -- For admin dashboard alerts

RegisterCallback("mechanic:server:restockItem", function(source, shopName, itemName, quantity, unitCost)
    -- Admin adds items to inventory
    -- Logs restock action
    -- Permission: withdrawFunds (boss only)

RegisterCallback("mechanic:server:addInventoryItem", function(source, shopName, itemName, itemLabel, initialQuantity, minStock, unitCost)
    -- Create new inventory item
    -- For new parts/materials
    -- Permission: withdrawFunds (boss only)
```

---

### 4. Admin Panel UI (web/apps/admin/)

#### Inventory Management Section
**Location:** Admin Panel → Management → Inventory

**Three Tabs:**

##### Tab 1: Current Stock
- Table showing all inventory items
- Columns: Part Name, Quantity, Min Stock, Unit Cost, Status, Actions
- Status shows ✓ OK (green) or ⚠️ Low (orange)
- Restock button on each item
- Refresh button to reload from server

**Restock Flow:**
1. Click "Restock" on any item
2. Prompt asks how many units
3. Second prompt asks unit cost
4. Server deducts cost from shop balance
5. Inventory updates immediately
6. Action logged in mechanic_logs

##### Tab 2: Low Stock Alerts
- Shows only items below minimum threshold
- Sorted by urgency (most critical first)
- Columns: Part Name, Current Qty, Min Stock, Needed, Action
- "Restock Now" button pre-filled with needed qty
- Green message if all items well-stocked

**Alert System:**
- Auto-triggered when quantity drops to/below min_stock
- Logged in inventory_alerts table
- Shows current qty vs min requirement
- Suggests qty needed to get back to min + 10 buffer

##### Tab 3: Add New Item
- Form to create new inventory item
- Fields:
  - Item Name (internal identifier)
  - Item Label (display name)
  - Initial Quantity (how many to stock)
  - Min Stock (threshold for alerts)
  - Unit Cost (for cost tracking)
- Add button saves to database
- Auto-refreshes inventory views

---

### 5. Integration with Order System

#### When Order Accepted
```
1. ValidatePartsAvailability() called
   ↓ If missing parts:
   └→ Show error, don't accept order
   ↓ If all available:
   └→ Accept order, ready for work
```

#### When Work Starts
```
1. ConsumeParts() called with order items
   ↓ Deduct from inventory
   ↓ Record in parts_consumption table
   ↓ Check for low-stock triggers
   ↓ Auto-create inventory_alerts if needed
   └→ Work proceeds
```

#### When Order Completes
```
1. Order status → completed
2. Parts consumption recorded permanently
3. Can generate invoice with actual part costs
4. Cost analysis available for reporting
```

#### When Order Cancelled
```
1. TransitionOrderState() → cancelled
2. Auto-calls RefundParts()
   ↓ Returns all parts to inventory
   ↓ Marks consumption as refunded
   ↓ Resets low-stock alerts if resolved
3. Customer refund processed
4. Inventory restored
```

---

## How It Works (End-to-End)

### Scenario: Install Engine on Vehicle

**Setup:** Shop has 5 V8 engines in stock (min: 2)

**Step 1: Customer Places Order**
```
Order created for "V8 Engine Install"
Parts: [ { name: "v8_engine", label: "V8 Engine", qty: 1 } ]
```

**Step 2: Mechanic Reviews & Accepts**
```
Server calls: ValidatePartsAvailability(orderId, shopName, parts)
Result: { success: true }
↓
Mechanic can accept order
```

**Step 3: Work Begins**
```
Mechanic clicks "Start Work"
Server calls: ConsumeParts(orderId, shopName, parts)
↓
Inventory: 5 → 4 v8_engines
parts_consumption row created:
  - order_id: 123
  - part_name: v8_engine
  - quantity_used: 1
  - unit_cost: 12000
  - total_cost: 12000
  - consumed_at: 2026-01-21 10:30:00
↓
Inventory now: 4 engines (still above min of 2)
No alert triggered
```

**Step 4: Work Completes**
```
Mechanic clicks "Complete Order"
Order status → completed
parts_consumption locked (no refund)
↓
Can generate invoice:
Total Cost: $12,000 + labor + paint, etc.
Profit = Revenue - (Parts Cost + Labor Cost)
```

**Alternate: Order Cancelled Midway**
```
Mechanic clicks "Cancel Order"
Server calls: RefundParts(orderId, shopName)
↓
Inventory: 4 → 5 v8_engines
parts_consumption.refunded_at = NOW()
↓
Back to original state
Customer refunded $12,000 + labor + paint, etc.
```

---

## Permission System

### Required Permissions

**acceptOrder** (Mechanic+)
- Accept orders
- Validate parts availability
- Start work on orders
- Consume parts

**completeOrder** (Mechanic+)
- Mark orders complete
- Lock in parts consumption

**withdrawFunds** (Boss/Owner)
- View inventory
- Restock items
- Create new items
- Modify min_stock settings
- View low-stock alerts

---

## Admin Dashboard Features

### Real-Time Visibility

**Current Stock View:**
- See all inventory at a glance
- Quantity per item
- Min stock threshold
- Unit cost for profit calculations
- Color-coded status (OK vs Low)
- 1-click restock action

**Low Stock Alerts:**
- Auto-generated when qty drops below min_stock
- Sorted by urgency
- Shows quantity needed to restore
- One-click restock with suggested amount
- Alert history in inventory_alerts table

**Add New Item:**
- Create new parts as needed
- Set initial quantity and min stock
- Define unit cost for accounting
- Immediately available for orders

### Cost Tracking

Every part in inventory has:
- `unit_cost` - Cost per unit
- `parts_consumption` records - Actual usage
- `mechanic_logs` entries - Restock actions

**Profit Calculation:**
```
Order Revenue = Sum of all charges
Order Cost = Sum of (quantity_used × unit_cost) for all parts
Order Profit = Revenue - Cost
```

---

## Database Queries Examples

### Get All Parts Used in an Order
```sql
SELECT * FROM parts_consumption 
WHERE order_id = 123 
ORDER BY consumed_at DESC;
```

### Calculate Order Profitability
```sql
SELECT 
  mo.id, mo.total_cost as revenue,
  SUM(pc.total_cost) as parts_cost,
  (mo.total_cost - SUM(pc.total_cost)) as profit
FROM mechanic_orders mo
LEFT JOIN parts_consumption pc ON mo.id = pc.order_id
WHERE mo.status = 'completed'
GROUP BY mo.id;
```

### Find Inventory Turnover (most-used parts)
```sql
SELECT 
  part_name, part_label,
  COUNT(*) as times_used,
  SUM(quantity_used) as total_used,
  SUM(total_cost) as total_value
FROM parts_consumption
WHERE consumed_at > DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY part_name
ORDER BY total_used DESC;
```

### Check Low Stock Items
```sql
SELECT 
  item, label, quantity, min_stock,
  (min_stock - quantity) as shortage
FROM mechanic_inventory
WHERE quantity <= min_stock
AND shop_name = 'Main Shop'
ORDER BY shortage DESC;
```

### Restock History
```sql
SELECT 
  shop_name, 
  JSON_EXTRACT(details, '$.item') as item,
  JSON_EXTRACT(details, '$.quantity') as quantity,
  timestamp
FROM mechanic_logs
WHERE action = 'parts_restocked'
ORDER BY timestamp DESC
LIMIT 20;
```

---

## Validation & Safety

### Transaction Safety
All multi-step operations wrapped in transactions:
```lua
MySQL.query.await("START TRANSACTION")
-- Deduct from inventory
-- Record consumption
-- Check for alerts
MySQL.query.await("COMMIT")  -- or ROLLBACK on error
```

### Prevents Overselling
Before consuming parts, ValidatePartsAvailability() ensures:
- Item exists in inventory
- Quantity >= required amount
- All required parts available

If validation fails, order cannot proceed.

### Auto-Refunds
If order cancelled after consuming parts:
- Parts automatically returned to inventory
- consumption.refunded_at marked
- No manual intervention needed

### Prevents Double-Consumption
Each part consumed once per order:
- Multiple refunds won't over-refund
- Refunded consumption marked, skipped on re-refund
- Safe to call RefundParts() multiple times

---

## Performance Optimization

### Database Indexes
- `idx_order_id` - Fast lookup of parts per order
- `idx_shop` - Fast lookup of shop inventory
- `idx_consumed_at` - Fast time-based queries

### Query Limits
- Inventory list loads all items (typically < 100)
- Low stock list filters on-server
- Consumption queries limited to single order

### In-Memory Cache
- Inventory loaded into Lua table on startup
- Reloaded after each consumption/restock
- Fast lookups without DB calls

---

## Testing Checklist

- [ ] Create order with parts
  - [ ] ValidatePartsAvailability returns success
  - [ ] Can accept order
  
- [ ] Start work on order
  - [ ] ConsumeParts deducts from inventory
  - [ ] parts_consumption table has entry
  - [ ] MechanicInventory updated in-memory
  
- [ ] Test low-stock alerts
  - [ ] Consuming last item triggers alert
  - [ ] inventory_alerts table has entry
  - [ ] Admin sees item in "Low Stock" tab
  
- [ ] Test refund on cancel
  - [ ] Cancel order after work started
  - [ ] RefundParts returns parts to inventory
  - [ ] consumption.refunded_at marked
  - [ ] Original quantity restored
  
- [ ] Test admin UI
  - [ ] View all inventory
  - [ ] See low-stock items
  - [ ] Restock item (add quantity)
  - [ ] Create new item
  - [ ] Verify costs tracked
  
- [ ] Test permission enforcement
  - [ ] Non-mechanic can't accept order
  - [ ] Non-boss can't restock
  - [ ] Non-boss can't add items

---

## Integration Points

### With Order System
- Order acceptance validated against inventory
- Order completion locks consumption
- Order cancellation triggers refunds
- Order history shows parts used

### With Admin Panel
- Inventory tab shows all stock
- Low-stock alerts automatic
- Restock actions logged
- Cost tracking for analytics

### With Business System
- Unit costs used in profit calculations
- Total parts cost per order tracked
- Expense tracking per shop
- Inventory value for balance sheets

### Future Integrations
- Automatic reorder when low stock
- Supplier integration for auto-restocking
- Budget tracking (spending limits)
- Waste/damage tracking
- Inventory variance reports

---

## Code Files Modified

1. **server/main.lua** (+350 lines)
   - 3 new database tables (parts_consumption, inventory_alerts, updated mechanic_inventory)
   - 6 utility functions (Validate, Consume, Refund, Get, Restock, Add)
   - 8 new callbacks for parts management
   - Integration with order state machine

2. **web/apps/admin/admin.html** (+100 lines)
   - Enhanced inventory section
   - 3 tabs: Current Stock, Low Stock Alerts, Add New Item
   - Forms for restock and creation

3. **web/apps/admin/admin.js** (+250 lines)
   - Tab switching logic
   - Inventory rendering functions
   - Restock dialog handler
   - New item creation form
   - Server communication

---

## Summary

This implementation provides:

✅ **Complete Inventory Tracking** - Every part accounted for
✅ **Automatic Deduction** - Parts removed when used
✅ **Automatic Refunds** - Parts returned if order cancelled
✅ **Low-Stock Alerts** - Never run out unexpectedly
✅ **Cost Tracking** - Know real cost of each order
✅ **Permission Validation** - Only authorized users manage stock
✅ **Admin Control** - Full visibility and control
✅ **Transaction Safety** - All-or-nothing operations
✅ **Audit Trail** - Complete history of all changes
✅ **Prevents Overselling** - Can't use parts you don't have

**Transforms mechanic shop from:**
- Manual inventory tracking
- Guessing at costs
- Losing money on overselling

**To:**
- Automated inventory management
- Accurate profit calculations  
- Controlled supply chain
- Data-driven business decisions

---

## Next Priority

**Priority 1.3: Staff Role & Permission Enforcement** (1 hour)
- Enforce role-based app access
- Validate staff role on every callback
- Prevent promotion above own rank

Then move to **Core Gameplay (Priority 2): Physical Mechanic Work System** (8-10 hours)

---

**Feature Complete!** ✅
**Ready for Testing** 🚀
**Estimated Impact:** High (enables profitable operations)
