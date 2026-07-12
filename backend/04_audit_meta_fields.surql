USE NS main DB main;

DEFINE FIELD OVERWRITE created_at ON TABLE category TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE category TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE category TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE category TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE badge TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE badge TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE badge TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE badge TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE challenge TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE challenge TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE challenge TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE challenge TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE csr_activity TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE csr_activity TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE csr_activity TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE csr_activity TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE esg_policy TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE esg_policy TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE esg_policy TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE esg_policy TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE audit TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE audit TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE audit TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE audit TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE product TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE product TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE product TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE product TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE emission_factor TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE emission_factor TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE emission_factor TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE emission_factor TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE product_esg_profile TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE product_esg_profile TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE product_esg_profile TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE product_esg_profile TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE environmental_goal TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE environmental_goal TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE environmental_goal TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE environmental_goal TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE reward TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE reward TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE reward TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE reward TYPE option<record<user>> VALUE $auth;

-- DEFINE FIELD OVERWRITE created_at ON TABLE user TYPE datetime VALUE $before OR time::now() READONLY;
-- DEFINE FIELD OVERWRITE updated_at ON TABLE user TYPE datetime VALUE time::now();
-- DEFINE FIELD OVERWRITE created_by ON TABLE user TYPE option<record<user>> VALUE $before OR $auth READONLY;
-- DEFINE FIELD OVERWRITE updated_by ON TABLE user TYPE option<record<user>> VALUE $auth;

-- DEFINE FIELD OVERWRITE created_at ON TABLE groups TYPE datetime VALUE $before OR time::now() READONLY;
-- DEFINE FIELD OVERWRITE updated_at ON TABLE groups TYPE datetime VALUE time::now();
-- DEFINE FIELD OVERWRITE created_by ON TABLE groups TYPE option<record<user>> VALUE $before OR $auth READONLY;
-- DEFINE FIELD OVERWRITE updated_by ON TABLE groups TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE esg_tx TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE esg_tx TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE esg_tx TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE esg_tx TYPE option<record<user>> VALUE $auth;

