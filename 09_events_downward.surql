USE NS main DB main;

DEFINE EVENT aot_cascade_downward ON TABLE lifecycle_status WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~organization;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE organization WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~person;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~task;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~activity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~note;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~attachment;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE unit WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~product;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE campaign_type WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~campaign;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE pipeline WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~stage;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE stage WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_pipeline != $after.a_pipeline {
            LET $tgt = $after<~opportunity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE person WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~opportunity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~task;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~activity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~note;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~attachment;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE opportunity WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~quote;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_organization != $after.a_organization {
            LET $tgt = $after<~quote<~order;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.a_organization != $after.a_organization OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~order;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~opportunity_line;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~task;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~activity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~note;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~attachment;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE quote WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.a_organization != $after.a_organization OR $before.owned_by != $after.owned_by {
            LET $tgt = $after<~order;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~quote_line;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~task;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~activity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~note;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~attachment;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE order WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~order_line;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~task;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~activity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~note;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~attachment;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

DEFINE EVENT aot_cascade_downward ON TABLE campaign WHEN $event = 'UPDATE' THEN {
    IF $__rebase_halt_cascade != true {
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~task;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~activity;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~note;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
        IF $before.owned_by != $after.owned_by {
            LET $tgt = $after<~attachment;
            IF $tgt { UPDATE $tgt SET system_ping = time::now(); };
        };
    };
};

