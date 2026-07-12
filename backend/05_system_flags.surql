USE NS main DB main;

DEFINE FIELD OVERWRITE system_ping ON TABLE lifecycle_status TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE opportunity_status TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE task_status TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE quote_status TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE order_status TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE priority TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE rating TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE activity_type TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE campaign_type TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE industry TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE source TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE currency TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE unit TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE organization TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE person TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE product TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE campaign TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE pipeline TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE tag TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE stage TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE opportunity TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE quote TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE order TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE opportunity_line TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE quote_line TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE order_line TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE task TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE activity TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE note TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE attachment TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

