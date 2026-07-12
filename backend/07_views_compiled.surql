-- ==============================================================================
-- FILE 07: O(1) AGGREGATIONS & VECTOR VIEWS
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- 1. VECTOR MATRIX (Segmented by Direction)
-- ==============================================================================
DEFINE TABLE OVERWRITE v_tx_from_vec AS SELECT a_from AS user, d2_vector AS vector, math::sum(a_qty) AS total_qty, math::sum(d3_raw_xp) AS raw_xp, math::max(d3_raw_xp) AS max_xp_event, math::mean(d3_raw_xp) AS mean_xp, math::sum(d5_raw_co2e) AS raw_co2e FROM esg_tx GROUP BY user, vector;

DEFINE TABLE OVERWRITE v_tx_to_vec AS SELECT a_to AS target, d2_vector AS vector, math::sum(a_qty) AS total_qty, math::sum(d3_raw_xp) AS raw_xp, math::max(a_qty) AS max_qty, math::sum(d5_raw_co2e) AS raw_co2e FROM esg_tx GROUP BY target, vector;

-- ==============================================================================
-- 2. CATEGORY MATRIX (Segmented by Taxonomy)
-- ==============================================================================
DEFINE TABLE OVERWRITE v_tx_from_cat_vec AS SELECT a_from AS user, a_category AS category, d2_vector AS vector, math::sum(a_qty) AS total_qty, math::sum(d3_raw_xp) AS raw_xp, math::sum(d5_raw_co2e) AS raw_co2e FROM esg_tx GROUP BY user, category, vector;

DEFINE TABLE OVERWRITE v_tx_to_cat_vec AS SELECT a_to AS target, a_category AS category, d2_vector AS vector, math::sum(a_qty) AS total_qty, math::sum(d3_raw_xp) AS raw_xp, math::sum(d5_raw_co2e) AS raw_co2e FROM esg_tx GROUP BY target, category, vector;

-- ==============================================================================
-- 3. THE ABSOLUTE STATE (Filtered by 'Posted') 
-- ==============================================================================
-- These views power the Physics Engine in File 06. They represent historical truth.

DEFINE TABLE OVERWRITE v_tx_from_posted AS SELECT a_from AS user, math::sum(a_qty) AS total_qty, math::sum(d4_net_xp) AS net_xp, math::max(d4_net_xp) AS max_net_xp, math::min(d4_net_xp) AS min_net_xp, math::sum(d5_raw_co2e) AS net_co2e FROM esg_tx WHERE a_status = 'Posted' GROUP BY user;

DEFINE TABLE OVERWRITE v_tx_to_posted AS SELECT a_to AS target, math::sum(a_qty) AS total_qty, math::sum(d4_net_xp) AS net_xp, math::sum(d5_raw_co2e) AS net_co2e FROM esg_tx WHERE a_status = 'Posted' GROUP BY target;

DEFINE TABLE OVERWRITE v_tx_from_cat_posted AS SELECT a_from AS user, a_category AS category, math::sum(a_qty) AS total_qty, math::sum(d4_net_xp) AS net_xp, math::sum(d5_raw_co2e) AS net_co2e FROM esg_tx WHERE a_status = 'Posted' GROUP BY user, category;

DEFINE TABLE OVERWRITE v_tx_to_cat_posted AS SELECT a_to AS target, a_category AS category, math::sum(a_qty) AS total_qty, math::sum(d4_net_xp) AS net_xp, math::sum(d5_raw_co2e) AS net_co2e FROM esg_tx WHERE a_status = 'Posted' GROUP BY target, category;

-- ==============================================================================
-- 4. DEPARTMENTAL ROLLUPS (RBAC Groups)
-- ==============================================================================
-- Bypassing the user to map directly to their parent RBAC Group (Department).

DEFINE TABLE OVERWRITE v_tx_group_posted AS SELECT a_from.owned_by AS group, math::sum(a_qty) AS total_qty, math::sum(d4_net_xp) AS net_xp, math::sum(d5_raw_co2e) AS net_co2e FROM esg_tx WHERE a_status = 'Posted' GROUP BY group;