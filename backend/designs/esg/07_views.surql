-- ==============================================================================
-- FILE 07: O(1) AGGREGATIONS & BI VIEWS
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- 1. CARBON ACCOUNTING (Environment)
-- ==============================================================================
DEFINE TABLE OVERWRITE v_carbon_dept AS SELECT a_department AS department, count() AS tx_count, math::sum(d1_total_co2e) AS total_co2e FROM carbon_transaction GROUP BY department;

DEFINE TABLE OVERWRITE v_carbon_factor AS SELECT a_emission_factor AS factor, math::sum(a_qty) AS total_qty, math::sum(d1_total_co2e) AS total_co2e FROM carbon_transaction GROUP BY factor;

-- ==============================================================================
-- 2. GAMIFICATION LEDGER & WALLETS (Social)
-- ==============================================================================
DEFINE TABLE OVERWRITE v_emp_csr AS SELECT a_employee AS employee, count() AS total_activities, math::sum(d1_points_earned) AS total_csr_points FROM csr_participation GROUP BY employee;

DEFINE TABLE OVERWRITE v_emp_challenge AS SELECT a_employee AS employee, math::sum(d2_is_completed) AS completed_challenges, math::sum(d1_xp_earned) AS total_challenge_xp FROM challenge_participation GROUP BY employee;

DEFINE TABLE OVERWRITE v_emp_redemptions AS SELECT a_employee AS employee, math::sum(a_qty) AS items_redeemed, math::sum(d1_total_cost) AS total_spent FROM reward_redemption GROUP BY employee;

-- The Master Employee Wallet
DEFINE TABLE OVERWRITE v_employee_wallet AS 
    SELECT 
        a_employee AS employee,
        math::sum(d1_points_earned) AS total_earned,
        math::sum(d1_points_earned) - ((type::record('v_emp_redemptions', [$this.a_employee.id])).total_spent ?? 0dec) AS available_balance
    FROM csr_participation 
    GROUP BY employee;

-- ==============================================================================
-- 3. REWARD INVENTORY (Matrix State)
-- ==============================================================================
DEFINE TABLE OVERWRITE v_reward_redemptions AS SELECT a_reward AS reward, math::sum(a_qty) AS redeemed_qty FROM reward_redemption GROUP BY reward;

DEFINE TABLE OVERWRITE v_reward_stock AS 
    SELECT 
        id AS reward, 
        a_initial_stock, 
        a_initial_stock - ((type::record('v_reward_redemptions', [$this.id])).redeemed_qty ?? 0) AS remaining_stock 
    FROM reward;

-- ==============================================================================
-- 4. GOVERNANCE & COMPLIANCE METRICS
-- ==============================================================================
DEFINE TABLE OVERWRITE v_compliance_dept AS SELECT a_audit.a_department AS department, count() AS total_issues, math::sum(d2_is_open) AS open_issues, math::sum(d1_is_overdue) AS overdue_issues FROM compliance_issue GROUP BY department;

DEFINE TABLE OVERWRITE v_policy_ack_dept AS SELECT a_employee.a_department AS department, count() AS total_acknowledgements FROM policy_acknowledgement GROUP BY department;

-- ==============================================================================
-- 5. TIME-SERIES BI (Read-Only Dashboards)
-- ==============================================================================
DEFINE TABLE OVERWRITE v_bi_carbon_monthly AS SELECT time::group(created_at, 'month') AS month, a_department AS department, math::sum(d1_total_co2e) AS monthly_co2e FROM carbon_transaction GROUP BY month, department;

DEFINE TABLE OVERWRITE v_bi_participation_monthly AS SELECT time::group(created_at, 'month') AS month, a_employee.a_department AS department, math::sum(d1_points_earned) AS monthly_points FROM csr_participation GROUP BY month, department;