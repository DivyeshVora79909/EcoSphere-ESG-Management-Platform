USE NS main DB main;

DEFINE FIELD OVERWRITE system_ping ON TABLE category TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE badge TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE reward TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE challenge TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE csr_activity TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE esg_policy TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE audit TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE product TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE emission_factor TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE product_esg_profile TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE environmental_goal TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

DEFINE FIELD OVERWRITE system_ping ON TABLE esg_tx TYPE datetime DEFAULT time::now() PERMISSIONS FOR update NONE;

