-- ==============================================================================
-- FILE 07: O(1) AGGREGATIONS (THE VECTOR OLAP CUBE)
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- 1. CORE VECTOR MATRIX (Grouped by Node + Vector)
-- ==============================================================================
-- Captures the exact relational flow, strictly filtering out Drafts/Cancelled.

DEFINE TABLE OVERWRITE v_tx_from AS 
    SELECT 
        a_from AS user, 
        d2_vector AS vector, 
        math::sum(a_qty) AS total_qty, 
        math::sum(d3_raw_xp) AS raw_xp, 
        math::sum(d4_net_xp) AS net_xp, 
        math::max(d3_raw_xp) AS max_xp, 
        math::min(d3_raw_xp) AS min_xp, 
        math::sum(d5_raw_co2e) AS total_co2e 
    FROM esg_tx 
    WHERE a_status = 'Posted' 
    GROUP BY user, vector;

DEFINE TABLE OVERWRITE v_tx_to AS 
    SELECT 
        a_to AS target, 
        d2_vector AS vector, 
        math::sum(a_qty) AS total_qty, 
        math::sum(d3_raw_xp) AS raw_xp, 
        math::sum(d4_net_xp) AS net_xp, 
        math::max(a_qty) AS max_qty, 
        math::sum(d5_raw_co2e) AS total_co2e 
    FROM esg_tx 
    WHERE a_status = 'Posted' 
    GROUP BY target, vector;


-- ==============================================================================
-- 2. CATEGORY TAXONOMY MATRIX (Grouped by Node + Category + Vector)
-- ==============================================================================
-- Allows for deep dimensional slicing (e.g. Total 'Waste' CO2e vs 'Travel' CO2e).

DEFINE TABLE OVERWRITE v_tx_from_cat AS 
    SELECT 
        a_from AS user, 
        a_category AS category, 
        d2_vector AS vector, 
        math::sum(a_qty) AS total_qty, 
        math::sum(d4_net_xp) AS net_xp, 
        math::sum(d5_raw_co2e) AS total_co2e 
    FROM esg_tx 
    WHERE a_status = 'Posted' 
    GROUP BY user, category, vector;

DEFINE TABLE OVERWRITE v_tx_to_cat AS 
    SELECT 
        a_to AS target, 
        a_category AS category, 
        d2_vector AS vector, 
        math::sum(a_qty) AS total_qty, 
        math::sum(d4_net_xp) AS net_xp, 
        math::sum(d5_raw_co2e) AS total_co2e 
    FROM esg_tx 
    WHERE a_status = 'Posted' 
    GROUP BY target, category, vector;


-- ==============================================================================
-- 3. DEPARTMENTAL PROPAGATION (Grouped by Group/Owned_By)
-- ==============================================================================
-- Directly groups the User table to feed the Groups table for organizational roll-ups.
-- It reads the structurally derived math on the user, ensuring an unbroken math chain.

DEFINE TABLE OVERWRITE v_user_group AS 
    SELECT 
        owned_by AS group, 
        math::sum(d1_net_xp) AS net_xp, 
        math::max(d1_net_xp) AS max_net_xp, 
        math::min(d1_net_xp) AS min_net_xp, 
        math::sum(d2_total_co2e) AS total_co2e 
    FROM user 
    GROUP BY group;