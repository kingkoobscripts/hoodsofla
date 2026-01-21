# Quick Reference Guide - MechanicX Dealership System

## System Overview (6 Complete Systems)

### 1️⃣ Order History System
**What it does:** Tracks orders through a 7-state workflow with audit trail
```
pending → quoted → awaiting_approval → in_progress → on_hold → completed/cancelled
```

**Key Files:**
- Implementation: `server/main.lua` (lines ~2600-3100)
- Database: `mechanic_orders`, `mechanic_order_history`, `mechanic_order_state_log`

**Main Callbacks:**
- `mechanic:server:getOrderHistory` - Get order timeline
- `mechanic:server:acceptQuote` - Customer accepts quote
- `mechanic:server:rejectQuote` - Customer rejects quote

**Quick Test:**
1. Accept an order → quote phase
2. Customer approves quote → awaiting_approval phase
3. Mechanic starts work → in_progress phase
4. Check `/mx customer` to see order history with timeline

---

### 2️⃣ Parts Consumption System
**What it does:** Validates parts before accepting orders, consumes on completion, refunds on cancellation
```
Has Parts? → Accept Order → Consume on Complete → Refund on Cancel
```

**Key Files:**
- Implementation: `server/main.lua` (lines ~3100-3300)
- Database: `mechanic_inventory`, `parts_consumption`, `inventory_alerts`

**Main Functions:**
- `ValidatePartsAvailability()` - Check if parts exist
- `ConsumeParts()` - Deduct parts on job complete
- `RefundParts()` - Refund on cancellation
- `RestockItem()` - Admin restock interface

**Quick Test:**
1. Try to accept order with insufficient parts → BLOCKED
2. Add parts via admin panel
3. Accept order and complete → Parts consumed
4. Check admin panel → Low stock alerts

---

### 3️⃣ Staff Permissions System
**What it does:** 7-tier RBAC enforcing role hierarchy and preventing privilege escalation
```
Customer (0) < Mechanic (1) < Lead (2) < Manager (3) < Finance (4) < Owner/Admin (5)
```

**Key Files:**
- Implementation: `server/permissions.lua` (full file)
- Usage: `server/main.lua` (every callback starts with permission check)

**Main Functions:**
- `HasPermission(citizenid, permission)` - Check if player has permission
- `CanManagePlayer(managerId, targetId)` - Prevent managing superiors
- `CanPromoteToRole(managerId, targetRole)` - Prevent promoting above own rank

**Quick Test:**
1. Login as mechanic, try to access admin panel → BLOCKED
2. Login as owner, hire someone as owner → BLOCKED (same rank)
3. Try to demote owner as mechanic → BLOCKED
4. Finance staff tries to change pricing → BLOCKED (needs admin)

---

### 4️⃣ Physical Mechanic Work System
**What it does:** Assigns vehicles to bays with lifts, locks components, tracks progress
```
Assign to Bay → Activate Lift → Lock Hood → Repair → Track Progress → Complete
```

**Key Files:**
- Implementation: `server/main.lua` (lines ~3470-4100)
- Database: `mechanic_repair_jobs`, `mechanic_vehicle_bays`, `mechanic_work_sessions`

**Main Functions:**
- `CreateRepairJob()` - Create new job
- `AssignVehicleToBay()` - Assign vehicle
- `StartRepairJob()` - Begin work
- `UpdateProgress()` - Track progress (0-100%)
- `CompleteRepairJob()` - Finish job

**Server Events:**
- `mechanicxdealer:server:activateLift` - Lift up/down
- `mechanicxdealer:server:lockHood` - Lock hood during repair
- `mechanicxdealer:server:startRepair` - Begin repair work

**Quick Test:**
1. Create repair job for vehicle
2. Assign to bay 1
3. Activate lift → Vehicle rises
4. Lock hood → Hood can't open
5. Progress bar 0% → 100%
6. Complete repair → Vehicle state saved

---

### 5️⃣ Multi-Stage Repair Workflow
**What it does:** 7-stage repair process with diagnostics, quotes, approval, installation, test drive, final inspection
```
Diagnosis → Quote → Approval → Removal → Installation → Test Drive → Final Approval
```

**Key Files:**
- Implementation: `server/main.lua` (lines ~4100-5400)
- Database: `repair_workflow_stages`, `repair_diagnosis`, `repair_quotes`, `test_drive_results`, `final_inspection_checklist`

**Main Functions (Stage by Stage):**

| Stage | Function | What Happens |
|-------|----------|--------------|
| 1 | `PerformDiagnosis()` | Scan vehicle, identify issues |
| 2 | `GenerateQuote()` | Present cost & time to customer |
| 3 | `CheckQuoteApproval()` | Customer decides yes/no |
| 4 | `MarkRemovalStageStart()` | Remove old components |
| 5 | `MarkInstallationStart()` | Install new parts (skill check) |
| 6 | `PerformTestDrive()` | Drive vehicle to test fix |
| 7 | `PerformFinalInspection()` | Checklist verification |

**Server Events:**
- `mechanicxdealer:server:diagnosisStarted`
- `mechanicxdealer:server:quoteApproved`
- `mechanicxdealer:server:testDriveStarted`
- `mechanicxdealer:server:workflowComplete`

**Quick Test:**
1. Create order
2. `acceptQuote()` → Stage 1 (Diagnosis)
3. Run diagnosis → Generate quote
4. Customer approves quote → Stage 2 (Quote)
5. Move through stages 3-7 sequentially
6. Cannot skip stages (validation blocks it)

---

### 6️⃣ Mechanic Skill & XP System
**What it does:** 10-level progression with 5 specializations and performance bonuses
```
Complete Jobs → Earn XP → Level Up → Unlock Specializations → Gain Perks (Time Reduction, Failure Reduction)
```

**Key Files:**
- Implementation: `server/main.lua` (lines ~3220-3470 + callbacks at end)
- Client: `client/main.lua` (lines ~550-627)
- Database: Enhanced `mechanic_skills` table

**Progression:**
```
Level 1: 0 XP       (Start)
Level 5: 1,000 XP   (Engine, Transmission, Suspension unlock)
Level 7: 2,500 XP   (Electrical, Body Work unlock)
Level 10: 10,000 XP (Master Mechanic - all bonuses)
```

**Specializations & Bonuses:**
```
Level 5:
  ├─ Engine Specialist       (-15% time, -5% failure)
  ├─ Transmission Specialist (-15% time, -5% failure)
  └─ Suspension Specialist   (-15% time, -5% failure)

Level 7:
  ├─ Electrical Specialist   (-20% time, -8% failure)
  └─ Body Work Specialist    (-20% time, -8% failure)

Level 10:
  └─ Master Mechanic         (-40% time, -25% failure, all specs)
```

**Main Functions:**
- `AwardMechanicXP(citizenid, xpAmount, jobType, difficulty)` - Award XP on job complete
- `SetSpecialization(citizenid, specName)` - Change specialization
- `GetMechanicPerks(citizenid)` - Get all bonuses
- `GetMechanicLeaderboard()` - Top 10 mechanics
- `CalculateAdjustedRepairTime(baseTime, citizenid)` - Get reduced time with bonuses

**Quick Test:**
1. Complete repair job (base ~300 XP)
2. Check level: should increase
3. At level 5, unlock specialization
4. Choose "engine" specialization
5. Complete engine job → +25% XP bonus applied
6. Check perks: time reduction shows 30% (15% level + 15% specialization)
7. Repair times now 30% faster

---

## Integration Guide

### Order to Completion Flow
```
1. Customer places order
   └─ Check parts availability (Parts System)
   └─ Record in mechanic_orders

2. Mechanic accepts quote
   └─ Permission check (Permissions System)
   └─ Create repair job (Physical Work System)

3. Job starts
   └─ Assign to bay
   └─ Activate lift
   └─ Lock components

4. Work progresses through stages
   └─ Diagnosis phase (Workflow System)
   └─ Quote phase → Customer approval
   └─ Installation phase (Physical Work)
   └─ Test drive phase (Workflow)
   └─ Final inspection (Workflow)

5. Job completes
   └─ Consume parts (Parts System)
   └─ Award XP (Skill System)
   └─ Record in order history (History System)
   └─ Update mechanic level (Skill System)
   └─ Generate revenue (for Priority 3)

6. Order archived
   └─ Move to order history table
   └─ Show in customer timeline
   └─ Track shop profitability
```

### Key Integration Points
- **Order → Parts:** Every order validates parts availability
- **Job → XP:** Job completion awards XP and may trigger level-up
- **XP → Perks:** Mechanic perks modify repair times and failure chance
- **Permissions:** Every NUI callback validates staff role first
- **Workflow → Physical Work:** Stages use bay assignments and progress

---

## Server Callbacks Quick Reference

### Order System
```lua
TriggerCallback('mechanic:server:getOrderHistory', function(data) end)
TriggerCallback('mechanic:server:acceptQuote', function(quoteId) end)
TriggerCallback('mechanic:server:rejectQuote', function(quoteId) end)
```

### Physical Work
```lua
TriggerCallback('mechanic:server:getAvailableBays', function(data) end)
TriggerCallback('mechanic:server:getActiveJobs', function(data) end)
TriggerCallback('mechanic:server:startRepairJob', function(jobId) end)
```

### Workflow
```lua
TriggerCallback('mechanic:server:checkQuoteApproval', function(data) end)
TriggerCallback('mechanic:server:getDiagnosisReport', function(orderId) end)
TriggerCallback('mechanic:server:getRepairWorkflow', function(orderId) end)
```

### Skills
```lua
TriggerCallback('mechanic:server:getFullMechanicStats', function(data) end)
TriggerCallback('mechanic:server:getMechanicPerks', function(perks) end)
TriggerCallback('mechanic:server:getMechanicLeaderboard', function(leaderboard) end)
```

---

## Database Tables Reference

### Orders (3 tables)
```sql
mechanic_orders
  ├─ id (PK)
  ├─ customer_name, phone
  ├─ vehicle_model, plate
  ├─ order_status (pending/quoted/awaiting_approval/in_progress/completed/cancelled)
  └─ created_at, completed_at

mechanic_order_history
  ├─ id (PK)
  ├─ order_id (FK)
  ├─ state_from, state_to
  └─ changed_at

mechanic_order_state_log
  ├─ id (PK)
  ├─ order_id (FK)
  ├─ action, actor, reason
  └─ timestamp
```

### Inventory (3 tables)
```sql
mechanic_inventory
  ├─ id (PK)
  ├─ part_name, part_id
  ├─ quantity, unit_cost
  └─ last_restocked

parts_consumption
  ├─ id (PK)
  ├─ order_id (FK)
  ├─ part_id, quantity_consumed, cost
  └─ consumed_at
```

### Staff (2 tables)
```sql
mechanic_staff
  ├─ id (PK)
  ├─ citizen_id (UNIQUE)
  ├─ staff_name, role
  └─ hired_at

mechanic_skills
  ├─ id (PK)
  ├─ mechanic_citizenid (FK)
  ├─ total_xp, current_level
  ├─ specialization
  ├─ engine_work_xp, transmission_work_xp, etc.
  └─ last_updated
```

### Work Sessions (3 tables)
```sql
mechanic_repair_jobs
  ├─ id (PK)
  ├─ mechanic_id (FK)
  ├─ vehicle_plate, bay_id
  ├─ progress (0-100)
  └─ status (active/paused/completed)

mechanic_vehicle_bays
  ├─ id (PK)
  ├─ bay_number (1-6)
  ├─ vehicle_plate, lift_status
  └─ assigned_at

mechanic_work_sessions
  ├─ id (PK)
  ├─ job_id (FK)
  ├─ started_at, paused_at, resumed_at
  └─ total_duration
```

### Workflow (5 tables)
```sql
repair_workflow_stages
  ├─ id (PK)
  ├─ order_id (FK)
  ├─ stage_name (diagnosis/quote/approval/etc)
  ├─ status (pending/completed/failed)
  └─ timestamp

repair_diagnosis
  ├─ id (PK)
  ├─ order_id (FK)
  ├─ identified_issues, fault_codes
  └─ diagnosis_time

repair_quotes
  ├─ id (PK)
  ├─ order_id (FK)
  ├─ estimated_cost, estimated_time
  ├─ parts_needed
  └─ quoted_at
```

---

## Common Commands for Testing

### Start a new order
```lua
TriggerServerEvent('mechanic:server:createOrder', {
    customer_name = "John Doe",
    phone = "555-1234",
    vehicle_model = "adder",
    vehicle_plate = "ABC123",
    issue_description = "Engine making noise"
})
```

### Assign mechanic to order
```lua
TriggerServerEvent('mechanic:server:assignMechanic', {
    order_id = 1,
    mechanic_id = "ABC1234567890DEF"
})
```

### Complete a repair job
```lua
TriggerServerEvent('mechanic:server:completeRepairJob', {
    job_id = 1,
    mechanic_id = "ABC1234567890DEF"
})
```

### Check mechanic stats
```lua
TriggerCallback('mechanic:server:getFullMechanicStats', function(stats)
    print("Level: " .. stats.current_level)
    print("XP: " .. stats.total_xp)
    print("Specialization: " .. stats.specialization)
end)
```

---

## Troubleshooting

**Problem:** Order won't accept because parts missing
- **Solution:** Admin panel → Add Parts → Restock item

**Problem:** Mechanic can't see job details
- **Solution:** Check role permissions (need Mechanic level 1+)

**Problem:** Order stuck in "awaiting_approval" state
- **Solution:** Use callback `checkQuoteApproval` to manually approve

**Problem:** XP not awarded on job completion
- **Solution:** Check if job properly transitioned to "completed" state

**Problem:** Specialization not applying bonuses
- **Solution:** Verify mechanic level ≥ 5, then use `SetSpecialization` callback

---

## File Organization

```
mechanicxdealer/
├── config.lua                  ← Configuration
├── fxmanifest.lua             ← Manifest
├── server/
│   ├── main.lua               ← All server logic (5400+ lines)
│   ├── permissions.lua        ← RBAC system
│   └── database/              ← (if needed for SQL migrations)
├── client/
│   ├── main.lua               ← Client events, callbacks
│   ├── camera.lua
│   ├── mechanic.lua
│   ├── customer.lua
│   ├── dyno.lua
│   ├── dealership.lua
│   ├── tuning.lua
│   └── business.lua
├── html/                       ← NUI UI (HTML/CSS/JS)
│   ├── ui.html
│   ├── style.css
│   └── script.js
├── web/                        ← Web UI
│   └── apps/
│       ├── mechanic/          ← Mechanic panel
│       ├── customer/          ← Customer panel
│       ├── admin/             ← Admin panel
│       └── dealership/        ← Dealership panel
│
└── Documentation/
    ├── SKILL_XP_SYSTEM.md            ← ✅ Priority 2.7
    ├── ORDER_HISTORY_SYSTEM.md       ← ✅ Priority 1.1
    ├── PARTS_CONSUMPTION_SYSTEM.md   ← ✅ Priority 1.2
    ├── STAFF_ROLE_SYSTEM.md          ← ✅ Priority 1.3
    ├── PHYSICAL_WORK_SYSTEM.md       ← ✅ Priority 2.5
    ├── MULTI_STAGE_WORKFLOW.md       ← ✅ Priority 2.6
    ├── IMPLEMENTATION_ROADMAP.md     ← Master roadmap
    ├── SESSION_COMPLETION_SUMMARY.md ← This session's progress
    └── QUICK_REFERENCE.md            ← This file!
```

---

## What's Next?

**Priority 3 (Not Started):**
- Economic management (revenue tracking, payroll)
- Showroom & vehicle sales
- Advanced reporting
- NPC dealer management

---

**Version:** 2.0 (Post-6 Systems Implementation)
**Last Updated:** January 21, 2026
**Status:** ✅ Production Ready
