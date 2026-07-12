-- ==============================================================================
-- FILE 07: O(1) AGGREGATIONS & BI VIEWS (THE OLAP CUBE)
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- 1. TRANSACTION MATRIX (Grouped by Relation, Status, Category)
-- ==============================================================================

-- FROM perspective: What did the User do?
DEFINE TABLE OVERWRITE v_tx_from_ctx AS 
    SELECT 
        a_from AS user, 
        a_status AS status, 
        a_category AS category, 
        math::sum(a_qty) AS total_qty, 
        math::sum(d2_xp_earned) AS xp_earned, 
        math::sum(d3_xp_spent) AS xp_spent, 
        math::sum(d4_net_xp) AS net_xp, 
        math::sum(d5_co2e) AS co2e 
    FROM esg_tx 
    GROUP BY user, status, category;

-- TO perspective: How did the Anchor perform? (E.g., How many approvals did Challenge X get?)
DEFINE TABLE OVERWRITE v_tx_to_ctx AS 
    SELECT 
        a_to AS target, 
        a_status AS status, 
        a_category AS category, 
        math::sum(a_qty) AS total_qty, 
        math::sum(d2_xp_earned) AS xp_minted, 
        math::sum(d3_xp_spent) AS xp_consumed, 
        math::sum(d5_co2e) AS co2e_generated 
    FROM esg_tx 
    GROUP BY target, status, category;


-- ==============================================================================
-- 2. MATHEMATICAL ABSOLUTES (Strict 'Approved' States for Guardrails)
-- ==============================================================================

-- The absolute Wallet Balance (Only counts finalized/approved math)
DEFINE TABLE OVERWRITE v_user_wallet AS 
    SELECT 
        a_from AS user, 
        math::sum(d4_net_xp) AS balance, 
        math::sum(d5_co2e) AS lifetime_co2e 
    FROM esg_tx 
    WHERE a_status = 'Approved' 
    GROUP BY user;

-- The absolute Reward Inventory consumed
DEFINE TABLE OVERWRITE v_reward_consumption AS 
    SELECT 
        a_to AS reward, 
        math::sum(a_qty) AS total_consumed 
    FROM esg_tx 
    WHERE record::tb(a_to) = 'reward' AND a_status = 'Approved' 
    GROUP BY reward;


-- ==============================================================================
-- 3. THE BADGE PHANTOM (100% Derived View)
-- ==============================================================================
-- This uses SurrealDB subqueries to instantly map users to the badges they mathematically qualify for.

DEFINE TABLE OVERWRITE v_user_badges AS 
    SELECT 
        user, 
        balance AS current_xp,
        (SELECT id, a_name FROM badge WHERE a_required_xp <= $parent.balance AND a_status = 'Active') AS unlocked_badges 
    FROM v_user_wallet;


-- ==============================================================================
-- 4. DEPARTMENTAL ROLLUPS (Grouping by the natively derived RBAC 'owned_by')
-- ==============================================================================
-- By checking a_from.owned_by, we effortlessly roll up users into their Groups (Departments).

DEFINE TABLE OVERWRITE v_group_esg_ctx AS 
    SELECT 
        a_from.owned_by AS group, 
        a_status AS status, 
        a_category AS category, 
        math::sum(d2_xp_earned) AS xp_earned, 
        math::sum(d3_xp_spent) AS xp_spent, 
        math::sum(d4_net_xp) AS net_xp, 
        math::sum(d5_co2e) AS co2e 
    FROM esg_tx 
    GROUP BY group, status, category;

DEFINE TABLE OVERWRITE v_group_wallet AS 
    SELECT 
        a_from.owned_by AS group, 
        math::sum(d4_net_xp) AS total_balance, 
        math::sum(d5_co2e) AS total_co2e 
    FROM esg_tx 
    WHERE a_status = 'Approved' 
    GROUP BY group;