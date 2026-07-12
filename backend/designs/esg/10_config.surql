-- ==============================================================================
-- FILE 10: CONFIGURATION & UPWARD PROPAGATION
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- 1. UPWARD PROPAGATION TO RBAC USERS (Personal Metrics)
-- ==============================================================================
-- Extending the base `user` table (from 01_auth_rbac) to natively track their 
-- absolute ESG Ledger values using O(1) pointers to File 07.

DEFINE FIELD c_total_co2e ON user COMPUTED (type::record('v_tx_from_posted', [$this.id])).net_co2e ?? 0dec;
DEFINE FIELD c_total_xp ON user COMPUTED (type::record('v_tx_from_posted', [$this.id])).net_xp ?? 0dec;
DEFINE FIELD c_max_xp_event ON user COMPUTED (type::record('v_tx_from_posted', [$this.id])).max_net_xp ?? 0dec;


-- ==============================================================================
-- 2. UPWARD PROPAGATION TO RBAC GROUPS (Department Metrics)
-- ==============================================================================
-- Extending the base `groups` table to roll up organizational performance.

DEFINE FIELD c_total_co2e ON groups COMPUTED (type::record('v_tx_group_posted', [$this.id])).net_co2e ?? 0dec;
DEFINE FIELD c_total_xp ON groups COMPUTED (type::record('v_tx_group_posted', [$this.id])).net_xp ?? 0dec;


-- ==============================================================================
-- 3. UPWARD PROPAGATION TO ANCHORS (Inventory State)
-- ==============================================================================
-- Extending the `reward` table to dynamically calculate remaining inventory based 
-- strictly on the Posted 'TO' view.

DEFINE FIELD c_remaining_stock ON reward COMPUTED $this.a_total_stock - ((type::record('v_tx_to_posted', [$this.id])).total_qty ?? 0dec);