# Multi-Stage Repair Workflow System

## Overview
The Multi-Stage Repair Workflow system breaks vehicle repairs into 7 distinct stages, each with specific requirements, validations, and deliverables. This creates a realistic repair process that mirrors real-world automotive service workflows.

**Key Features:**
- 📋 7-stage repair workflow (Diagnosis → Final Approval)
- 🔍 Initial vehicle diagnostics with health assessment
- 💰 Automated quote generation from diagnosis
- ✅ Customer approval gate system
- 🔧 Part removal and installation phases
- 🚗 Road test validation with scoring
- 🏁 Final inspection checklist
- 📊 Complete audit trail of all stages

---

## The 7 Repair Stages

### Stage 1: Diagnosis
**Purpose:** Assess vehicle condition and determine needed repairs
**Duration:** 10-15 minutes
**Requirements:** Vehicle must be in bay with lift active
**Outputs:** Health report, parts recommendation, cost estimate

**Process:**
1. Mechanic initiates diagnosis scan
2. System reads vehicle engine/body health (0-100)
3. Generates list of recommended parts
4. Calculates estimated labor hours
5. Produces cost estimate
6. Records all findings in database

**Success Criteria:**
- ✅ All vehicle systems scanned
- ✅ Engine health recorded
- ✅ Body damage assessed
- ✅ Parts list generated
- ✅ Cost estimate provided

---

### Stage 2: Quote Generation
**Purpose:** Create formal repair estimate for customer
**Duration:** 5-10 minutes
**Requirements:** Diagnosis must be completed
**Outputs:** Formal quote with labor + parts cost

**Process:**
1. System uses diagnosis data
2. Calculates labor cost (estimated hours × hourly rate)
3. Adds parts cost
4. Generates total quote amount
5. Sets quote expiration (7 days)
6. Stores quote record

**Quote Components:**
```
Quote Structure:
├─ Labor Cost (based on estimated hours)
├─ Parts Cost (sum of all parts)
├─ Total Cost (labor + parts)
├─ Warranty (default 3 months)
└─ Validity (7 days from creation)
```

**Success Criteria:**
- ✅ Labor cost reasonable
- ✅ Parts cost accurate
- ✅ Total matches sum
- ✅ Quote timestamp recorded

---

### Stage 3: Customer Approval
**Purpose:** Await customer approval of quote before proceeding
**Duration:** Unlimited (customer-controlled)
**Requirements:** Quote must exist
**Outputs:** Approved/Rejected status

**Process:**
1. Quote sent to customer
2. Customer reviews in customer app
3. Customer accepts or rejects
4. Decision recorded with timestamp
5. If accepted, workflow proceeds to removal
6. If rejected, job may be cancelled

**Status Values:**
- `pending` - Awaiting customer decision
- `accepted` - Customer approved, proceed to removal
- `rejected` - Customer declined, job cancelled
- `expired` - Quote expired after 7 days

**Success Criteria:**
- ✅ Quote displayed to customer
- ✅ Customer decision recorded
- ✅ Timestamp of approval captured
- ✅ Workflow advances on acceptance

---

### Stage 4: Removal
**Purpose:** Remove damaged/worn components that need replacement
**Duration:** 30-60 minutes (varies by parts)
**Requirements:** Approval received, parts obtained
**Outputs:** Parts removal complete, ready for installation

**Process:**
1. Mechanic marks stage as "in progress"
2. For each part to remove:
   - Drain fluids if applicable
   - Disconnect electrical connections
   - Remove fasteners
   - Remove component
   - Store old part
3. Document condition of removed parts
4. Mark stage as completed

**Safety Checklist:**
- ✅ Engine disabled/cooled
- ✅ All fluids drained
- ✅ Safety equipment in place
- ✅ Area properly organized
- ✅ Parts properly stored

**Success Criteria:**
- ✅ All damaged parts removed
- ✅ Work area cleaned
- ✅ New parts ready
- ✅ Fasteners organized
- ✅ Connections documented

---

### Stage 5: Installation
**Purpose:** Install new/repaired components
**Duration:** 30-60 minutes (varies by parts)
**Requirements:** Removal completed, new parts obtained
**Outputs:** All new parts installed, connections secure

**Process:**
1. Mechanic marks stage as "in progress"
2. For each part to install:
   - Position component
   - Secure with fasteners
   - Connect electrical
   - Fill fluids if applicable
   - Verify torque specs
   - Test basic function
3. Double-check all connections
4. Document work performed
5. Mark stage as completed

**Quality Checks:**
- ✅ All fasteners tight
- ✅ All connections secure
- ✅ Fluids at proper levels
- ✅ No leaks present
- ✅ Components aligned properly

**Success Criteria:**
- ✅ All new parts installed
- ✅ All connections verified
- ✅ Fluid levels correct
- ✅ No visible leaks
- ✅ Ready for testing

---

### Stage 6: Test Drive
**Purpose:** Validate repairs work correctly on the road
**Duration:** 15-30 minutes
**Requirements:** Installation completed
**Outputs:** Performance assessment and pass/fail verdict

**Test Drive Components:**

```
Engine Performance (0-100):
- Idle smooth
- Acceleration responsive
- No strange sounds
- No warning lights

Handling Quality (0-100):
- Steering response
- Turning smoothness
- Stability
- Alignment feel

Brake Response (0-100):
- Brake pedal feel
- Stopping distance
- No pulsation
- No noise
```

**Overall Score Calculation:**
```
Overall = (EnginePerf + Handling + BrakeResponse) / 3

Pass if:
- Overall Score >= 80
- No major safety issues
- All systems respond
```

**If Failed:**
- Record issues found
- Return to installation stage
- Fix identified problems
- Re-test before proceeding

**Success Criteria:**
- ✅ All systems tested
- ✅ Vehicle performs well
- ✅ No safety issues
- ✅ Overall score 80+
- ✅ Test distance recorded

---

### Stage 7: Final Approval
**Purpose:** Comprehensive final inspection before delivery
**Duration:** 15-20 minutes
**Requirements:** Test drive passed
**Outputs:** Approval to release vehicle to customer

**Inspection Checklist:**

```
Visual Inspection ✅
├─ Paint condition (no scratches)
├─ Trim/moldings straight
├─ Glass clean
├─ Interior clean
├─ No fluid leaks

Mechanical Check ✅
├─ All connections tight
├─ Fluid levels correct
├─ Engine runs smooth
├─ Transmission shifts clean
├─ Brakes responsive

Paint/Body ✅
├─ Finish consistent
├─ No overspray
├─ No gaps/misalignment
├─ Hardware secured

Electronics ✅
├─ All warning lights off
├─ Dashboard functions
├─ Lights all working
├─ Audio system plays

Cleanliness ✅
├─ Floor mats clean
├─ Upholstery spotless
├─ Windows clear
├─ No dirt/dust visible

Documentation ✅
├─ Work order complete
├─ All stamps/approvals
├─ Warranty card ready
├─ Customer manual present

Customer Satisfied ✅
├─ Customer confirms approval
├─ No outstanding concerns
├─ Ready for delivery
├─ Payment complete
```

**If All Checks Pass:**
- ✅ Job marked COMPLETE
- ✅ Revenue recorded
- ✅ XP awarded to mechanic
- ✅ Vehicle released to customer
- ✅ Warranty period starts

**Success Criteria:**
- ✅ All 7 checkboxes marked
- ✅ No failed items
- ✅ Customer satisfied
- ✅ All docs complete
- ✅ Ready to release

---

## Database Schema

### repair_workflow_stages
Tracks the current status of each stage.

```sql
CREATE TABLE repair_workflow_stages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    repair_job_id INT NOT NULL,
    shop_name VARCHAR(50) NOT NULL,
    stage_number INT NOT NULL,           -- 1-7
    stage_name VARCHAR(50) NOT NULL,     -- diagnosis, quote, approval, etc.
    stage_description VARCHAR(255),      -- Human-readable description
    status ENUM(...) DEFAULT 'pending',  -- pending, in_progress, completed, failed, skipped
    required_tools JSON DEFAULT '[]',    -- Tools needed for this stage
    required_parts JSON DEFAULT '[]',    -- Parts needed
    skill_required INT DEFAULT 1,        -- Minimum mechanic level
    time_estimate INT DEFAULT 0,         -- Seconds
    actual_time INT DEFAULT 0,           -- Seconds spent
    started_at TIMESTAMP NULL,           -- When stage started
    completed_at TIMESTAMP NULL,         -- When stage completed
    notes VARCHAR(500),                  -- Stage-specific notes
    FOREIGN KEY (repair_job_id) REFERENCES mechanic_repair_jobs(id)
);
```

### repair_diagnosis
Stage 1 diagnosis results.

```sql
CREATE TABLE repair_diagnosis (
    id INT PRIMARY KEY AUTO_INCREMENT,
    repair_job_id INT NOT NULL,
    vehicle_plate VARCHAR(15) NOT NULL,
    engine_health DECIMAL(5,2),       -- 0-100
    body_health DECIMAL(5,2),         -- 0-100
    electrical_ok TINYINT DEFAULT 1,  -- Working (1) or not (0)
    transmission_ok TINYINT DEFAULT 1,-- Working (1) or not (0)
    suspension_ok TINYINT DEFAULT 1,  -- Working (1) or not (0)
    parts_recommended JSON DEFAULT '[]', -- [{part, cost, qty}, ...]
    estimated_labor_hours DECIMAL(5,2),
    estimated_cost INT DEFAULT 0,     -- Total estimated cost
    scanned_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (repair_job_id) REFERENCES mechanic_repair_jobs(id)
);
```

### repair_quotes
Stage 2 quote records.

```sql
CREATE TABLE repair_quotes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    repair_job_id INT NOT NULL,
    shop_name VARCHAR(50) NOT NULL,
    customer_citizenid VARCHAR(50) NOT NULL,
    labor_cost INT DEFAULT 0,        -- Total labor hours × rate
    parts_cost INT DEFAULT 0,        -- Sum of all parts
    total_cost INT DEFAULT 0,        -- labor_cost + parts_cost
    warranty_months INT DEFAULT 3,   -- Warranty period
    valid_until TIMESTAMP NULL,      -- Quote expiration (7 days)
    status ENUM(...) DEFAULT 'pending', -- pending, accepted, rejected, expired
    created_at TIMESTAMP DEFAULT NOW(),
    accepted_at TIMESTAMP NULL,      -- When customer accepted
    FOREIGN KEY (repair_job_id) REFERENCES mechanic_repair_jobs(id)
);
```

### test_drive_results
Stage 6 test drive validation.

```sql
CREATE TABLE test_drive_results (
    id INT PRIMARY KEY AUTO_INCREMENT,
    repair_job_id INT NOT NULL,
    test_start_time TIMESTAMP NULL,
    test_end_time TIMESTAMP NULL,
    test_distance DECIMAL(10,2) DEFAULT 0, -- Miles/KM
    engine_performance INT DEFAULT 0,      -- 0-100 score
    handling_quality INT DEFAULT 0,        -- 0-100 score
    brake_response INT DEFAULT 0,          -- 0-100 score
    overall_condition INT DEFAULT 0,       -- Average of 3 scores
    issues_found VARCHAR(500),             -- Any problems noted
    passed TINYINT DEFAULT 0,              -- 1 if all scores 80+
    tester_citizenid VARCHAR(50),          -- Who performed test
    FOREIGN KEY (repair_job_id) REFERENCES mechanic_repair_jobs(id)
);
```

### final_inspection_checklist
Stage 7 final inspection.

```sql
CREATE TABLE final_inspection_checklist (
    id INT PRIMARY KEY AUTO_INCREMENT,
    repair_job_id INT NOT NULL,
    visual_inspection TINYINT DEFAULT 0,   -- Paint, trim, glass
    mechanical_check TINYINT DEFAULT 0,    -- Connections, fluids
    paint_check TINYINT DEFAULT 0,         -- Finish quality
    electronics_check TINYINT DEFAULT 0,   -- Lights, dashboard
    cleanliness_check TINYINT DEFAULT 0,   -- Interior/exterior
    documentation_complete TINYINT DEFAULT 0, -- Paperwork done
    customer_satisfied TINYINT DEFAULT 0,  -- Customer approval
    final_approval TINYINT DEFAULT 0,      -- All items passed
    inspected_by VARCHAR(100),             -- Inspector name
    inspection_notes VARCHAR(500),         -- Additional notes
    inspected_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (repair_job_id) REFERENCES mechanic_repair_jobs(id)
);
```

---

## Core Server Functions

### InitializeWorkflowStages(repairJobId, shopName)
**Purpose:** Create workflow stage records for a new job
**Returns:** `{success = true, stages = [...7 stages...]}`
**Called:** When job is created

```lua
local result = InitializeWorkflowStages(jobId, shopName)
-- Creates 7 stage records, all starting as 'pending'
```

### GetCurrentStage(repairJobId)
**Purpose:** Get the active stage (pending or in_progress)
**Returns:** Current stage record with all details
**Usage:** Determine where workflow is at

### PerformDiagnosis(repairJobId, vehiclePlate, shopName)
**Purpose:** Scan vehicle and create diagnosis
**Returns:** Diagnosis data with health scores and parts list
**Side Effects:** Updates stage 1 to 'completed'

```lua
local result = PerformDiagnosis(jobId, "ABC123", shopName)
-- Returns: engineHealth, bodyHealth, partsRecommended, estimatedCost
```

### GenerateQuote(repairJobId, shopName, customerId, labor_cost, parts_cost)
**Purpose:** Create formal repair quote
**Returns:** Quote ID and costs
**Side Effects:** Updates stage 2 to 'completed'

```lua
local result = GenerateQuote(jobId, shopName, customerId, 500, 2000)
-- Returns: quoteId, laborCost, partsCost, totalCost
```

### CheckQuoteApproval(repairJobId)
**Purpose:** Check if customer approved quote
**Returns:** `{success = true, approved = true|false}`

### MarkRemovalStageStart(repairJobId, shopName, partsToRemove)
**Purpose:** Begin part removal phase
**Returns:** `{success = true, partsToRemove = [...]}`
**Side Effects:** Sets stage 4 to 'in_progress'

### MarkInstallationStageStart(repairJobId, shopName, partsToInstall)
**Purpose:** Begin part installation phase
**Returns:** `{success = true, partsToInstall = [...]}`
**Side Effects:** Sets stage 5 to 'in_progress'

### RecordTestDriveResult(repairJobId, shopName, passed, distance, enginePerf, handling, braking, testerCitizenid)
**Purpose:** Record test drive scores and pass/fail
**Returns:** `{success = true, passed = true|false, score = 0-100}`
**Side Effects:** 
- Sets stage 6 to 'completed' if passed
- Sets stage 6 to 'failed' if failed

### PerformFinalInspection(repairJobId, shopName, inspectorCitizenid, checks)
**Purpose:** Final inspection checklist
**Parameters:**
```lua
checks = {
    visual = true,           -- Visual inspection passed
    mechanical = true,       -- Mechanical check passed
    paint = true,            -- Paint/body check passed
    electronics = true,      -- Electronics check passed
    cleanliness = true,      -- Cleanliness check passed
    documentation = true,    -- Paperwork complete
    customer_satisfied = true -- Customer approved
}
```
**Returns:** `{success = true, approved = true|false}`
**Side Effects:**
- If all checks true: Stage 7 'completed', job marked 'completed'
- If any check false: Stage 7 'failed'

### GetRepairWorkflow(repairJobId)
**Purpose:** Get all 7 stages with current status
**Returns:** Array of all stages with progress

---

## Server Events & Callbacks

### Server Events (Triggered by Client)
- `mechanic:server:initializeWorkflow` - Create workflow
- `mechanic:server:performDiagnosis` - Run diagnosis
- `mechanic:server:generateQuote` - Create quote
- `mechanic:server:startRemovalStage` - Begin removal
- `mechanic:server:startInstallationStage` - Begin installation
- `mechanic:server:recordTestDrive` - Test drive results
- `mechanic:server:performFinalInspection` - Final check

### Server Callbacks
- `mechanic:server:checkQuoteApproval` - Check if approved
- `mechanic:server:getRepairWorkflow` - Get all stages
- `mechanic:server:getCurrentStage` - Get active stage
- `mechanic:server:getDiagnosisReport` - Get diagnosis
- `mechanic:server:getQuote` - Get quote
- `mechanic:server:acceptQuote` - Customer accepts
- `mechanic:server:rejectQuote` - Customer rejects

---

## Client-Side Exports

All workflow functions are exported for use by other scripts:

```lua
-- Initialize and progress workflow
exports['mechanicxdealer']:InitializeWorkflow(jobId, shopName)
exports['mechanicxdealer']:PerformDiagnosis(jobId, plate, shopName)
exports['mechanicxdealer']:GenerateQuote(jobId, shopName, customerId, labor, parts)
exports['mechanicxdealer']:CheckQuoteApproval(jobId, callback)
exports['mechanicxdealer']:StartRemovalStage(jobId, shopName, parts)
exports['mechanicxdealer']:StartInstallationStage(jobId, shopName, parts)
exports['mechanicxdealer']:RecordTestDrive(jobId, shopName, passed, distance, engine, handling, braking)
exports['mechanicxdealer']:PerformFinalInspection(jobId, shopName, checks)

-- Query workflow data
exports['mechanicxdealer']:GetRepairWorkflow(jobId, callback)
exports['mechanicxdealer']:GetCurrentStage(jobId, callback)
exports['mechanicxdealer']:GetDiagnosisReport(jobId, callback)
exports['mechanicxdealer']:GetQuote(jobId, callback)

-- Customer actions
exports['mechanicxdealer']:AcceptQuote(quoteId, callback)
exports['mechanicxdealer']:RejectQuote(quoteId, callback)
```

---

## Workflow Integration with Order System

```
Customer Order (mechanic_orders)
    ↓
Create Repair Job
    ↓
Initialize Workflow (7 stages)
    ↓
Stage 1: DIAGNOSIS
├─ Scan vehicle condition
├─ Identify needed parts
└─ Estimate cost
    ↓
Stage 2: QUOTE
├─ Calculate labor cost
├─ Calculate parts cost
└─ Generate formal quote
    ↓
Stage 3: APPROVAL
├─ Customer reviews quote
├─ Customer accepts/rejects
└─ If rejected → Job cancelled
    ↓
Stage 4: REMOVAL
├─ Remove damaged parts
└─ Prepare for installation
    ↓
Stage 5: INSTALLATION
├─ Install new parts
└─ Verify all connections
    ↓
Stage 6: TEST DRIVE
├─ Road test validation
├─ Score performance
└─ If failed → Return to Stage 5
    ↓
Stage 7: FINAL APPROVAL
├─ Comprehensive checklist
├─ Inspector approval
└─ Release to customer
    ↓
Job Complete
├─ XP awarded
├─ Revenue recorded
└─ Vehicle delivered
```

---

## Testing Scenarios

### Scenario 1: Complete Successful Repair
1. Create job → Initialize workflow
2. Perform diagnosis → Document vehicle condition
3. Generate quote → $3,500 total
4. Customer accepts quote
5. Start removal → Remove damaged engine
6. Start installation → Install new engine
7. Test drive → Pass with 85/100 score
8. Final inspection → All checks pass
9. Job complete, customer satisfied

### Scenario 2: Quote Rejection
1. Create job → Initialize workflow
2. Perform diagnosis
3. Generate quote → $5,000
4. Customer rejects (too expensive)
5. Job cancelled
6. No parts consumed
7. Customer charged only diagnosis fee

### Scenario 3: Test Drive Failure
1. Stages 1-5 complete
2. Test drive → Fail (brake issues detected)
3. Return to Stage 5 (installation)
4. Fix brake problems
5. Re-test drive → Pass
6. Proceed to final approval

---

## Mechanic Workflow Guide

### Before Starting Work
- [ ] Speak with customer (explain process)
- [ ] Confirm vehicle condition
- [ ] Ensure parts are available
- [ ] Check all tools on hand

### Stage 1: Diagnosis (10-15 min)
- [ ] Get vehicle in bay
- [ ] Activate lift
- [ ] Scan all systems
- [ ] Document health scores
- [ ] Generate parts list

### Stage 2: Quote (5-10 min)
- [ ] Use diagnosis data
- [ ] Calculate labor hours
- [ ] Get parts pricing
- [ ] Generate quote
- [ ] Send to customer

### Stage 3: Approval (Customer time)
- [ ] Wait for customer decision
- [ ] Send quote reminder if needed
- [ ] Prepare to proceed if approved

### Stage 4: Removal (30-60 min)
- [ ] Prepare work area
- [ ] Gather tools
- [ ] Remove each part carefully
- [ ] Document part condition
- [ ] Store parts safely
- [ ] Clean work area

### Stage 5: Installation (30-60 min)
- [ ] Verify new parts quality
- [ ] Install each component
- [ ] Torque all fasteners
- [ ] Fill fluids
- [ ] Test basic function
- [ ] Check for leaks

### Stage 6: Test Drive (15-30 min)
- [ ] Start engine
- [ ] Check gauges
- [ ] Drive smoothly
- [ ] Test acceleration
- [ ] Test braking
- [ ] Check handling
- [ ] Score performance
- [ ] Document distance
- [ ] Record any issues

### Stage 7: Final Approval (15-20 min)
- [ ] Visual inspection
- [ ] Mechanical verification
- [ ] Check electronics
- [ ] Verify cleanliness
- [ ] Review documentation
- [ ] Customer final check
- [ ] Release vehicle

---

## Performance Targets

| Stage | Typical Time | Difficulty | XP Reward |
|-------|-------------|-----------|-----------|
| Diagnosis | 10-15 min | Low | 25 |
| Quote | 5-10 min | Low | 10 |
| Approval | Varies | N/A | 0 |
| Removal | 30-60 min | Med | 75 |
| Installation | 30-60 min | Med | 75 |
| Test Drive | 15-30 min | Med | 50 |
| Final Approval | 15-20 min | Low | 25 |
| **Total** | **2-3 hours** | **Med** | **260** |

---

## Troubleshooting

### Customer rejected quote
- Don't force sale
- Offer to negotiate pricing
- Can break quote into smaller stages
- May offer discount for cash payment

### Test drive failed
- Identify specific issues
- Return to installation
- Fix identified problems
- Re-test drive
- Don't proceed until passing

### Final inspection failed
- Address each failed item
- Don't sign off until all pass
- Customer must approve
- Ensure documentation complete

---

**Last Updated:** January 21, 2026
**System Status:** ✅ Production Ready
**Test Coverage:** ✅ Complete workflow tested
**Integration:** ✅ Fully integrated with order system
