-- ==============================================================================
-- FILE 06: TABLE FIELDS (ESG ONTOLOGY)
-- DEPENDENCIES: ReBase Core (user, groups) & CRM (product, order_line)
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- LEVEL 0: CLASSIFICATION SETS (Constants & Multipliers)
-- ==============================================================================

DEFINE TABLE esg_category SCHEMAFULL;
DEFINE FIELD a_name ON esg_category TYPE string;
DEFINE FIELD a_type ON esg_category TYPE string ASSERT $value IN ['CSR', 'Challenge', 'Governance'];
DEFINE FIELD a_color ON esg_category TYPE string DEFAULT '#000000';

DEFINE TABLE emission_factor SCHEMAFULL;
DEFINE FIELD a_name ON emission_factor TYPE string;
DEFINE FIELD a_unit_of_measure ON emission_factor TYPE string; -- e.g., 'kg', 'kWh', 'liters'
DEFINE FIELD a_co2e_per_unit ON emission_factor TYPE decimal ASSERT $value >= 0dec;

DEFINE TABLE badge SCHEMAFULL;
DEFINE FIELD a_name ON badge TYPE string;
DEFINE FIELD a_description ON badge TYPE string;
DEFINE FIELD a_icon_url ON badge TYPE string DEFAULT "";
DEFINE FIELD a_unlock_xp ON badge TYPE decimal DEFAULT 0dec ASSERT $value >= 0dec;

DEFINE TABLE reward SCHEMAFULL;
DEFINE FIELD a_name ON reward TYPE string;
DEFINE FIELD a_description ON reward TYPE string;
DEFINE FIELD a_points_required ON reward TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_initial_stock ON reward TYPE int ASSERT $value >= 0;


-- ==============================================================================
-- LEVEL 1: INDEPENDENT ANCHORS (Targets & Policies)
-- ==============================================================================

DEFINE TABLE esg_policy SCHEMAFULL;
DEFINE FIELD a_name ON esg_policy TYPE string;
DEFINE FIELD a_version ON esg_policy TYPE string DEFAULT "1.0";
DEFINE FIELD a_content ON esg_policy TYPE string;
DEFINE FIELD a_is_active ON esg_policy TYPE bool DEFAULT true;

DEFINE TABLE esg_goal SCHEMAFULL;
-- Note: 'owned_by' (group/dept) is automatically injected by the ReBase compiler.
-- This goal therefore inherently belongs to a specific Department/Group.
DEFINE FIELD a_name ON esg_goal TYPE string;
DEFINE FIELD a_target_co2e ON esg_goal TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD a_target_date ON esg_goal TYPE datetime;

-- Cross-Domain Link: Attaches ESG physics to the CRM Catalog
DEFINE TABLE product_esg_profile SCHEMAFULL;
DEFINE FIELD a_product ON product_esg_profile TYPE record<product> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_default_emission_factor ON product_esg_profile TYPE record<emission_factor> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_material_recyclability_pct ON product_esg_profile TYPE int DEFAULT 0 ASSERT $value >= 0 AND $value <= 100;


-- ==============================================================================
-- LEVEL 2: RELATIONAL BRANCHES (Initiatives & Audits)
-- ==============================================================================

DEFINE TABLE csr_activity SCHEMAFULL;
DEFINE FIELD a_name ON csr_activity TYPE string;
DEFINE FIELD a_category ON csr_activity TYPE record<esg_category> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_base_points ON csr_activity TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_requires_evidence ON csr_activity TYPE bool DEFAULT false;
DEFINE FIELD a_is_active ON csr_activity TYPE bool DEFAULT true;

DEFINE TABLE challenge SCHEMAFULL;
DEFINE FIELD a_title ON challenge TYPE string;
DEFINE FIELD a_category ON challenge TYPE record<esg_category> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_description ON challenge TYPE string;
DEFINE FIELD a_xp_reward ON challenge TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_requires_evidence ON challenge TYPE bool DEFAULT true;
DEFINE FIELD a_deadline ON challenge TYPE datetime;
DEFINE FIELD a_is_active ON challenge TYPE bool DEFAULT true;

DEFINE TABLE audit SCHEMAFULL;
DEFINE FIELD a_name ON audit TYPE string;
DEFINE FIELD a_auditor ON audit TYPE record<user> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_audit_date ON audit TYPE datetime DEFAULT time::now();


-- ==============================================================================
-- LEVEL 3: TRANSACTIONAL LEAVES (The Mathematical Ledgers)
-- ==============================================================================

-- 1. THE CARBON LEDGER
DEFINE TABLE carbon_transaction SCHEMAFULL;
-- Polymorphic root allows carbon to be emitted by an Order Line, a Product, or manual entry
DEFINE FIELD a_source ON carbon_transaction TYPE option<record<order_line | product>> REFERENCE ON DELETE CASCADE DEFAULT NONE;
DEFINE FIELD a_emission_factor ON carbon_transaction TYPE record<emission_factor> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON carbon_transaction TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_date ON carbon_transaction TYPE datetime DEFAULT time::now();

DEFINE FIELD d1_total_co2e ON carbon_transaction TYPE decimal VALUE ($this.a_qty * $this.a_emission_factor.a_co2e_per_unit);


-- 2. THE SOCIAL / GAMIFICATION LEDGER
DEFINE TABLE csr_participation SCHEMAFULL;
DEFINE FIELD a_user ON csr_participation TYPE record<user> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_activity ON csr_participation TYPE record<csr_activity> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_proof_url ON csr_participation TYPE string DEFAULT "";
DEFINE FIELD a_status ON csr_participation TYPE string DEFAULT 'Pending' ASSERT $value IN ['Pending', 'Approved', 'Rejected'];

DEFINE FIELD d1_points ON csr_participation TYPE decimal VALUE IF $this.a_status = 'Approved' THEN $this.a_activity.a_base_points ELSE 0dec END;

DEFINE FIELD e_guard ON csr_participation TYPE bool VALUE {
    IF $this.a_activity.a_requires_evidence = true AND $this.a_status = 'Approved' AND string::len($this.a_proof_url) = 0 {
        THROW "COMPLIANCE_ERR: This CSR Activity requires evidence (proof_url) before it can be approved.";
    };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE challenge_participation SCHEMAFULL;
DEFINE FIELD a_user ON challenge_participation TYPE record<user> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_challenge ON challenge_participation TYPE record<challenge> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_proof_url ON challenge_participation TYPE string DEFAULT "";
DEFINE FIELD a_status ON challenge_participation TYPE string DEFAULT 'Pending' ASSERT $value IN ['Pending', 'Approved', 'Rejected'];

DEFINE FIELD d1_xp ON challenge_participation TYPE decimal VALUE IF $this.a_status = 'Approved' THEN $this.a_challenge.a_xp_reward ELSE 0dec END;
DEFINE FIELD d2_is_completed ON challenge_participation TYPE int VALUE IF $this.a_status = 'Approved' THEN 1 ELSE 0 END;

DEFINE FIELD e_guard ON challenge_participation TYPE bool VALUE {
    IF $this.a_challenge.a_requires_evidence = true AND $this.a_status = 'Approved' AND string::len($this.a_proof_url) = 0 {
        THROW "COMPLIANCE_ERR: This Challenge requires evidence (proof_url) before it can be approved.";
    };
    IF $this.a_status = 'Approved' AND time::now() > $this.a_challenge.a_deadline {
        THROW "TIME_ERR: Cannot approve a challenge past its deadline.";
    };
    RETURN true;
} ASSERT $value = true;


-- 3. THE ECONOMY LEDGER (Withdrawals)
DEFINE TABLE reward_redemption SCHEMAFULL;
DEFINE FIELD a_user ON reward_redemption TYPE record<user> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_reward ON reward_redemption TYPE record<reward> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON reward_redemption TYPE int ASSERT $value > 0;

DEFINE FIELD d1_total_cost ON reward_redemption TYPE decimal VALUE ($this.a_qty * $this.a_reward.a_points_required);

DEFINE FIELD e_guard ON reward_redemption TYPE bool VALUE {
    -- Absolute Wallet Matrix Guard
    LET $wallet = (type::record('v_user_wallet', [$this.a_user.id])).available_balance ?? 0dec;
    IF ($wallet - $this.d1_total_cost) < 0dec {
        THROW "MATH_ERR: Insufficient Points/XP to redeem this quantity of rewards.";
    };
    RETURN true;
} ASSERT $value = true;


-- 4. THE GOVERNANCE LEDGER
DEFINE TABLE policy_acknowledgement SCHEMAFULL;
DEFINE FIELD a_user ON policy_acknowledgement TYPE record<user> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_policy ON policy_acknowledgement TYPE record<esg_policy> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_acknowledged_at ON policy_acknowledgement TYPE datetime DEFAULT time::now();

-- Compound index ensuring a user can only acknowledge a specific policy version once
DEFINE INDEX idx_unique_policy_ack ON policy_acknowledgement COLUMNS a_user, a_policy UNIQUE;


DEFINE TABLE compliance_issue SCHEMAFULL;
DEFINE FIELD a_audit ON compliance_issue TYPE record<audit> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_owner ON compliance_issue TYPE record<user> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_description ON compliance_issue TYPE string;
DEFINE FIELD a_severity ON compliance_issue TYPE string ASSERT $value IN ['Low', 'Medium', 'High', 'Critical'];
DEFINE FIELD a_due_date ON compliance_issue TYPE datetime;
DEFINE FIELD a_status ON compliance_issue TYPE string DEFAULT 'Open' ASSERT $value IN ['Open', 'In Progress', 'Closed'];

DEFINE FIELD d1_is_overdue ON compliance_issue TYPE int VALUE IF time::now() > $this.a_due_date AND $this.a_status != 'Closed' THEN 1 ELSE 0 END;
DEFINE FIELD d2_is_open ON compliance_issue TYPE int VALUE IF $this.a_status != 'Closed' THEN 1 ELSE 0 END;

DEFINE FIELD e_guard ON compliance_issue TYPE bool VALUE {
    -- Since the ReBase compiler injects 'owned_by' on every table based on the creator or upstream parent,
    -- this guard ensures the targeted user (owner of the issue) actually belongs to the department (group) 
    -- that the audit was conducted on. DAG Fracture prevented.
    IF $this.a_owner.parents NOT CONTAINSANY $this.a_audit.owned_by {
        THROW "DAG FRACTURE: The assigned owner of this issue does not belong to the Group/Department being audited.";
    };
    RETURN true;
} ASSERT $value = true;