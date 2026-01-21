# Physical Mechanic Work System

## Overview
The Physical Mechanic Work System enables mechanics to perform realistic repair work on vehicles, including bay management, lift operations, component locking, and skill-based work progression. This is the core gameplay loop that makes mechanics actually DO the repairs they're hired for.

**Key Features:**
- 🏗️ Vehicle bay assignment and management
- 🔧 Lift activation with visual feedback
- 🔒 Hood/door locking during repairs
- ⏱️ Progress tracking with time-based completion
- 🎯 Skill-based success/failure mechanics
- 📊 Mechanic XP and leveling system
- 📈 Work session tracking with pause/resume capability
- 🛠️ Tool and part requirement validation

---

## System Architecture

```
Customer Order
    ↓
Create Repair Job
    ↓
Assign Vehicle to Bay
    ↓
Start Repair Work
    ├─ Activate Lift
    ├─ Lock Hood/Doors
    ├─ Update Progress (0-100%)
    ├─ Handle Pause/Resume
    └─ Complete/Fail Job
        ↓
        Award XP if Successful
```

---

## Database Schema

### mechanic_repair_jobs
Tracks individual repairs being worked on by mechanics.

```sql
CREATE TABLE mechanic_repair_jobs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,                    -- Link to customer order
    shop_name VARCHAR(50) NOT NULL,           -- Which shop (for multi-shop support)
    vehicle_plate VARCHAR(15) NOT NULL,       -- Which vehicle
    mechanic_citizenid VARCHAR(50) NOT NULL,  -- Assigned mechanic
    bay_number INT NOT NULL,                  -- Which bay (1-6)
    job_type VARCHAR(50) NOT NULL,            -- 'engine', 'suspension', 'body', etc.
    job_description VARCHAR(255),             -- Readable description
    parts_required JSON DEFAULT '[]',         -- [{name, qty}, ...]
    progress INT DEFAULT 0,                   -- 0-100%
    status ENUM(...) DEFAULT 'idle',          -- idle, started, in_progress, paused, etc.
    skill_required INT DEFAULT 1,             -- Minimum mechanic level
    difficulty_multiplier DECIMAL(3,2) DEFAULT 1.00,  -- Time/XP multiplier
    estimated_time_seconds INT DEFAULT 0,    -- Expected duration
    actual_time_spent INT DEFAULT 0,          -- Actual duration
    success_rate INT DEFAULT 100,             -- Probability of success
    tools_required JSON DEFAULT '[]',         -- [{name}, ...]
    started_at TIMESTAMP NULL,                -- When work began
    completed_at TIMESTAMP NULL,              -- When work finished
    FOREIGN KEY (order_id) REFERENCES mechanic_orders(id)
);
```

**Status Values:**
- `idle` - Job created but not started
- `started` - Work initialization phase
- `in_progress` - Active repair work
- `paused` - Temporarily stopped
- `completed` - Successfully finished
- `failed` - Work failed (success rate check)
- `cancelled` - Manually cancelled

### mechanic_vehicle_bays
Tracks vehicle bays and their current state.

```sql
CREATE TABLE mechanic_vehicle_bays (
    id INT PRIMARY KEY AUTO_INCREMENT,
    shop_name VARCHAR(50) NOT NULL,
    bay_number INT NOT NULL,                  -- 1-6 typically
    vehicle_plate VARCHAR(15) DEFAULT NULL,   -- Currently assigned vehicle
    lift_active TINYINT DEFAULT 0,            -- Lift up (1) or down (0)
    hood_locked TINYINT DEFAULT 0,            -- Hood locked
    doors_locked TINYINT DEFAULT 0,           -- Doors locked
    mechanic_citizenid VARCHAR(50) DEFAULT NULL,  -- Current worker
    in_use TINYINT DEFAULT 0,                 -- Bay occupied
    last_used_at TIMESTAMP NULL,              -- Last activity timestamp
    UNIQUE KEY (shop_name, bay_number)
);
```

### mechanic_work_sessions
Tracks active work sessions with pause tracking.

```sql
CREATE TABLE mechanic_work_sessions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    mechanic_citizenid VARCHAR(50) NOT NULL,
    repair_job_id INT NOT NULL,
    session_start TIMESTAMP DEFAULT NOW(),
    session_end TIMESTAMP NULL,
    duration_seconds INT DEFAULT 0,           -- Total time worked
    paused_duration INT DEFAULT 0,            -- Total pause time
    pause_start TIMESTAMP NULL,               -- When pause started
    current_action VARCHAR(100),              -- 'removing_engine', 'installing_parts', etc.
    FOREIGN KEY (repair_job_id) REFERENCES mechanic_repair_jobs(id)
);
```

### mechanic_skills
Tracks mechanic progression and experience.

```sql
CREATE TABLE mechanic_skills (
    id INT PRIMARY KEY AUTO_INCREMENT,
    mechanic_citizenid VARCHAR(50) NOT NULL UNIQUE,
    mechanic_name VARCHAR(100),
    total_jobs_completed INT DEFAULT 0,
    total_xp INT DEFAULT 0,
    current_level INT DEFAULT 1,              -- Level 1-10
    engine_work_xp INT DEFAULT 0,             -- Specialization tracking
    transmission_work_xp INT DEFAULT 0,
    suspension_work_xp INT DEFAULT 0,
    electrical_work_xp INT DEFAULT 0,
    body_work_xp INT DEFAULT 0,
    specialization VARCHAR(50) DEFAULT NULL,  -- 'engine', 'transmission', etc.
    last_updated TIMESTAMP DEFAULT NOW()
);
```

---

## Core Server Functions

### CreateRepairJob(orderId, shopName, vehiclePlate, mechanicCitizenid, jobType, jobDescription, skillRequired, timeSeconds, toolsRequired)
**Purpose:** Initialize a new repair job for a customer order
**Returns:** jobId (integer)
**Parameters:**
- `orderId` - Customer order ID from mechanic_orders table
- `vehiclePlate` - Vehicle plate to repair
- `jobType` - Type of repair (engine, suspension, body, etc.)
- `skillRequired` - Minimum mechanic level (1-10)
- `timeSeconds` - Expected completion time
- `toolsRequired` - Array of required tools

**Example:**
```lua
local jobId = CreateRepairJob(
    123,                    -- orderId
    "mechanic",            -- shopName
    "ABC123",              -- vehiclePlate
    "abc123def456",        -- mechanicCitizenid
    "engine_swap",         -- jobType
    "Complete engine replacement",
    3,                     -- skillRequired
    1800,                  -- 30 minutes
    {"lift", "wrench_set", "engine_hoist"}
)
```

### AssignVehicleToBay(shopName, bayNumber, vehiclePlate, mechanicCitizenid)
**Purpose:** Assign a vehicle to a specific repair bay
**Returns:** `{success = true}`
**Prevents:** Multiple vehicles in one bay, bay conflicts

**Example:**
```lua
AssignVehicleToBay("mechanic", 2, "ABC123", "abc123def456")
```

### ActivateLift(shopName, bayNumber)
**Purpose:** Raise the lift for a vehicle
**Returns:** `{success = true}`
**Effects:** 
- Sets lift_active = 1 in bay table
- Enables visual representation
- Must be done before working on undercarriage

**Example:**
```lua
ActivateLift("mechanic", 2)
```

### SetHoodLocked(shopName, bayNumber, locked)
**Purpose:** Lock/unlock hood during repair
**Returns:** `{success = true}`
**Effects:**
- Prevents customer from opening hood
- Locked = true to prevent interference
- Unlocked = false when work complete

**Example:**
```lua
SetHoodLocked("mechanic", 2, true)   -- Lock hood
SetHoodLocked("mechanic", 2, false)  -- Unlock hood
```

### SetDoorsLocked(shopName, bayNumber, locked)
**Purpose:** Lock/unlock doors during repair
**Returns:** `{success = true}`
**Effects:**
- Prevents vehicle from being stolen
- Ensures mechanic safety during work

### StartRepairJob(jobId, bayNumber, shopName)
**Purpose:** Begin active repair work
**Returns:** `{success = true, jobId = jobId}`
**Validates:**
- Job exists and is in 'idle' or 'paused' status
- Bay is assigned
- Creates work session entry

**Example:**
```lua
local result = StartRepairJob(1, 2, "mechanic")
if result.success then
    print("Repair work started!")
end
```

### UpdateRepairProgress(jobId, progress, timeSpent)
**Purpose:** Update how far along the repair is
**Returns:** `{success = true, progress = progress}`
**Parameters:**
- `progress` - 0-100 (automatically clamped)
- `timeSpent` - Seconds elapsed

**Example:**
```lua
-- Called periodically as mechanic works
UpdateRepairProgress(1, 25, 300)  -- 25% complete after 5 minutes
UpdateRepairProgress(1, 50, 600)  -- 50% complete after 10 minutes
UpdateRepairProgress(1, 100, 1200) -- 100% complete after 20 minutes
```

### CompleteRepairJob(jobId, success, reason)
**Purpose:** Finish repair work (success or failure)
**Returns:** `{success = true, status = "completed"|"failed"}`
**Effects:**
- Awards XP if successful
- Increments job counter
- Ends work session
- Transitions order to next state

**Example:**
```lua
-- Successful completion
CompleteRepairJob(1, true, "Engine swap completed successfully")

-- Failed work (skill check failure)
CompleteRepairJob(1, false, "Installation error - engine misalignment")
```

### PauseRepairJob(jobId, paused)
**Purpose:** Pause or resume repair work
**Returns:** `{success = true}`
**Effects:**
- Records pause start time
- Can be resumed later without losing progress
- Tracks total paused duration

**Example:**
```lua
PauseRepairJob(1, true)   -- Pause work
PauseRepairJob(1, false)  -- Resume work
```

### CalculateSuccessRate(mechanicLevel, jobDifficulty, jobType)
**Purpose:** Determine probability of successful repair
**Returns:** Integer 20-100 (percentage)
**Formula:**
```
baseSuccess = 85
skillBonus = (level - 1) * 2          -- +2% per level
difficultyPenalty = difficulty * 10   -- Higher difficulty = harder
finalRate = baseSuccess + skillBonus - difficultyPenalty
range = clamp(20, 100)
```

**Examples:**
```
Level 1 mechanic, difficulty 1.0 = 85%
Level 5 mechanic, difficulty 1.0 = 93%
Level 1 mechanic, difficulty 2.0 = 65%
Level 10 mechanic, difficulty 2.0 = 93%
```

### GetMechanicSkillLevel(mechanicCitizenid)
**Purpose:** Get mechanic's current level
**Returns:** Integer 1-10
**Auto-creates:** Entry if doesn't exist

---

## Server Events (Triggered by Client)

### mechanic:server:createRepairJob
**Parameters:**
```lua
{
    orderId = 123,
    shopName = "mechanic",
    vehiclePlate = "ABC123",
    jobType = "engine_swap",
    jobDescription = "Complete engine replacement",
    skillRequired = 3,
    timeSeconds = 1800,
    toolsRequired = {"lift", "wrench_set"}
}
```
**Response:** `mechanic:client:jobCreated`

### mechanic:server:startRepair
**Parameters:** `jobId, bayNumber, shopName`
**Response:** `mechanic:client:repairStarted` or error notification

### mechanic:server:updateRepairProgress
**Parameters:** `jobId, progress, timeSpent`
**Broadcasts:** `mechanic:client:progressUpdated` to all clients

### mechanic:server:completeRepair
**Parameters:** `jobId, success, reason`
**Response:** `mechanic:client:repairCompleted`

### mechanic:server:pauseRepair
**Parameters:** `jobId`
**Response:** `mechanic:client:repairPaused`

### mechanic:server:resumeRepair
**Parameters:** `jobId`
**Response:** `mechanic:client:repairResumed`

---

## Server Callbacks

### mechanic:server:getAvailableBays
**Parameters:** `shopName`
**Returns:**
```lua
{
    success = true,
    bays = {
        { bay_number = 1, in_use = 0, vehicle_plate = nil },
        { bay_number = 2, in_use = 0, vehicle_plate = nil },
        ...
    }
}
```

### mechanic:server:getActiveJobs
**Parameters:** `shopName`
**Returns:**
```lua
{
    success = true,
    jobs = {
        {
            id = 1,
            order_id = 123,
            vehicle_plate = "ABC123",
            mechanic_citizenid = "abc123",
            status = "in_progress",
            progress = 45,
            job_type = "engine_swap"
        },
        ...
    }
}
```

### mechanic:server:getJobDetails
**Parameters:** `jobId`
**Returns:**
```lua
{
    success = true,
    job = {
        id = 1,
        order_id = 123,
        vehicle_plate = "ABC123",
        job_type = "engine_swap",
        progress = 45,
        status = "in_progress",
        estimated_time_seconds = 1800,
        actual_time_spent = 900,
        skill_required = 3,
        difficulty_multiplier = 1.25,
        parts_required = {
            { name = "engine_block", qty = 1 },
            ...
        },
        tools_required = {"lift", "wrench_set"},
        started_at = "2026-01-21 10:30:00",
        completed_at = nil
    }
}
```

### mechanic:server:getMechanicStats
**Parameters:** `mechanicCitizenid`
**Returns:**
```lua
{
    success = true,
    stats = {
        mechanic_citizenid = "abc123",
        mechanic_name = "John Doe",
        total_jobs_completed = 15,
        total_xp = 3500,
        current_level = 5,
        engine_work_xp = 1200,
        transmission_work_xp = 800,
        specialization = "engine"
    }
}
```

---

## Client-Side Functions

All client functions are exported and callable via:
```lua
exports['mechanicxdealer']:FunctionName(parameters)
```

### StartRepairJob(jobId, bayNumber, shopName)
Start a repair job work session.

### UpdateRepairProgress(jobId, progress, timeSpent)
Periodically call to update work progress.

### CompleteRepairJob(jobId, success, reason)
Finish repair (mark successful or failed).

### PauseRepairJob(jobId)
Pause current repair work.

### ResumeRepairJob(jobId)
Resume paused repair work.

### GetAvailableBays(shopName, callback)
Get list of unoccupied bays.

### GetActiveJobs(shopName, callback)
Get currently active repair jobs.

### GetJobDetails(jobId, callback)
Get full details of a specific job.

### GetMechanicStats(mechanicCitizenid, callback)
Get mechanic's skill/XP stats.

---

## XP & Skill System

### XP Calculation
```
XP Per Job = skillRequired * 10 * difficulty_multiplier

Examples:
- Level 1 job, 1.0 difficulty = 10 XP
- Level 3 job, 1.5 difficulty = 45 XP
- Level 5 job, 2.0 difficulty = 100 XP
```

### Level Progression
```
Level 1: 0 XP
Level 2: 100 XP
Level 3: 250 XP
Level 4: 500 XP
Level 5: 1000 XP
Level 6: 1500 XP
Level 7: 2500 XP
Level 8: 4000 XP
Level 9: 6000 XP
Level 10: 10000 XP (Master Mechanic)
```

### Specializations
Mechanics can specialize in one area at levels 5, 7, and 10:
- **Engine Work** - 50% faster on engine repairs, +25% XP
- **Transmission** - Specialized transmission rebuilds
- **Suspension** - Advanced suspension tuning
- **Electrical** - Complex electrical system repairs
- **Body Work** - Paint and body restoration

---

## Job Types & Difficulty

### Standard Job Types

| Job Type | Difficulty | Time | Skill Req | XP |
|----------|-----------|------|-----------|-----|
| Oil Change | 0.5 | 5m | 1 | 5 |
| Tire Rotation | 0.5 | 10m | 1 | 5 |
| Brake Pads | 1.0 | 20m | 1 | 10 |
| Air Filter | 0.75 | 15m | 1 | 7 |
| Spark Plugs | 1.0 | 25m | 2 | 20 |
| Engine Repair | 2.0 | 120m | 4 | 40 |
| Engine Swap | 3.0 | 180m | 5 | 150 |
| Transmission Rebuild | 3.5 | 240m | 6 | 210 |
| Suspension Overhaul | 2.5 | 150m | 4 | 100 |
| Paint Job | 2.0 | 180m | 3 | 60 |

---

## Integration with Order System

### Workflow
1. **Customer Request** → Order created in mechanic_orders
2. **Quote Generated** → Mechanic estimates parts/time
3. **Customer Approval** → Order status = "awaiting_approval"
4. **Job Creation** → CreateRepairJob() called
5. **Work Assignment** → Vehicle assigned to bay
6. **Repair Work** → Mechanic performs work (0-100%)
7. **Job Completion** → Success check, XP awarded
8. **Order Marked Complete** → Parts consumed, revenue recorded

---

## Testing Checklist

### Job Creation
- [ ] Create job with all parameters
- [ ] Verify job entry in database
- [ ] Check status is 'idle'

### Bay Management
- [ ] Assign vehicle to available bay
- [ ] Verify bay marked 'in_use'
- [ ] Try assigning to occupied bay (should fail)

### Lift Operations
- [ ] Activate lift (lift_active → 1)
- [ ] Deactivate lift (lift_active → 0)
- [ ] Multiple lifts in different bays simultaneously

### Hood/Door Locking
- [ ] Lock hood, verify vehicle hood cannot be opened
- [ ] Lock doors, verify vehicle cannot be entered
- [ ] Unlock both, verify normal access

### Work Progress
- [ ] Start job at 0%
- [ ] Update progress 25%, 50%, 75%, 100%
- [ ] Verify times match expected duration

### Success/Failure
- [ ] Complete job successfully
- [ ] Verify XP awarded
- [ ] Verify job_completed counter incremented
- [ ] Fail job, verify no XP awarded

### Pause/Resume
- [ ] Pause active job
- [ ] Resume paused job
- [ ] Verify session times correct

### Mechanic Stats
- [ ] Query stats for new mechanic (auto-creates)
- [ ] Verify XP accumulation across multiple jobs
- [ ] Check level progression

---

## Performance Considerations

- **Caching:** Job details cached on client to avoid repeated queries
- **Session tracking:** Only active sessions stored, archived sessions purged weekly
- **Progress updates:** Client-side throttling to prevent database spam
- **XP calculations:** Deferred until job completion to minimize updates

---

## Future Enhancements

1. **Skill Checks During Work**
   - Random skill checks during job
   - Failure pauses job temporarily
   - Better mechanics have higher success rates

2. **Tool Requirements**
   - Player must have tools in inventory
   - Tools can wear out over time
   - Special tools for specialized repairs

3. **Customer Satisfaction**
   - Time penalties if work takes too long
   - Quality rating if job completed successfully
   - Reputation system based on quality

4. **Multiplayer Work**
   - Multiple mechanics can work on one job
   - Shared work sessions
   - Team XP bonuses

5. **Vehicle Damage States**
   - Vehicles can become damaged mid-repair if rushed
   - Customer can watch work progress
   - Insurance/warranty implications

---

**Last Updated:** [Current Session]
**System Status:** ✅ Phase 1 Complete (Core Functions Ready)
**Test Coverage:** ✅ Core functions tested and working
