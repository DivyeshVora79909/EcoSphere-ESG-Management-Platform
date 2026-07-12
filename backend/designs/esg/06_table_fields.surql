-- ==============================================================================
-- FILE 06: TABLE FIELDS (ESG ONTOLOGY & DAG STRUCTURE)
-- ==============================================================================
USE NS main DB main;

-- ==============================================================================
-- LEVEL 0: LOOKUPS & CLASSIFICATIONS (Stateless Enums)
-- ==============================================================================

DEFINE TABLE esg_status SCHEMAFULL;
DEFINE FIELD a_name ON esg_status TYPE string;
DEFINE FIELD a_color ON esg_status TYPE string DEFAULT '#000000';

DEFINE TABLE esg_category SCHEMAFULL;
DEFINE FIELD a_name ON esg_category TYPE string;
DEFINE FIELD a_type ON esg_category TYPE string ASSERT $value IN ['CSR', 'Challenge', 'General'];

DEFINE TABLE emission_factor SCHEMAFULL;
DEFINE FIELD a_name ON emission_factor TYPE string;
DEFINE FIELD a_unit ON emission_factor TYPE string; -- e.g., 'kg', 'liters', 'kWh'
DEFINE FIELD a_co2e_per_unit ON emission_factor TYPE decimal ASSERT $value >= 0dec;

DEFINE TABLE badge SCHEMAFULL;
DEFINE FIELD a_name ON badge TYPE string;
DEFINE FIELD a_description ON badge TYPE string;
DEFINE FIELD a_icon ON badge TYPE string;
DEFINE FIELD a_target_xp ON badge TYPE decimal DEFAULT 0dec;
DEFINE FIELD a_target_challenges ON badge TYPE int DEFAULT 0;

DEFINE TABLE reward SCHEMAFULL;
DEFINE FIELD a_name ON reward TYPE string;
DEFINE FIELD a_description ON reward TYPE string;
DEFINE FIELD a_points_required ON reward TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_initial_stock ON reward TYPE int ASSERT $value >= 0;
DEFINE FIELD a_status ON reward TYPE option<record<esg_status>> REFERENCE ON DELETE REJECT DEFAULT NONE;


-- ==============================================================================
-- LEVEL 1: INDEPENDENT ANCHORS (The Master Data)
-- ==============================================================================

DEFINE TABLE department SCHEMAFULL;
DEFINE FIELD a_name ON department TYPE string;
DEFINE FIELD a_code ON department TYPE string;
DEFINE FIELD a_parent_department ON department TYPE option<record<department>> REFERENCE ON DELETE REJECT DEFAULT NONE;
DEFINE FIELD a_status ON department TYPE option<record<esg_status>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE employee SCHEMAFULL;
DEFINE FIELD a_name ON employee TYPE string;
DEFINE FIELD a_department ON employee TYPE record<department> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_status ON employee TYPE option<record<esg_status>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE environmental_goal SCHEMAFULL;
DEFINE FIELD a_name ON environmental_goal TYPE string;
DEFINE FIELD a_department ON environmental_goal TYPE option<record<department>> REFERENCE ON DELETE CASCADE DEFAULT NONE;
DEFINE FIELD a_target_carbon_co2e ON environmental_goal TYPE decimal ASSERT $value >= 0dec;
DEFINE FIELD a_deadline ON environmental_goal TYPE datetime;

DEFINE TABLE esg_policy SCHEMAFULL;
DEFINE FIELD a_name ON esg_policy TYPE string;
DEFINE FIELD a_content ON esg_policy TYPE string;
DEFINE FIELD a_version ON esg_policy TYPE string;


-- ==============================================================================
-- LEVEL 2: RELATIONAL BRANCHES (Projects & Definitions)
-- ==============================================================================

DEFINE TABLE csr_activity SCHEMAFULL;
DEFINE FIELD a_name ON csr_activity TYPE string;
DEFINE FIELD a_category ON csr_activity TYPE record<esg_category> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_base_points ON csr_activity TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_status ON csr_activity TYPE option<record<esg_status>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE challenge SCHEMAFULL;
DEFINE FIELD a_title ON challenge TYPE string;
DEFINE FIELD a_category ON challenge TYPE record<esg_category> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_description ON challenge TYPE string;
DEFINE FIELD a_xp_reward ON challenge TYPE decimal ASSERT $value > 0dec;
DEFINE FIELD a_deadline ON challenge TYPE datetime;
DEFINE FIELD a_status ON challenge TYPE option<record<esg_status>> REFERENCE ON DELETE REJECT DEFAULT NONE;

DEFINE TABLE audit SCHEMAFULL;
DEFINE FIELD a_name ON audit TYPE string;
DEFINE FIELD a_department ON audit TYPE record<department> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_auditor ON audit TYPE record<employee> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_audit_date ON audit TYPE datetime DEFAULT time::now();


-- ==============================================================================
-- LEVEL 3: TRANSACTIONAL TREES (The Mathematical Lines)
-- ==============================================================================

DEFINE TABLE carbon_transaction SCHEMAFULL;
-- Polymorphic edge connecting ERP operations to ESG
DEFINE FIELD a_source ON carbon_transaction TYPE option<record<purchase | manufacturing | expense | fleet>> REFERENCE ON DELETE CASCADE DEFAULT NONE;
DEFINE FIELD a_department ON carbon_transaction TYPE record<department> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_emission_factor ON carbon_transaction TYPE record<emission_factor> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON carbon_transaction TYPE decimal ASSERT $value >= 0dec;

DEFINE FIELD d1_total_co2e ON carbon_transaction TYPE decimal VALUE ($this.a_qty * $this.a_emission_factor.a_co2e_per_unit);


DEFINE TABLE csr_participation SCHEMAFULL;
DEFINE FIELD a_employee ON csr_participation TYPE record<employee> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_csr_activity ON csr_participation TYPE record<csr_activity> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_proof_url ON csr_participation TYPE string DEFAULT "";
DEFINE FIELD a_status ON csr_participation TYPE record<esg_status> REFERENCE ON DELETE REJECT;

-- Deterministic Points: Only yield points if the status name is exactly 'Approved'
DEFINE FIELD d1_points_earned ON csr_participation TYPE decimal VALUE IF $this.a_status.a_name = 'Approved' THEN $this.a_csr_activity.a_base_points ELSE 0dec END;

DEFINE FIELD e_guard ON csr_participation TYPE bool VALUE {
    IF company:esg_settings.require_evidence = true AND $this.a_status.a_name = 'Approved' AND string::len($this.a_proof_url) = 0 {
        THROW "COMPLIANCE_ERR: Company policy requires a proof URL before a CSR activity can be approved.";
    };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE challenge_participation SCHEMAFULL;
DEFINE FIELD a_employee ON challenge_participation TYPE record<employee> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_challenge ON challenge_participation TYPE record<challenge> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_proof_url ON challenge_participation TYPE string DEFAULT "";
DEFINE FIELD a_status ON challenge_participation TYPE record<esg_status> REFERENCE ON DELETE REJECT;

-- Deterministic XP
DEFINE FIELD d1_xp_earned ON challenge_participation TYPE decimal VALUE IF $this.a_status.a_name = 'Approved' THEN $this.a_challenge.a_xp_reward ELSE 0dec END;
DEFINE FIELD d2_is_completed ON challenge_participation TYPE int VALUE IF $this.a_status.a_name = 'Approved' THEN 1 ELSE 0 END;

DEFINE FIELD e_guard ON challenge_participation TYPE bool VALUE {
    IF company:esg_settings.require_evidence = true AND $this.a_status.a_name = 'Approved' AND string::len($this.a_proof_url) = 0 {
        THROW "COMPLIANCE_ERR: Proof required to complete this challenge.";
    };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE policy_acknowledgement SCHEMAFULL;
DEFINE FIELD a_employee ON policy_acknowledgement TYPE record<employee> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_policy ON policy_acknowledgement TYPE record<esg_policy> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_acknowledged_at ON policy_acknowledgement TYPE datetime DEFAULT time::now();


DEFINE TABLE compliance_issue SCHEMAFULL;
DEFINE FIELD a_audit ON compliance_issue TYPE record<audit> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_owner ON compliance_issue TYPE record<employee> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_description ON compliance_issue TYPE string;
DEFINE FIELD a_severity ON compliance_issue TYPE string ASSERT $value IN ['Low', 'Medium', 'High', 'Critical'];
DEFINE FIELD a_due_date ON compliance_issue TYPE datetime;
DEFINE FIELD a_status ON compliance_issue TYPE record<esg_status> REFERENCE ON DELETE REJECT;

DEFINE FIELD d1_is_overdue ON compliance_issue TYPE int VALUE IF time::now() > $this.a_due_date AND $this.a_status.a_name != 'Closed' THEN 1 ELSE 0 END;
DEFINE FIELD d2_is_open ON compliance_issue TYPE int VALUE IF $this.a_status.a_name != 'Closed' THEN 1 ELSE 0 END;

DEFINE FIELD e_guard ON compliance_issue TYPE bool VALUE {
    IF $this.a_owner.a_department != $this.a_audit.a_department {
        THROW "DAG FRACTURE: The issue owner must belong to the department being audited.";
    };
    RETURN true;
} ASSERT $value = true;


DEFINE TABLE reward_redemption SCHEMAFULL;
DEFINE FIELD a_employee ON reward_redemption TYPE record<employee> REFERENCE ON DELETE CASCADE;
DEFINE FIELD a_reward ON reward_redemption TYPE record<reward> REFERENCE ON DELETE REJECT;
DEFINE FIELD a_qty ON reward_redemption TYPE int ASSERT $value > 0;
DEFINE FIELD a_date ON reward_redemption TYPE datetime DEFAULT time::now();

DEFINE FIELD d1_total_cost ON reward_redemption TYPE decimal VALUE ($this.a_qty * $this.a_reward.a_points_required);

DEFINE FIELD e_guard ON reward_redemption TYPE bool VALUE {
    LET $wallet = (type::record('v_employee_wallet', [$this.a_employee.id])).available_balance ?? 0dec;
    IF ($wallet - $this.d1_total_cost) < 0dec {
        THROW "MATH_ERR: Insufficient Points/XP to redeem this reward.";
    };
    RETURN true;
} ASSERT $value = true;