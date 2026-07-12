-- ==============================================================================
-- FILE 06: TABLE FIELDS (UNIVERSAL ESG LEDGER & DAG)
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- LEVEL 0: TAXONOMY & INDEPENDENT ANCHORS
-- ==============================================================================

-- 1. Taxonomy Engine (The Universal Classifier)
DEFINE TABLE category SCHEMAFULL;
DEFINE FIELD a_name ON category TYPE string;
DEFINE FIELD a_target_table ON category TYPE string; 
-- ^ Determines which table this category is allowed to classify (e.g., 'esg_tx', 'reward', 'challenge')

-- 2. Master Anchors
DEFINE TABLE badge SCHEMAFULL;
DEFINE FIELD a_name ON badge TYPE string;
DEFINE FIELD a_required_xp ON badge TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON badge TYPE string DEFAULT 'Active';
DEFINE FIELD a_category ON badge TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON badge TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'badge' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE reward SCHEMAFULL;
DEFINE FIELD a_name ON reward TYPE string;
DEFINE FIELD a_xp_cost ON reward TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_initial_stock ON reward TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD a_status ON reward TYPE string DEFAULT 'Active';
DEFINE FIELD a_category ON reward TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON reward TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'reward' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE challenge SCHEMAFULL;
DEFINE FIELD a_name ON challenge TYPE string;
DEFINE FIELD a_xp_reward ON challenge TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON challenge TYPE string DEFAULT 'Draft';
DEFINE FIELD a_category ON challenge TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON challenge TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'challenge' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE csr_activity SCHEMAFULL;
DEFINE FIELD a_name ON csr_activity TYPE string;
DEFINE FIELD a_xp_reward ON csr_activity TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON csr_activity TYPE string DEFAULT 'Draft';
DEFINE FIELD a_category ON csr_activity TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON csr_activity TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'csr_activity' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE esg_policy SCHEMAFULL;
DEFINE FIELD a_name ON esg_policy TYPE string;
DEFINE FIELD a_status ON esg_policy TYPE string DEFAULT 'Active';
DEFINE FIELD a_category ON esg_policy TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON esg_policy TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'esg_policy' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE audit SCHEMAFULL;
DEFINE FIELD a_name ON audit TYPE string;
DEFINE FIELD a_status ON audit TYPE string DEFAULT 'Pending';
DEFINE FIELD a_category ON audit TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON audit TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'audit' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE product SCHEMAFULL;
DEFINE FIELD a_name ON product TYPE string;
DEFINE FIELD a_status ON product TYPE string DEFAULT 'Active';
DEFINE FIELD a_category ON product TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON product TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'product' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE emission_factor SCHEMAFULL;
DEFINE FIELD a_name ON emission_factor TYPE string;
DEFINE FIELD a_co2e_per_unit ON emission_factor TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD a_status ON emission_factor TYPE string DEFAULT 'Active';
DEFINE FIELD a_category ON emission_factor TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON emission_factor TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'emission_factor' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


-- ==============================================================================
-- LEVEL 1: CONTEXTUAL BRANCHES
-- ==============================================================================

DEFINE TABLE product_esg_profile SCHEMAFULL;
DEFINE FIELD a_product ON product_esg_profile TYPE record<product> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_emission_factor ON product_esg_profile TYPE record<emission_factor> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_xp_penalty_per_unit ON product_esg_profile TYPE decimal DEFAULT 0dec ASSERT $value >= 0dec;
DEFINE FIELD a_status ON product_esg_profile TYPE string DEFAULT 'Active';
DEFINE FIELD a_category ON product_esg_profile TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON product_esg_profile TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'product_esg_profile' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE environmental_goal SCHEMAFULL;
DEFINE FIELD a_target_co2e ON environmental_goal TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON environmental_goal TYPE string DEFAULT 'Active';
DEFINE FIELD a_category ON environmental_goal TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE FIELD e_guard ON environmental_goal TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'environmental_goal' { THROW "TAXONOMY_ERR: Category mismatch."; };
    RETURN true;
} ASSERT $value = true;


-- ==============================================================================
-- LEVEL 2: THE UNIVERSAL ESG LEDGER (Mathematical Leaves)
-- ==============================================================================

DEFINE TABLE esg_tx SCHEMAFULL;
DEFINE FIELD a_from ON esg_tx TYPE record<user> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_to ON esg_tx TYPE record<product_esg_profile | reward | challenge | csr_activity | esg_policy | audit> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON esg_tx TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON esg_tx TYPE string DEFAULT 'Pending';
DEFINE FIELD a_category ON esg_tx TYPE option<record<category>> REFERENCE ON DELETE REJECT DEFAULT NONE;

-- Absolute Deterministic Math (O(1) Resolution based on target Node)
DEFINE FIELD d1_target_tb ON esg_tx TYPE string VALUE record::tb($this.a_to);

DEFINE FIELD d2_xp_earned ON esg_tx TYPE decimal VALUE 
    IF $this.d1_target_tb IN ['challenge', 'csr_activity'] THEN ($this.a_qty * ($this.a_to.a_xp_reward ?? 0dec))
    ELSE 0dec END;

DEFINE FIELD d3_xp_spent ON esg_tx TYPE decimal VALUE 
    IF $this.d1_target_tb = 'reward' THEN ($this.a_qty * ($this.a_to.a_xp_cost ?? 0dec))
    ELSE IF $this.d1_target_tb = 'product_esg_profile' THEN ($this.a_qty * ($this.a_to.a_xp_penalty_per_unit ?? 0dec))
    ELSE 0dec END;

DEFINE FIELD d4_net_xp ON esg_tx TYPE decimal VALUE ($this.d2_xp_earned - $this.d3_xp_spent);

DEFINE FIELD d5_co2e ON esg_tx TYPE decimal VALUE 
    IF $this.d1_target_tb = 'product_esg_profile' THEN ($this.a_qty * ($this.a_to.a_emission_factor.a_co2e_per_unit ?? 0dec))
    ELSE 0dec END;

DEFINE FIELD e_guard ON esg_tx TYPE bool VALUE {
    IF $this.a_category != NONE AND $this.a_category.a_target_table != 'esg_tx' { THROW "TAXONOMY_ERR: Category mismatch on Ledger Transaction."; };
    RETURN true;
} ASSERT $value = true;