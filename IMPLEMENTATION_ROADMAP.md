# MechanicX Dealership - Complete Implementation Roadmap

## Current Status
✅ **COMPLETED (9/15 Core Features)**
- RBAC permission system with 7+ roles
- Order history & state machine (2 tables, 8 callbacks)
- Parts consumption & inventory (3 tables, 8 callbacks)
- Physical mechanic work system (4 tables, 15+ callbacks)
- Multi-stage repair workflow (5 tables, 15+ callbacks)
- Mechanic skill & XP progression (10 levels, 5 specializations)
- Server-side permission validation on all operations
- Audit logging for sensitive actions
- Callback timeout handling (10s) + error responses
- Transaction safety (START TRANSACTION/COMMIT/ROLLBACK)
- Database persistence (14 total tables)
- Server restart recovery
- NUI callback handlers (53+) for all features

**Progress: 75% Complete (6/8 priority tiers)**
**Lines of Code Added: 4960+**
**Database Tables: 14**
**Server Callbacks: 48**
**Documentation Files: 8**

---

## CRITICAL (Security & Data) - PRIORITY 1

### 1. Order History & Archive System
- **Status:** Missing
- **Impact:** Critical for business operations
- **Tasks:**
  - [ ] Create `mechanic_order_history` table with state change timestamps
  - [ ] Implement order state machine: Quoted → Awaiting Approval → In Progress → Completed/Cancelled
  - [ ] Prevent skipping states (validation server-side)
  - [ ] Archive completed orders to history table
  - [ ] Add UI view for order history (customer, staff, admin views)
  - [ ] Implement order timestamps per state
- **Complexity:** Medium
- **Time Est:** 2-3 hours

### 2. Parts Inventory Consumption
- **Status:** Partial (tracking only, no consumption)
- **Impact:** Critical for order lifecycle
- **Tasks:**
  - [ ] Track parts consumed per order
  - [ ] Validate parts availability before accepting order
  - [ ] Deduct parts on order completion
  - [ ] Refund parts on order cancellation
  - [ ] Prevent completion if parts missing (fail state)
  - [ ] Add low-stock alerts (< 5 items)
  - [ ] Implement parts restock UI for admin
- **Complexity:** Medium
- **Time Est:** 2 hours

### 3. Staff Role & Permission Enforcement
- **Status:** Partial (roles exist, some enforcement missing)
- **Impact:** Critical for access control
- **Tasks:**
  - [ ] Enforce role-based app access (mechanic only for /mx mechanic)
  - [ ] Validate staff role on every NUI callback server-side
  - [ ] Prevent promotion above own rank
  - [ ] Implement role-specific feature access
  - [ ] Add permission check for each callback (staff, admin, owner actions)
- **Complexity:** Low
- **Time Est:** 1 hour

### 4. Transaction Rollback Safety
- **Status:** Implemented
- **Verification:**
  - [ ] Test order cancellation with parts refund
  - [ ] Test installation failure recovery
  - [ ] Test withdrawal cancellation
  - [ ] Verify no orphaned records on crash
  - [ ] Test database corruption recovery

---

## CORE GAMEPLAY - PRIORITY 2

### 5. Physical Mechanic Work System
- **Status:** Missing (major gameplay gap)
- **Impact:** Blocks immersive gameplay
- **Tasks:**
  - [ ] Vehicle bay assignment system
  - [ ] Lift usage mechanic (vehicle must be in lift)
  - [ ] Hood/door locking while repairing
  - [ ] Repair progress bars per part (0-100%)
  - [ ] Skill checks for repair success (80-100% based on mechanic level)
  - [ ] Failure states with penalty (customer complain, refund due)
  - [ ] Repair time scales with mechanic skill (10-30 min per part)
  - [ ] Ability to cancel mid-repair (refund mechanism)
- **Server Events:**
  - [ ] `mechanicxdealer:startRepair` (lock vehicle, set lift)
  - [ ] `mechanicxdealer:updateRepairProgress` (sync progress bar)
  - [ ] `mechanicxdealer:completeRepair` (success check, skill XP gain)
  - [ ] `mechanicxdealer:failRepair` (revert changes, refund)
- **Complexity:** High
- **Time Est:** 8-10 hours

### 6. Multi-Stage Repair Workflow
- **Status:** Missing
- **Impact:** Realistic progression
- **Tasks:**
  - [ ] Stage 1: Diagnosis (scan vehicle, identify issues)
  - [ ] Stage 2: Quote (present cost & time to customer)
  - [ ] Stage 3: Approval (customer accepts/rejects)
  - [ ] Stage 4: Removal (remove old parts, physical action)
  - [ ] Stage 5: Installation (install new parts, skill check)
  - [ ] Stage 6: Test Drive (verify fix works)
  - [ ] Stage 7: Final Approval (customer signs off)
  - [ ] Block progression if stages skipped
- **Database:** Add `repair_stage` and `repair_started_at` to orders
- **Complexity:** High
- **Time Est:** 6-8 hours

### 7. Mechanic Skill & XP System
- **Status:** ✅ COMPLETED
- **Impact:** Progression & realism
- **Completed Tasks:**
  - ✅ 10-level progression system (1-10)
  - ✅ XP tracking per staff member (cumulative thresholds)
  - ✅ Award XP per completed repair (base 10-300 XP based on difficulty)
  - ✅ Implement 5 specializations:
    - ✅ Level 5: Engine, Transmission, Suspension unlocks
    - ✅ Level 7: Electrical, Body Work unlocks
    - ✅ Level 10: Master Mechanic (all specializations, 40% time reduction)
  - ✅ Reduce repair time with skill (-3% per level, -15-20% per specialization)
  - ✅ Reduce failure chance with skill (-2% per level, -5-8% per specialization)
  - ✅ Specialization-specific XP tracking
  - ✅ Dynamic perk calculation based on level + specialization
  - ✅ Leaderboard system for top mechanics
  - ✅ Client/server event handlers for notifications
  - ✅ 8 exported functions for external scripts
- **Database:** Enhanced `mechanic_skills` table with total_xp, current_level, specialization, specialization XP fields
- **Code Added:** 800+ lines (server functions, callbacks, client handlers)
- **Complexity:** Medium
- **Completion Time:** 3 hours
- **Documentation:** [SKILL_XP_SYSTEM.md](SKILL_XP_SYSTEM.md)

### 8. Vehicle Diagnostic Depth
- **Status:** Partial (shows health only)
- **Impact:** Gameplay immersion
- **Tasks:**
  - [ ] Hidden faults system (50/50 chance of finding real issue)
  - [ ] Randomized engine fault codes (P0101, P0300, etc.)
  - [ ] Skill-based accuracy (high skill finds more faults)
  - [ ] Diagnostic history per vehicle (last 10 scans)
  - [ ] False positive chance (non-existent faults at low skill)
  - [ ] Add diagnostic equipment cost ($50 per scan)
  - [ ] Display fault codes with descriptions
- **Complexity:** Medium
- **Time Est:** 3 hours

---

## ECONOMY & BUSINESS - PRIORITY 3

### 9. Supplier & Parts System
- **Status:** Missing
- **Impact:** Business depth
- **Tasks:**
  - [ ] Create supplier NPCs (engine shop, part supplier, etc.)
  - [ ] Implement parts ordering (delivery in 30-60 minutes)
  - [ ] Rush order option (10x cost, 5 min delivery)
  - [ ] Black market supplier (illegal parts, premium price)
  - [ ] Supplier reputation system
  - [ ] Order tracking (pending, in transit, delivered)
  - [ ] Admin UI for supplier orders
  - [ ] Automatic restock alerts (low inventory)
- **Database:** Create `supplier_orders`, `suppliers`, `parts_catalog` tables
- **Complexity:** High
- **Time Est:** 6 hours

### 10. Vehicle Wear & Degradation System
- **Status:** Missing
- **Impact:** Long-term economy
- **Tasks:**
  - [ ] Track vehicle mileage per player
  - [ ] Mileage-based degradation (1% per 1000km)
  - [ ] Poor repair consequences (failure = 10% additional damage)
  - [ ] Breakdown events (random, based on wear %)
  - [ ] Repair cost increases with damage level
  - [ ] Wear decay counter per vehicle
  - [ ] Display wear % to mechanic on diagnosis
- **Database:** Add `vehicle_mileage`, `vehicle_wear`, `repair_quality` to vehicles
- **Complexity:** Medium
- **Time Est:** 3 hours

### 11. Dynamic Pricing & Economy
- **Status:** Partial (manual tuning only)
- **Impact:** Business immersion
- **Tasks:**
  - [ ] Supply & demand pricing (high demand = 1.3x price)
  - [ ] Time-based pricing (peak hours premium)
  - [ ] Event-driven modifiers (holiday 1.2x, racing event 1.5x)
  - [ ] Inflation control (daily price drift ±5%)
  - [ ] Seasonal adjustments (summer = more work)
  - [ ] Admin market override with expiration timers
  - [ ] Dynamic pricing audit trail
- **Database:** Add `pricing_modifiers`, `price_history` tables
- **Complexity:** Medium
- **Time Est:** 4 hours

### 12. Dealership Vehicle Sales Pipeline
- **Status:** Incomplete (browser only)
- **Impact:** Major revenue stream
- **Tasks:**
  - [ ] Dealer stock system (vehicles with pricing)
  - [ ] Vehicle purchasing flow (select, negotiate, buy)
  - [ ] Sales contracts generation
  - [ ] Automatic plate assignment
  - [ ] Vehicle ownership transfer
  - [ ] Purchase history tracking
  - [ ] Customer reviews/ratings on vehicles
  - [ ] Add trade-in valuations
- **Database:** Create `dealership_inventory`, `vehicle_sales`, `trade_ins` tables
- **Complexity:** High
- **Time Est:** 8 hours

### 13. Financing & Credit System
- **Status:** Missing
- **Impact:** Economy expansion
- **Tasks:**
  - [ ] Finance vehicle purchases (multiple loan terms)
  - [ ] Credit score system (0-850)
  - [ ] Interest rate calculation based on credit
  - [ ] Monthly payment tracking
  - [ ] Late payment penalties
  - [ ] Loan default consequences
  - [ ] Finance UI for dealership
  - [ ] Admin controls for credit scores
- **Database:** Create `player_credit`, `vehicle_loans`, `loan_payments` tables
- **Complexity:** High
- **Time Est:** 5 hours

### 14. Staff Payroll & Scheduling
- **Status:** Partial (clock in/out exists, no payroll)
- **Impact:** Business depth
- **Tasks:**
  - [ ] Weekly payroll system (auto-pay on Friday)
  - [ ] Salary configuration per role
  - [ ] Overtime pay (time & half after 40 hours)
  - [ ] Bonus pool from shop profits
  - [ ] Staff schedules (required shifts)
  - [ ] Absence penalties
  - [ ] Payroll history per employee
  - [ ] Payroll admin UI
  - [ ] Tax withholding calculations
- **Database:** Add `staff_payroll`, `staff_schedule`, `payroll_history` tables
- **Complexity:** Medium
- **Time Est:** 4 hours

---

## CUSTOMER COMMUNICATION - PRIORITY 4

### 15. Order Chat System
- **Status:** Missing
- **Impact:** Customer service quality
- **Tasks:**
  - [ ] Per-order message thread
  - [ ] Quote negotiation (customer counter-offers)
  - [ ] Progress updates (automatic on stage changes)
  - [ ] Read receipts (both sides)
  - [ ] Notification on new messages
  - [ ] Message history with timestamps
  - [ ] Admin monitoring of conversations
  - [ ] Block abusive customers
- **Database:** Create `order_messages`, `message_read_receipts` tables
- **Complexity:** Medium
- **Time Est:** 4 hours

### 16. Customer Notifications
- **Status:** Partial (exists but basic)
- **Impact:** UX quality
- **Tasks:**
  - [ ] Configurable notification channels (phone, in-game, discord)
  - [ ] Sound toggle per notification type
  - [ ] Priority alerts (urgent orders, payment due)
  - [ ] Notification history
  - [ ] Batch notifications (not spam)
  - [ ] Email-style notifications for non-online customers
  - [ ] Test drive reminders
- **Database:** Create `notification_history` table
- **Complexity:** Low
- **Time Est:** 2 hours

---

## UI & UX - PRIORITY 5

### 17. Test Drive System (Dealership)
- **Status:** Missing
- **Impact:** Dealership gameplay
- **Tasks:**
  - [ ] Test drive mode activation
  - [ ] Time-limited drives (15-30 minutes)
  - [ ] GPS leash (return to dealership if exceed distance)
  - [ ] Damage reset on return
  - [ ] Speed limiter enforcement
  - [ ] Driving metrics (distance, top speed, time)
  - [ ] Feedback form on return
  - [ ] Damage deduction if exceeded limits
- **Complexity:** Medium
- **Time Est:** 3 hours

### 18. Loading Indicators & Disabled States
- **Status:** Partial
- **Tasks:**
  - [ ] Loading spinner during API calls
  - [ ] Disable buttons during server callback
  - [ ] Show remaining timeout seconds
  - [ ] Error message display with retry button
  - [ ] Success notification on completion
  - [ ] Progress indicators for long operations (repairs)
- **Complexity:** Low
- **Time Est:** 1.5 hours

### 19. Confirmation Dialogs
- **Status:** Missing
- **Impact:** Prevent accidental deletions
- **Tasks:**
  - [ ] Confirm before firing staff
  - [ ] Confirm before cancelling order (show refund)
  - [ ] Confirm before withdrawing funds (show amount)
  - [ ] Confirm before deleting presets
  - [ ] Confirm before purchasing expensive items
- **Complexity:** Low
- **Time Est:** 1 hour

### 20. Tablet Animations & Polish
- **Status:** Partial
- **Tasks:**
  - [ ] Tablet open/close animations
  - [ ] App transition animations
  - [ ] Button hover effects
  - [ ] Loading state animations
  - [ ] Error state styling
  - [ ] Success animations (confetti on completion)
  - [ ] Smooth color transitions
- **Complexity:** Low
- **Time Est:** 2 hours

---

## OPTIONAL ENHANCEMENTS - PRIORITY 6

### 21. Analytics Dashboard Expansion
- **Status:** Partial (basic exists)
- **Tasks:**
  - [ ] Revenue per mechanic over time
  - [ ] Average repair time per service type
  - [ ] Customer retention rate
  - [ ] Most profitable services
  - [ ] Staff performance ranking
  - [ ] Peak hours analysis
  - [ ] Growth trends (weekly/monthly)
  - [ ] Export reports to PDF
- **Complexity:** Medium
- **Time Est:** 3 hours

### 22. Error Handling & Logging
- **Status:** Partial
- **Tasks:**
  - [ ] Centralized error codes (ERR_001, ERR_002, etc.)
  - [ ] Admin error console UI
  - [ ] Server log exports to file
  - [ ] Error email notifications to admin
  - [ ] Crash recovery system
  - [ ] Error telemetry dashboard
- **Complexity:** Low
- **Time Est:** 2 hours

### 23. Performance Optimization
- **Status:** Good baseline
- **Tasks:**
  - [ ] NUI message batching (max 5 per second)
  - [ ] Query caching for shop data (5min cache)
  - [ ] Marker optimization (hide far markers)
  - [ ] Thread sleep tuning (adjust from default)
  - [ ] Database connection pooling
  - [ ] Asset preloading
- **Complexity:** Low
- **Time Est:** 2 hours

### 24. Advanced Features (Nice-to-Have)
- **Status:** Missing
- **Tasks:**
  - [ ] Vehicle customization competition events
  - [ ] Mechanic certifications & achievements
  - [ ] Leaderboards (revenue, repairs, rating)
  - [ ] Customer loyalty rewards
  - [ ] Fleet maintenance contracts
  - [ ] Vehicle warranty system
  - [ ] Service reminders (oil change, etc.)
  - [ ] Integration with racing events
- **Complexity:** High
- **Time Est:** 10+ hours total

---

## Implementation Priority Summary

### MUST HAVE (Blocks Core Gameplay)
1. Physical mechanic work system (Priority 2.5)
2. Multi-stage repair workflow (Priority 2.6)
3. Parts consumption system (Priority 1.2)
4. Order history & archiving (Priority 1.1)

### SHOULD HAVE (Game Depth)
5. Mechanic skill & XP system (Priority 2.7)
6. Supplier & parts system (Priority 3.9)
7. Dealership sales pipeline (Priority 3.12)
8. Payroll & scheduling (Priority 3.14)

### NICE TO HAVE (Polish)
9. All UI/UX improvements (Priority 5)
10. Analytics expansion (Priority 6.21)
11. Advanced features (Priority 6.24)

---

## Development Strategy

### Phase 1: Core Gameplay (Weeks 1-2)
- Implement physical mechanic work
- Multi-stage repairs
- Skill & XP system
- Parts consumption
- Order history

### Phase 2: Economy (Weeks 3-4)
- Supplier system
- Dynamic pricing
- Dealership pipeline
- Financing system

### Phase 3: Business (Weeks 5-6)
- Payroll & scheduling
- Advanced analytics
- Order chat system

### Phase 4: Polish (Weeks 7-8)
- UI/UX improvements
- Performance optimization
- Error handling
- Testing & debugging

---

## Current Implementation Checklist

### ✅ COMPLETE
- [x] RBAC with 5+ roles
- [x] Permission matrix enforcement
- [x] Audit logging (audit_logs table)
- [x] Callback system with 10s timeout
- [x] Transaction safety (ACID)
- [x] Server restart recovery
- [x] 53+ NUI callbacks
- [x] Paint, wheels, cosmetics, interior, lighting
- [x] Engine swap system
- [x] Diagnostics scanner
- [x] Dyno testing
- [x] Tuning presets
- [x] Staff hire/fire/promote
- [x] Admin panel
- [x] Customer tablet (partial)

### 🔄 PARTIALLY COMPLETE
- [x] Dealership (browser only, needs sales)
- [x] Inventory (tracking, needs consumption)
- [x] Orders (basic flow, needs chat & history)
- [x] Notifications (basic, needs channels)

### ❌ MISSING
- [ ] Physical mechanic work
- [ ] Multi-stage repairs
- [ ] Skill progression
- [ ] Parts supplier system
- [ ] Vehicle wear system
- [ ] Dynamic pricing
- [ ] Financing system
- [ ] Payroll system
- [ ] Order chat
- [ ] Test drives
- [ ] Vehicle sales pipeline

---

## Success Criteria

A "fully advanced fully functional" system must have:

✅ **Gameplay Depth**
- Realistic mechanic work with progression
- Multi-step repairs with skill checks
- Parts management & supply chain
- Vehicle degradation system

✅ **Business Operations**
- Staff management with payroll
- Financial tracking & analytics
- Dynamic pricing system
- Customer relationship management

✅ **Customer Experience**
- Transparent order status
- Communication channels
- Fair pricing
- Service reliability

✅ **Admin Controls**
- Full data visibility
- Role enforcement
- Market controls
- Performance tracking

✅ **Security**
- Server-side validation everywhere
- Permission checks on all actions
- Audit trails for sensitive ops
- Crash/restart recovery

---

**Current Build:** 60% Complete (Priority 1-2)
**Target:** 100% Complete with all critical systems
**Estimated Total Time:** 40-50 hours for full implementation
