USE NS main DB main;

DEFINE FIELD OVERWRITE created_at ON TABLE lifecycle_status TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE lifecycle_status TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE lifecycle_status TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE lifecycle_status TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE opportunity_status TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE opportunity_status TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE opportunity_status TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE opportunity_status TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE task_status TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE task_status TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE task_status TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE task_status TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE quote_status TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE quote_status TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE quote_status TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE quote_status TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE order_status TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE order_status TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE order_status TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE order_status TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE priority TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE priority TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE priority TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE priority TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE rating TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE rating TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE rating TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE rating TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE activity_type TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE activity_type TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE activity_type TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE activity_type TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE campaign_type TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE campaign_type TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE campaign_type TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE campaign_type TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE industry TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE industry TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE industry TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE industry TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE source TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE source TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE source TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE source TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE currency TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE currency TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE currency TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE currency TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE unit TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE unit TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE unit TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE unit TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE organization TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE organization TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE organization TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE organization TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE person TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE person TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE person TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE person TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE product TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE product TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE product TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE product TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE campaign TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE campaign TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE campaign TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE campaign TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE pipeline TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE pipeline TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE pipeline TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE pipeline TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE tag TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE tag TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE tag TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE tag TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE stage TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE stage TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE stage TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE stage TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE opportunity TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE opportunity TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE opportunity TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE opportunity TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE quote TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE quote TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE quote TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE quote TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE order TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE order TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE order TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE order TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE opportunity_line TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE opportunity_line TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE opportunity_line TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE opportunity_line TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE quote_line TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE quote_line TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE quote_line TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE quote_line TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE order_line TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE order_line TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE order_line TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE order_line TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE task TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE task TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE task TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE task TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE activity TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE activity TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE activity TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE activity TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE note TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE note TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE note TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE note TYPE option<record<user>> VALUE $auth;

DEFINE FIELD OVERWRITE created_at ON TABLE attachment TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON TABLE attachment TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON TABLE attachment TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON TABLE attachment TYPE option<record<user>> VALUE $auth;

