-- ==============================================================================
-- FILE 10: CONFIGURATION & ALGORITHMIC EXCEPTIONS
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- COMPANY ESG SETTINGS
-- ==============================================================================
DEFINE TABLE OVERWRITE company SCHEMAFULL;
DEFINE FIELD OVERWRITE require_evidence ON company TYPE bool DEFAULT true;
DEFINE FIELD OVERWRITE auto_calculate_emissions ON company TYPE bool DEFAULT true;
DEFINE FIELD OVERWRITE weight_environmental ON company TYPE decimal DEFAULT 0.4dec ASSERT $value >= 0dec AND $value <= 1.0dec;
DEFINE FIELD OVERWRITE weight_social ON company TYPE decimal DEFAULT 0.3dec ASSERT $value >= 0dec AND $value <= 1.0dec;
DEFINE FIELD OVERWRITE weight_governance ON company TYPE decimal DEFAULT 0.3dec ASSERT $value >= 0dec AND $value <= 1.0dec;
DEFINE FIELD OVERWRITE updated_at ON company TYPE datetime VALUE time::now();

CREATE company:esg_settings SET 
    require_evidence = true, 
    auto_calculate_emissions = true, 
    weight_environmental = 0.4dec, 
    weight_social = 0.3dec, 
    weight_governance = 0.3dec;


-- ==============================================================================
-- THE ABSOLUTE MATRIX GUARD (O(1) Stock Protection)
-- ==============================================================================
-- This event watches the O(1) reward stock view. If a redemption causes the
-- theoretical math to drop below 0, it crashes the transaction, reverting it.

DEFINE EVENT enforce_reward_stock ON TABLE v_reward_stock WHEN $event != 'NONE' THEN {
    LET $stock = $after.remaining_stock ?? $before.remaining_stock ?? 0;
    LET $reward = $after.reward ?? $before.reward;

    IF $stock < 0 {
        THROW "PHYSICS_ERR: Action reverted. This causes Reward [" + <string>$reward + "] to exceed available inventory.";
    };
};


-- ==============================================================================
-- AUTO-AWARD BADGES LOGIC
-- ==============================================================================
-- Instead of heavy cron jobs, we use ReBase events to observe the challenge 
-- participation table. When an employee completes a challenge, we calculate 
-- if they hit a threshold for a new badge.

DEFINE EVENT auto_award_badge_trigger ON TABLE challenge_participation WHEN $event = 'UPDATE' THEN {
    IF $before.a_status != $after.a_status AND $after.a_status.a_name = 'Approved' {
        LET $emp_id = $after.a_employee;
        
        -- Get current stats from views
        LET $current_xp = (type::record('v_emp_challenge', [$emp_id])).total_challenge_xp ?? 0dec;
        LET $current_count = (type::record('v_emp_challenge', [$emp_id])).completed_challenges ?? 0;

        -- Find badges the employee qualifies for, but doesn't have yet.
        -- In actual SurrealQL implementation, this would trigger an edge insertion:
        -- RELATE $emp_id -> earned_badge -> (SELECT id FROM badge WHERE a_target_xp <= $current_xp)
    };
};