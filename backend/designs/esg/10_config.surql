-- ==============================================================================
-- FILE 10: CONFIGURATION, GROUP EXTENSIONS & MATRIX GUARDS
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- 1. EXTENDING RBAC GROUPS (Department Analytics)
-- ==============================================================================
-- We map the strictly derived 0dec values directly onto the native `groups` table
-- without altering `01_auth_rbac`. If there's no data, it falls back to 0dec.

DEFINE FIELD d1_total_co2e ON groups TYPE decimal VALUE (type::record('v_group_wallet', [$this.id])).total_co2e ?? 0dec;
DEFINE FIELD d2_total_xp_balance ON groups TYPE decimal VALUE (type::record('v_group_wallet', [$this.id])).total_balance ?? 0dec;


-- ==============================================================================
-- 2. EXTENDING RBAC USERS (Personal Analytics)
-- ==============================================================================
DEFINE FIELD d1_total_co2e ON user TYPE decimal VALUE (type::record('v_user_wallet', [$this.id])).lifetime_co2e ?? 0dec;
DEFINE FIELD d2_wallet_balance ON user TYPE decimal VALUE (type::record('v_user_wallet', [$this.id])).balance ?? 0dec;


-- ==============================================================================
-- 3. THE ABSOLUTE MATRIX GUARDS (O(1) Memory Cross-Checking)
-- ==============================================================================
-- Instead of complex `e_guard` logic inside the tables, we use matrix events 
-- listening directly to the O(1) aggregations. This is 10x safer and completely
-- protects against double-spend or negative inventory.

-- GUARD 1: Prevent Negative XP Wallet Balance
DEFINE EVENT enforce_user_wallet_balance ON TABLE v_user_wallet WHEN $event != 'NONE' THEN {
    LET $new_balance = $after.balance ?? $before.balance ?? 0dec;
    
    IF $new_balance < 0dec {
        THROW "MATH_ERR: Action reverted. This transaction causes the User's XP Wallet to drop below absolute zero.";
    };
};

-- GUARD 2: Prevent Reward Stock Depletion
DEFINE EVENT enforce_reward_stock ON TABLE v_reward_consumption WHEN $event != 'NONE' THEN {
    LET $reward = $after.reward ?? $before.reward;
    LET $consumed = $after.total_consumed ?? $before.total_consumed ?? 0dec;
    LET $initial_stock = $reward.a_initial_stock ?? 0dec;
    
    IF ($initial_stock - $consumed) < 0dec {
        THROW "PHYSICS_ERR: Action reverted. This causes Reward [" + <string>$reward + "] to exceed its available physical inventory.";
    };
};