USE NS main DB main;

DEFINE INDEX idx_badge_a_category ON badge COLUMNS a_category;
DEFINE INDEX idx_challenge_a_category ON challenge COLUMNS a_category;
DEFINE INDEX idx_csr_activity_a_category ON csr_activity COLUMNS a_category;
DEFINE INDEX idx_esg_policy_a_category ON esg_policy COLUMNS a_category;
DEFINE INDEX idx_audit_a_category ON audit COLUMNS a_category;
DEFINE INDEX idx_product_a_category ON product COLUMNS a_category;
DEFINE INDEX idx_emission_factor_a_category ON emission_factor COLUMNS a_category;
DEFINE INDEX idx_product_esg_profile_a_product ON product_esg_profile COLUMNS a_product;
DEFINE INDEX idx_product_esg_profile_a_emission_factor ON product_esg_profile COLUMNS a_emission_factor;
DEFINE INDEX idx_product_esg_profile_a_category ON product_esg_profile COLUMNS a_category;
DEFINE INDEX idx_environmental_goal_a_category ON environmental_goal COLUMNS a_category;
DEFINE INDEX idx_reward_a_category ON reward COLUMNS a_category;
DEFINE INDEX idx_esg_tx_a_from ON esg_tx COLUMNS a_from;
DEFINE INDEX idx_esg_tx_a_to ON esg_tx COLUMNS a_to;
DEFINE INDEX idx_esg_tx_a_category ON esg_tx COLUMNS a_category;
