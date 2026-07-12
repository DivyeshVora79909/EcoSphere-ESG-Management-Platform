-- ==============================================================================
-- FILE 06: TABLE FIELDS (ESG ONTOLOGY & DAG STRUCTURE)
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- LEVEL 0: THE ROOT
-- ==============================================================================

DEFINE TABLE org SCHEMAFULL;
DEFINE FIELD a_name ON org TYPE string;


-- ==============================================================================
-- LEVEL 1: ORGANIZATION CONFIGURATION (Nouns & Laws)
-- ==============================================================================

DEFINE TABLE department SCHEMAFULL;
DEFINE FIELD a_org ON department TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON department TYPE string;

DEFINE TABLE esg_category SCHEMAFULL;
DEFINE FIELD a_org ON esg_category TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON esg_category TYPE string;
DEFINE FIELD a_type ON esg_category TYPE string ASSERT $value IN ['CSR', 'Challenge'];

DEFINE TABLE product SCHEMAFULL;
DEFINE FIELD a_org ON product TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON product TYPE string;

DEFINE TABLE emission_factor SCHEMAFULL;
DEFINE FIELD a_org ON emission_factor TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON emission_factor TYPE string;
DEFINE FIELD a_co2e_per_unit ON emission_factor TYPE decimal ASSERT $value >= 0dec;

DEFINE TABLE environmental_goal SCHEMAFULL;
DEFINE FIELD a_org ON environmental_goal TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON environmental_goal TYPE string;
DEFINE FIELD a_target_co2e ON environmental_goal TYPE decimal ASSERT $value > 0dec;

DEFINE TABLE esg_policy SCHEMAFULL;
DEFINE FIELD a_org ON esg_policy TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON esg_policy TYPE string;

DEFINE TABLE badge SCHEMAFULL;
DEFINE FIELD a_org ON badge TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON badge TYPE string;
DEFINE FIELD a_required_xp ON badge TYPE decimal ASSERT $value > 0dec;

DEFINE TABLE reward SCHEMAFULL;
DEFINE FIELD a_org ON reward TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON reward TYPE string;
DEFINE FIELD a_xp_cost ON reward TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_initial_stock ON reward TYPE int ASSERT $value >= 0;

DEFINE TABLE audit SCHEMAFULL;
DEFINE FIELD a_org ON audit TYPE record<org> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_department ON audit TYPE record<department> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_name ON audit TYPE string;


-- ==============================================================================
-- LEVEL 2: CONTEXTS & ACTORS (Edges connecting the Nouns)
-- ==============================================================================

DEFINE TABLE employee SCHEMAFULL;
DEFINE FIELD a_department ON employee TYPE record<department> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_name ON employee TYPE string;

DEFINE TABLE product_esg_profile SCHEMAFULL;
DEFINE FIELD a_product ON product_esg_profile TYPE record<product> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_emission_factor ON product_esg_profile TYPE record<emission_factor> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_xp_penalty_per_unit ON product_esg_profile TYPE decimal DEFAULT 0dec ASSERT $value >= 0dec; 
-- ^ Determines how much XP is deducted per unit of carbon emitted.

DEFINE TABLE csr_activity SCHEMAFULL;
DEFINE FIELD a_category ON csr_activity TYPE record<esg_category> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_name ON csr_activity TYPE string;
DEFINE FIELD a_xp_reward ON csr_activity TYPE decimal ASSERT $value > 0dec;

DEFINE TABLE challenge SCHEMAFULL;
DEFINE FIELD a_category ON challenge TYPE record<esg_category> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_name ON challenge TYPE string;
DEFINE FIELD a_xp_reward ON challenge TYPE decimal ASSERT $value > 0dec;


-- ==============================================================================
-- LEVEL 3: VERBS & LEDGER (The Immutable Mathematical Graph)
-- ==============================================================================

-- 1. CARBON: Drains XP based on emissions (Polymorphic Actor)
DEFINE TABLE carbon_transaction SCHEMAFULL;
DEFINE FIELD a_actor ON carbon_transaction TYPE record<department | employee> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_profile ON carbon_transaction TYPE record<product_esg_profile> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON carbon_transaction TYPE decimal ASSERT $value > 0dec;

DEFINE FIELD d1_co2e ON carbon_transaction TYPE decimal VALUE ($this.a_qty * $this.a_profile.a_emission_factor.a_co2e_per_unit);
DEFINE FIELD d2_xp_penalty ON carbon_transaction TYPE decimal VALUE ($this.a_qty * $this.a_profile.a_xp_penalty_per_unit);

DEFINE FIELD d3_actor_type ON carbon_transaction TYPE string VALUE record::tb($this.a_actor);


-- 2. CSR: Mints XP for participating
DEFINE TABLE csr_participation SCHEMAFULL;
DEFINE FIELD a_employee ON csr_participation TYPE record<employee> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_csr_activity ON csr_participation TYPE record<csr_activity> REFERENCE ON DELETE REJECT;

DEFINE FIELD d1_xp_earned ON csr_participation TYPE decimal VALUE $this.a_csr_activity.a_xp_reward;


-- 3. CHALLENGE: Mints XP for completing
DEFINE TABLE challenge_participation SCHEMAFULL;
DEFINE FIELD a_employee ON challenge_participation TYPE record<employee> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_challenge ON challenge_participation TYPE record<challenge> REFERENCE ON DELETE REJECT;

DEFINE FIELD d1_xp_earned ON challenge_participation TYPE decimal VALUE $this.a_challenge.a_xp_reward;


-- 4. GOVERNANCE: Acknowledging laws
DEFINE TABLE policy_ack SCHEMAFULL;
DEFINE FIELD a_employee ON policy_ack TYPE record<employee> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_policy ON policy_ack TYPE record<esg_policy> REFERENCE ON DELETE REJECT;


-- 5. GOVERNANCE: Breaking laws
DEFINE TABLE compliance_issue SCHEMAFULL;
DEFINE FIELD a_audit ON compliance_issue TYPE record<audit> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_employee ON compliance_issue TYPE record<employee> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_is_open ON compliance_issue TYPE bool DEFAULT true;

DEFINE FIELD e_guard ON compliance_issue TYPE bool VALUE {
    -- Ensure graph integrity: The employee must belong to the department being audited.
    IF $this.a_employee.a_department != $this.a_audit.a_department {
        THROW "DAG FRACTURE: The employee must belong to the audited department.";
    };
    RETURN true;
} ASSERT $value = true;


-- 6. REWARD: Spends XP to acquire physical/digital items
DEFINE TABLE reward_redemption SCHEMAFULL;
DEFINE FIELD a_employee ON reward_redemption TYPE record<employee> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_reward ON reward_redemption TYPE record<reward> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON reward_redemption TYPE int ASSERT $value > 0;

DEFINE FIELD d1_xp_spent ON reward_redemption TYPE decimal VALUE ($this.a_qty * $this.a_reward.a_xp_cost);

DEFINE FIELD e_guard ON reward_redemption TYPE bool VALUE {
    -- GUARD 1: Insufficient Funds (Math Constraint)
    LET $wallet = (type::record('v_employee_wallet', [$this.a_employee.id])).available_xp ?? 0dec;
    IF ($wallet - $this.d1_xp_spent) < 0dec {
        THROW "MATH_ERR: Insufficient XP to redeem this reward. Participate in more activities or reduce carbon emissions.";
    };
    
    -- GUARD 2: Out of Stock (Physics Constraint)
    LET $redeemed_so_far = (type::record('v_reward_inventory', [$this.a_reward.id])).redeemed_qty ?? 0;
    LET $remaining_stock = $this.a_reward.a_initial_stock - $redeemed_so_far;
    IF ($remaining_stock - $this.a_qty) < 0 {
        THROW "PHYSICS_ERR: This reward is out of stock.";
    };

    RETURN true;
} ASSERT $value = true;