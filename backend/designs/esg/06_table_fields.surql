-- ==============================================================================
-- FILE 06: TABLE FIELDS (THE VECTOR-BASED ESG LEDGER)
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- LEVEL 0: TAXONOMY & INDEPENDENT ANCHORS
-- ==============================================================================
DEFINE TABLE category SCHEMAFULL;
DEFINE FIELD a_name ON category TYPE string;
DEFINE FIELD a_target_table ON category TYPE string;

DEFINE TABLE badge SCHEMAFULL;
DEFINE FIELD a_name ON badge TYPE string;
DEFINE FIELD a_required_xp ON badge TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON badge TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON badge TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE reward SCHEMAFULL;
DEFINE FIELD a_name ON reward TYPE string;
DEFINE FIELD a_xp_cost ON reward TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_total_stock ON reward TYPE decimal ASSERT $value >= 0dec AND math::floor($value) = $value;
DEFINE FIELD a_status ON reward TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON reward TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE challenge SCHEMAFULL;
DEFINE FIELD a_name ON challenge TYPE string;
DEFINE FIELD a_xp_reward ON challenge TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON challenge TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON challenge TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE csr_activity SCHEMAFULL;
DEFINE FIELD a_name ON csr_activity TYPE string;
DEFINE FIELD a_xp_reward ON csr_activity TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON csr_activity TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON csr_activity TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE esg_policy SCHEMAFULL;
DEFINE FIELD a_name ON esg_policy TYPE string;
DEFINE FIELD a_status ON esg_policy TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON esg_policy TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE audit SCHEMAFULL;
DEFINE FIELD a_name ON audit TYPE string;
DEFINE FIELD a_status ON audit TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON audit TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE product SCHEMAFULL;
DEFINE FIELD a_name ON product TYPE string;
DEFINE FIELD a_status ON product TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON product TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE emission_factor SCHEMAFULL;
DEFINE FIELD a_name ON emission_factor TYPE string;
DEFINE FIELD a_co2e_per_unit ON emission_factor TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD a_status ON emission_factor TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON emission_factor TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;


-- ==============================================================================
-- LEVEL 1: CONTEXTUAL BRANCHES
-- ==============================================================================
DEFINE TABLE product_esg_profile SCHEMAFULL;
DEFINE FIELD a_product ON product_esg_profile TYPE record<product> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_emission_factor ON product_esg_profile TYPE record<emission_factor> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_xp_penalty_per_unit ON product_esg_profile TYPE decimal DEFAULT 0dec ASSERT $value >= 0dec;
DEFINE FIELD a_status ON product_esg_profile TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON product_esg_profile TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE environmental_goal SCHEMAFULL;
DEFINE FIELD a_target_co2e ON environmental_goal TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON environmental_goal TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON environmental_goal TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;


-- ==============================================================================
-- LEVEL 2: THE UNIVERSAL VECTOR LEDGER
-- ==============================================================================
DEFINE TABLE esg_tx SCHEMAFULL;
DEFINE FIELD a_from ON esg_tx TYPE record<user> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_to ON esg_tx TYPE record<product_esg_profile | reward | challenge | csr_activity | esg_policy | audit> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON esg_tx TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON esg_tx TYPE string ASSERT $value IN ['Draft', 'Posted', 'Cancelled'] DEFAULT 'Draft';
DEFINE FIELD a_category ON esg_tx TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

-- Inherit FX Rates at the time of transaction
DEFINE FIELD a_xp_rate ON esg_tx TYPE decimal VALUE $this.a_to.a_xp_cost ?? $this.a_to.a_xp_reward ?? $this.a_to.a_xp_penalty_per_unit ?? 0dec;
DEFINE FIELD a_co2e_rate ON esg_tx TYPE decimal VALUE $this.a_to.a_emission_factor.a_co2e_per_unit ?? 0dec;

-- Vector Engine
DEFINE FIELD d1_target_tb ON esg_tx TYPE string VALUE record::tb($this.a_to);
DEFINE FIELD d2_vector ON esg_tx TYPE int VALUE 
    IF $this.d1_target_tb IN ['challenge', 'csr_activity'] THEN 1 
    ELSE IF $this.d1_target_tb IN ['reward', 'product_esg_profile'] THEN -1 
    ELSE 0 END;

-- Base Values
DEFINE FIELD d3_raw_xp ON esg_tx TYPE decimal VALUE ($this.a_qty * $this.a_xp_rate);
DEFINE FIELD d4_net_xp ON esg_tx TYPE decimal VALUE ($this.d3_raw_xp * $this.d2_vector);
DEFINE FIELD d5_raw_co2e ON esg_tx TYPE decimal VALUE ($this.a_qty * $this.a_co2e_rate);

-- Absolute Physics Engine (Internal Guardrails)
DEFINE FIELD e_guard ON esg_tx TYPE bool VALUE {
    -- 1. Discrete Math Assertion
    IF $this.d1_target_tb = 'reward' AND math::floor($this.a_qty) != $this.a_qty {
        THROW "PHYSICS_ERR: Reward redemptions must use discrete integer quantities.";
    };

    -- 2. Wallet Balance Guard (Upward View Resolution)
    LET $wallet_balance = (type::record('v_tx_from_posted', [$this.a_from.id])).net_xp ?? 0dec;
    IF $wallet_balance < 0dec {
        THROW "MATH_ERR: Transaction reversed. User XP Wallet dropped below zero.";
    };

    -- 3. Stock Limit Guard (Upward View Resolution)
    IF $this.d1_target_tb = 'reward' {
        LET $consumed = (type::record('v_tx_to_posted', [$this.a_to.id])).total_qty ?? 0dec;
        IF ($this.a_to.a_total_stock - $consumed) < 0dec {
            THROW "PHYSICS_ERR: Transaction reversed. Reward stock depleted.";
        };
    };

    RETURN true;
} ASSERT $value = true;