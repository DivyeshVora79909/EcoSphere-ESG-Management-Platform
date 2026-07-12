USE NS main DB main;

DEFINE EVENT aot_cascade_downward ON TABLE category WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~badge;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~challenge;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~csr_activity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~esg_policy;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~audit;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~product;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~emission_factor;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table {
            LET $tgt = $after<~product_esg_profile;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~environmental_goal;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~reward;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_target_table != $after.a_target_table {
            LET $tgt = $after<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE product WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~product_esg_profile;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE product_esg_profile WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_xp_cost != $after.a_xp_cost OR $before.a_xp_reward != $after.a_xp_reward OR $before.a_xp_penalty_per_unit != $after.a_xp_penalty_per_unit OR $before.d1_remaining_stock != $after.d1_remaining_stock {
            LET $tgt = $after<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE reward WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_xp_cost != $after.a_xp_cost OR $before.a_xp_reward != $after.a_xp_reward OR $before.a_xp_penalty_per_unit != $after.a_xp_penalty_per_unit OR $before.d1_remaining_stock != $after.d1_remaining_stock {
            LET $tgt = $after<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE challenge WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_xp_cost != $after.a_xp_cost OR $before.a_xp_reward != $after.a_xp_reward OR $before.a_xp_penalty_per_unit != $after.a_xp_penalty_per_unit OR $before.d1_remaining_stock != $after.d1_remaining_stock {
            LET $tgt = $after<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE csr_activity WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_xp_cost != $after.a_xp_cost OR $before.a_xp_reward != $after.a_xp_reward OR $before.a_xp_penalty_per_unit != $after.a_xp_penalty_per_unit OR $before.d1_remaining_stock != $after.d1_remaining_stock {
            LET $tgt = $after<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE esg_policy WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_xp_cost != $after.a_xp_cost OR $before.a_xp_reward != $after.a_xp_reward OR $before.a_xp_penalty_per_unit != $after.a_xp_penalty_per_unit OR $before.d1_remaining_stock != $after.d1_remaining_stock {
            LET $tgt = $after<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE audit WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_xp_cost != $after.a_xp_cost OR $before.a_xp_reward != $after.a_xp_reward OR $before.a_xp_penalty_per_unit != $after.a_xp_penalty_per_unit OR $before.d1_remaining_stock != $after.d1_remaining_stock {
            LET $tgt = $after<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE emission_factor WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_co2e_per_unit != $after.a_co2e_per_unit {
            LET $tgt = $after<~product_esg_profile<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE user WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.d1_net_xp != $after.d1_net_xp OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~esg_tx;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

