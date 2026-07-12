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
DEFINE FIELD e_guard ON badge TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'badge' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;

DEFINE TABLE challenge SCHEMAFULL;
DEFINE FIELD a_name ON challenge TYPE string;
DEFINE FIELD a_xp_reward ON challenge TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON challenge TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON challenge TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD e_guard ON challenge TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'challenge' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;

DEFINE TABLE csr_activity SCHEMAFULL;
DEFINE FIELD a_name ON csr_activity TYPE string;
DEFINE FIELD a_xp_reward ON csr_activity TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON csr_activity TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON csr_activity TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD e_guard ON csr_activity TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'csr_activity' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;

DEFINE TABLE esg_policy SCHEMAFULL;
DEFINE FIELD a_name ON esg_policy TYPE string;
DEFINE FIELD a_status ON esg_policy TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON esg_policy TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD e_guard ON esg_policy TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'esg_policy' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;

DEFINE TABLE audit SCHEMAFULL;
DEFINE FIELD a_name ON audit TYPE string;
DEFINE FIELD a_status ON audit TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON audit TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD e_guard ON audit TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'audit' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;

DEFINE TABLE product SCHEMAFULL;
DEFINE FIELD a_name ON product TYPE string;
DEFINE FIELD a_status ON product TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON product TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD e_guard ON product TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'product' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;

DEFINE TABLE emission_factor SCHEMAFULL;
DEFINE FIELD a_name ON emission_factor TYPE string;
DEFINE FIELD a_co2e_per_unit ON emission_factor TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD a_status ON emission_factor TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON emission_factor TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD e_guard ON emission_factor TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'emission_factor' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


-- ==============================================================================
-- LEVEL 1: CONTEXTUAL BRANCHES & DERIVED PARENTS
-- ==============================================================================
DEFINE TABLE product_esg_profile SCHEMAFULL;
DEFINE FIELD a_product ON product_esg_profile TYPE record<product> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_emission_factor ON product_esg_profile TYPE record<emission_factor> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_xp_penalty_per_unit ON product_esg_profile TYPE decimal DEFAULT 0dec ASSERT $value >= 0dec;
DEFINE FIELD a_status ON product_esg_profile TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON product_esg_profile TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD e_guard ON product_esg_profile TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'product_esg_profile' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;

DEFINE TABLE environmental_goal SCHEMAFULL;
DEFINE FIELD a_target_co2e ON environmental_goal TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON environmental_goal TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON environmental_goal TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD e_guard ON environmental_goal TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'environmental_goal' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;

-- Reward Engine (Self-Resolving Inventory)
DEFINE TABLE reward SCHEMAFULL;
DEFINE FIELD a_name ON reward TYPE string;
DEFINE FIELD a_xp_cost ON reward TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_total_stock ON reward TYPE decimal ASSERT $value >= 0dec AND math::floor($value) = $value;
DEFINE FIELD a_status ON reward TYPE string ASSERT $value IN ['Draft', 'Active', 'Archived'] DEFAULT 'Active';
DEFINE FIELD a_category ON reward TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD d1_remaining_stock ON reward TYPE decimal VALUE {
    LET $rec = type::record('v_tx_to', [$this.id, -1]);
    RETURN IF record::exists($rec) THEN ($this.a_total_stock - ($rec.total_qty ?? 0dec)) ELSE $this.a_total_stock END;
};
DEFINE FIELD e_guard ON reward TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'reward' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


-- ==============================================================================
-- LEVEL 2: SYSTEM ACTORS (Graph Upward Propagation Nodes)
-- ==============================================================================
-- Extending base RBAC tables to house the derived states natively.

DEFINE TABLE user SCHEMAFULL;
DEFINE FIELD d1_net_xp ON user TYPE decimal VALUE {
    LET $mint = type::record('v_tx_from', [$this.id, 1]);
    LET $burn = type::record('v_tx_from', [$this.id, -1]);
    LET $mint_val = IF record::exists($mint) THEN ($mint.net_xp ?? 0dec) ELSE 0dec END;
    LET $burn_val = IF record::exists($burn) THEN ($burn.net_xp ?? 0dec) ELSE 0dec END;
    RETURN $mint_val + $burn_val;
};
DEFINE FIELD d2_total_co2e ON user TYPE decimal VALUE {
    LET $rec = type::record('v_tx_from', [$this.id, -1]);
    RETURN IF record::exists($rec) THEN ($rec.total_co2e ?? 0dec) ELSE 0dec END;
};

DEFINE TABLE groups SCHEMAFULL;
DEFINE FIELD d1_net_xp ON groups TYPE decimal VALUE {
    LET $rec = type::record('v_user_group', [$this.id]);
    RETURN IF record::exists($rec) THEN ($rec.net_xp ?? 0dec) ELSE 0dec END;
};
DEFINE FIELD d2_total_co2e ON groups TYPE decimal VALUE {
    LET $rec = type::record('v_user_group', [$this.id]);
    RETURN IF record::exists($rec) THEN ($rec.total_co2e ?? 0dec) ELSE 0dec END;
};


-- ==============================================================================
-- LEVEL 3: THE UNIVERSAL VECTOR LEDGER
-- ==============================================================================
DEFINE TABLE esg_tx SCHEMAFULL;
DEFINE FIELD a_from ON esg_tx TYPE record<user> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_to ON esg_tx TYPE record<product_esg_profile | reward | challenge | csr_activity | esg_policy | audit> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON esg_tx TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON esg_tx TYPE string ASSERT $value IN ['Draft', 'Posted', 'Cancelled'] DEFAULT 'Draft';
DEFINE FIELD a_category ON esg_tx TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

-- FX Rates inherited securely from parent context
DEFINE FIELD a_xp_rate ON esg_tx TYPE decimal VALUE $this.a_to.a_xp_cost ?? $this.a_to.a_xp_reward ?? $this.a_to.a_xp_penalty_per_unit ?? 0dec;
DEFINE FIELD a_co2e_rate ON esg_tx TYPE decimal VALUE $this.a_to.a_emission_factor.a_co2e_per_unit ?? 0dec;

-- The Physics Vector (-1 for Burns/Penalties, 1 for Mints/Awards)
DEFINE FIELD d1_target_tb ON esg_tx TYPE string VALUE record::tb($this.a_to);
DEFINE FIELD d2_vector ON esg_tx TYPE int VALUE 
    IF $this.d1_target_tb IN ['challenge', 'csr_activity'] THEN 1 
    ELSE IF $this.d1_target_tb IN ['reward', 'product_esg_profile'] THEN -1 
    ELSE 0 END;

-- Absolute Ledger Math
DEFINE FIELD d3_raw_xp ON esg_tx TYPE decimal VALUE ($this.a_qty * $this.a_xp_rate);
DEFINE FIELD d4_net_xp ON esg_tx TYPE decimal VALUE ($this.d3_raw_xp * $this.d2_vector);
DEFINE FIELD d5_raw_co2e ON esg_tx TYPE decimal VALUE ($this.a_qty * $this.a_co2e_rate);

-- Internal Matrix Guard
DEFINE FIELD e_guard ON esg_tx TYPE bool VALUE {
    -- 0. Taxonomy Constraint
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'esg_tx' { THROW "TAXONOMY_ERR: Category mismatch."; };

    -- 1. Discrete Physical Constraint
    IF $this.d1_target_tb = 'reward' AND math::floor($this.a_qty) != $this.a_qty {
        THROW "PHYSICS_ERR: Redemptions must use exact integer quantities.";
    };

    -- 2. Prevent Overspending via the Parent's Derived State
    IF $this.d1_target_tb = 'reward' {
        LET $remaining = $this.a_to.d1_remaining_stock ?? 0dec;
        IF ($remaining - $this.a_qty) < 0dec {
            THROW "PHYSICS_ERR: This Reward is out of stock.";
        };
    };

    -- 3. Prevent Negative Wallet via the Sender's Derived State
    IF $this.d2_vector = -1 {
        LET $wallet = $this.a_from.d1_net_xp ?? 0dec;
        IF ($wallet + $this.d4_net_xp) < 0dec { 
            THROW "MATH_ERR: Insufficient XP Wallet balance."; 
        };
    };

    RETURN true;
} ASSERT $value = true;