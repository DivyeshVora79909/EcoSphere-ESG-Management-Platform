REMOVE DATABASE main;
DEFINE DATABASE main;
USE NS main DB main;

-- USER
DEFINE TABLE OVERWRITE user SCHEMAFULL PERMISSIONS
    FOR create WHERE 'node_create' IN $auth.permissions
    FOR select WHERE id = $auth OR ('node_select' IN $auth.permissions AND id IN $auth.dominates)
    FOR update WHERE id = $auth OR ('node_update' IN $auth.permissions AND id IN $auth.dominates)
    FOR delete WHERE 'node_delete' IN $auth.permissions AND id IN $auth.dominates;

    DEFINE FIELD OVERWRITE name ON user TYPE string VALUE {
        LET $clean_name = string::trim($value ?? "");
        IF !$clean_name { THROW "VALIDATION_ERR: Invalid Name"; };
        RETURN $clean_name;
    };

    DEFINE FIELD OVERWRITE email ON user TYPE string VALUE {
        LET $clean_email = string::trim($value ?? "");
        IF !string::is_email($clean_email) { THROW "VALIDATION_ERR: Invalid email"; };
        RETURN string::lowercase($clean_email);
    };

    DEFINE FIELD OVERWRITE password ON user TYPE option<string> PERMISSIONS NONE;
    DEFINE FIELD OVERWRITE invite_token ON user TYPE option<uuid> PERMISSIONS NONE;

    DEFINE FIELD OVERWRITE login_access ON user TYPE bool DEFAULT true 
        PERMISSIONS FOR update WHERE id != $auth;

    DEFINE FIELD OVERWRITE dominates ON user TYPE option<array<record<user | groups>>> PERMISSIONS FOR select WHERE TRUE FOR create, update WHERE NONE;
    DEFINE FIELD OVERWRITE parents ON user TYPE option<array<record<groups>>> PERMISSIONS FOR select WHERE TRUE FOR create, update WHERE NONE;
    DEFINE FIELD OVERWRITE permissions ON user TYPE option<array<string>> PERMISSIONS FOR select WHERE TRUE FOR create, update WHERE NONE;

    DEFINE FIELD OVERWRITE last_suspended_at ON user TYPE option<datetime> DEFAULT NONE PERMISSIONS NONE;
    DEFINE FIELD OVERWRITE total_suspensions ON user TYPE option<int> DEFAULT 0 PERMISSIONS NONE;

    DEFINE FIELD OVERWRITE last_refreshed_at ON user TYPE option<datetime> DEFAULT NONE PERMISSIONS NONE;
    DEFINE FIELD OVERWRITE total_refreshes ON user TYPE option<int> DEFAULT 0 PERMISSIONS NONE;

    DEFINE FIELD OVERWRITE last_send_token_at ON user TYPE option<datetime> DEFAULT NONE PERMISSIONS NONE;
    DEFINE FIELD OVERWRITE total_tokens_sent ON user TYPE option<int> DEFAULT 0 PERMISSIONS NONE;

    DEFINE FIELD OVERWRITE last_deactivated_at ON user TYPE option<datetime> DEFAULT NONE PERMISSIONS NONE;
    DEFINE FIELD OVERWRITE total_deactivations ON user TYPE option<int> DEFAULT 0 PERMISSIONS NONE;

    DEFINE FIELD OVERWRITE created_at ON user TYPE datetime VALUE $before OR time::now() READONLY;
    DEFINE FIELD OVERWRITE updated_at ON user TYPE datetime VALUE time::now();
    DEFINE FIELD OVERWRITE created_by ON user TYPE option<record<user>> VALUE $before OR $auth READONLY;
    DEFINE FIELD OVERWRITE updated_by ON user TYPE option<record<user>> VALUE $auth;

    DEFINE INDEX OVERWRITE idx_user_email ON user COLUMNS email UNIQUE;

DEFINE EVENT OVERWRITE user_state_machine ON TABLE user WHEN $event = "UPDATE" THEN {
    IF $before.login_access = true AND $after.login_access = false {
        UPDATE $after.id SET last_suspended_at = time::now();
    };

    IF $before.last_suspended_at != $after.last_suspended_at AND $after.last_suspended_at != NONE {
        UPDATE $after.id SET total_suspensions = ($after.total_suspensions ?? 0) + 1;
    };

    IF $before.last_refreshed_at != $after.last_refreshed_at AND $after.last_refreshed_at != NONE {
        IF $before.last_refreshed_at != NONE {
            LET $diff = time::unix(type::datetime($after.last_refreshed_at)) - time::unix(type::datetime($before.last_refreshed_at));
            IF $diff < 2 { THROW "RATE_LIMIT_EXCEEDED: Refresh"; };
        };
        UPDATE $after.id SET 
            total_refreshes = ($after.total_refreshes ?? 0) + 1,
            dominates = ($after.id.{..+collect}->link->(?) ?? []).filter(|$v| $v != NONE).sort(),
            parents = ($after.id<-link<-groups ?? []).filter(|$v| $v != NONE).distinct().sort(),
            permissions = ($after.id<-link<-groups.role ?? []).flatten().filter(|$v| $v != NONE).distinct().sort();
    };

    IF $before.email != $after.email {
        UPDATE $after.id SET last_deactivated_at = time::now();
    };

    IF $before.last_deactivated_at != $after.last_deactivated_at AND $after.last_deactivated_at != NONE {
        IF $before.last_deactivated_at != NONE {
            LET $diff = time::unix(type::datetime($after.last_deactivated_at)) - time::unix(type::datetime($before.last_deactivated_at));
            IF $diff < 2 { THROW "RATE_LIMIT_EXCEEDED: Deactivation"; };
        };
        UPDATE $after.id SET 
            total_deactivations = ($after.total_deactivations ?? 0) + 1,
            password = NONE,
            invite_token = rand::uuid();
    };

    IF $before.last_send_token_at != $after.last_send_token_at AND $after.last_send_token_at != NONE {
        IF $before.last_send_token_at != NONE {
            LET $diff = time::unix(type::datetime($after.last_send_token_at)) - time::unix(type::datetime($before.last_send_token_at));
            IF $diff < 2 { THROW "RATE_LIMIT_EXCEEDED: Token Sent"; };
        };

        IF $after.invite_token != NONE {
            LET $new_token = rand::uuid();
            UPDATE $after.id SET 
                total_tokens_sent = ($after.total_tokens_sent ?? 0) + 1,
                invite_token = $new_token;

            LET $BREVO_API_URL = "https://api.brevo.com/v3/smtp/email";
            LET $BREVO_API_KEY = "xkeysib-xxxxxxx-xxxxxxx"; 
            LET $EMAIL_SENDER = { "name": "ReBase CRM", "email": "divy.r.vora14@gmail.com" };
            LET $EMAIL_TEMPLATE_RESET = "
            <div style='font-family: sans-serif; padding: 20px; max-width: 600px; margin: auto;'>
                <h2 style='color: #2c3e50;'>Reset Your ReBase Password</h2>
                <p>Hello <strong>{{name}}</strong>,</p>
                <p>We received a request to reset the password for your ReBase account.</p>
                <p>If you made this request, click the button below to choose a new password:</p>
                <p style='margin: 30px 0; text-align: center;'>
                    <a href='http://localhost:5173/auth/verify?token={{token}}&email={{email}}' 
                        style='display: inline-block; padding: 14px 28px; background-color: #3498db; color: #fff; text-decoration: none; border-radius: 6px; font-weight: bold; font-size: 16px;'>
                        Reset Password
                    </a>
                </p>
                <p style='color: #555;'>Or copy and paste this token manually:</p>
                <div style='background: #f4f4f4; padding: 15px; text-align: center; font-size: 24px; letter-spacing: 2px; border-radius: 8px; border: 1px solid #ddd;'>
                    <strong>{{token}}</strong>
                </div>
                <p style='margin-top: 30px; font-size: 14px; color: #888;'>
                    If you did not request a password reset, please ignore this email – your account remains safe.
                </p>
            </div>";

            LET $html_content = string::replace(
                string::replace(
                    string::replace($EMAIL_TEMPLATE_RESET, "{{name}}", $after.name), 
                "{{token}}", <string>$new_token),
            "{{email}}", $after.email);

            LET $headers = { "Accept": "application/json", "Content-Type": "application/json", "api-key": $BREVO_API_KEY };
            LET $payload = { "sender": $EMAIL_SENDER, "to": [ { "email": $after.email, "name": $after.name } ], "subject": "Your Secure Access Token", "htmlContent": $html_content };

            LET $email_response = http::post($BREVO_API_URL, $payload, $headers);
        } ELSE {
            UPDATE $after.id SET last_send_token_at = $before.last_send_token_at;
        };
    };

    IF $before.password = NONE AND $after.password != NONE {
        UPDATE $after.id SET invite_token = NONE;
    };
};

DEFINE EVENT OVERWRITE user_on_create ON TABLE user WHEN $event = "CREATE" THEN {
    IF $after.password = NONE {
        UPDATE $after.id SET invite_token = rand::uuid();
    };
};

DEFINE EVENT OVERWRITE prevent_user_non_leaf_delete ON TABLE user WHEN $event = "DELETE" THEN {
    IF $before.id->link.len() > 0 { THROW "ERR_NOT_A_LEAF"; };
    DELETE link WHERE in = $before.id OR out = $before.id;
};

DEFINE EVENT OVERWRITE auto_link_creator ON TABLE user WHEN $event = "CREATE" AND $after.created_by != NONE THEN {
    RELATE ($after.created_by) -> link -> ($after.id);
};

-- GROUPS
DEFINE TABLE OVERWRITE groups SCHEMAFULL PERMISSIONS
    FOR create WHERE 'node_create' IN $auth.permissions
    FOR select WHERE 'node_select' IN $auth.permissions AND (id IN $auth.dominates OR id IN $auth.parents)
    FOR update WHERE 'node_update' IN $auth.permissions AND id IN $auth.dominates
    FOR delete WHERE 'node_delete' IN $auth.permissions AND id IN $auth.dominates;

DEFINE FIELD OVERWRITE name ON groups TYPE string VALUE {
        LET $clean_name = string::trim($value ?? "");
        IF !$clean_name { THROW "VALIDATION_ERR: Invalid Name"; };
        RETURN $clean_name;
    };
DEFINE FIELD OVERWRITE role ON groups TYPE array<string> VALUE (
    IF $before = NONE THEN ($value ??[]).distinct()
    ELSE IF $before.len() = 0 THEN []
    ELSE IF ($value ??[]).len() = 0 THEN $before
    ELSE $value.distinct() END
);

DEFINE FIELD OVERWRITE created_at ON groups TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE updated_at ON groups TYPE datetime VALUE time::now();
DEFINE FIELD OVERWRITE created_by ON groups TYPE option<record<user>> VALUE $before OR $auth READONLY;
DEFINE FIELD OVERWRITE updated_by ON groups TYPE option<record<user>> VALUE $auth;

DEFINE EVENT OVERWRITE prevent_role_escalation ON TABLE groups WHEN $event IN["CREATE", "UPDATE"] THEN {
    LET $unauthorized = array::complement($after.role, $auth.permissions ?? []);
    IF $unauthorized AND $auth { THROW "ERR_PRIVILEGE_ESCALATION"; };
};

DEFINE EVENT OVERWRITE prevent_group_non_leaf_delete ON TABLE groups WHEN $event = "DELETE" THEN {
    IF $before.id->link.len() > 0 { THROW "ERR_NOT_A_LEAF"; };
    DELETE link WHERE in = $before.id OR out = $before.id;
};

DEFINE EVENT OVERWRITE auto_link_creator_group ON TABLE groups WHEN $event = "CREATE" AND $after.created_by != NONE THEN {
    RELATE ($after.created_by) -> link -> ($after.id);
};

-- LINK
DEFINE TABLE OVERWRITE link SCHEMAFULL TYPE RELATION IN user | groups OUT user | groups PERMISSIONS
    FOR create WHERE 'link_create' IN $auth.permissions AND (in = $auth OR in IN $auth.dominates) AND out IN $auth.dominates
    FOR update NONE
    FOR select WHERE 'link_select' IN $auth.permissions AND (in = $auth OR out = $auth OR in IN $auth.dominates OR out IN $auth.dominates)
    FOR delete WHERE 'link_delete' IN $auth.permissions AND (in = $auth OR in IN $auth.dominates);

DEFINE FIELD OVERWRITE created_at ON link TYPE datetime VALUE $before OR time::now() READONLY;
DEFINE FIELD OVERWRITE created_by ON link TYPE option<record<user>> VALUE $before OR $auth READONLY;

DEFINE INDEX OVERWRITE idx_unique_link ON TABLE link COLUMNS in, out UNIQUE;

DEFINE EVENT OVERWRITE prevent_cycle ON TABLE link WHEN $event = "CREATE" THEN {
    LET $start = $after.out;
    LET $end = $after.in;
    LET $cycle = $start.{..+shortest=$end}->link->(?);
    IF $cycle.len() > 0 { THROW "ERR_CYCLE"; };
};

DEFINE EVENT OVERWRITE prevent_orphans ON TABLE link WHEN $event = "DELETE" THEN {
    IF $before.out != NONE AND record::exists($before.in) AND record::exists($before.out) {
        LET $other_links = (SELECT id FROM link WHERE out = $before.out AND id != $before.id LIMIT 1);
        IF $other_links.len() = 0 { THROW "ERR_LAST_EDGE"; };
    };
};

-- ACCESS METHODS
DEFINE ACCESS OVERWRITE account ON DATABASE TYPE RECORD
    SIGNUP (
        UPDATE user SET 
            password = crypto::argon2::generate($password), 
            last_refreshed_at = time::now()
        WHERE email = $email.lowercase() 
          AND invite_token = type::uuid($invite)
          AND $password.len() > 6
          AND login_access = true
    )
    SIGNIN (
        UPDATE user SET last_refreshed_at = time::now()
        WHERE email = $email.lowercase() 
          AND invite_token = NONE 
          AND crypto::argon2::compare(password ?? "", $password)
          AND login_access = true
    )
    AUTHENTICATE {
        IF $auth.password = NONE OR $auth.login_access = false { RETURN NONE; };
        RETURN $auth;
    }
    DURATION FOR SESSION 8h, FOR TOKEN 1h;

DEFINE ACCESS OVERWRITE update_password ON DATABASE TYPE RECORD
    SIGNUP (
        UPDATE user SET 
            password = crypto::argon2::generate($new_password), 
            last_refreshed_at = time::now()
        WHERE email = $email.lowercase() 
          AND password != NONE 
          AND crypto::argon2::compare(password ?? "", $password)
          AND $new_password.len() > 6
          AND login_access = true
    )
    AUTHENTICATE {
        IF $auth.password = NONE OR $auth.login_access = false { RETURN NONE; };
        RETURN $auth;
    }
    DURATION FOR SESSION 8h, FOR TOKEN 1h;

DEFINE ACCESS OVERWRITE request_password_reset ON DATABASE TYPE RECORD
    SIGNUP (
        UPDATE (
            UPDATE user SET last_deactivated_at = time::now() 
            WHERE email = string::lowercase($email) AND login_access = true
        ) 
        SET last_send_token_at = time::now()
    )
    AUTHENTICATE {
        RETURN $auth;
    }
    DURATION FOR SESSION 1ms, FOR TOKEN 1ms;

-- INITIALIZATION
CREATE groups:root SET name = 'System Admins', role = [
    'node_create', 'node_select', 'node_update', 'node_delete',
    'link_create', 'link_select', 'link_delete',
    'lifecycle_status_select', 'lifecycle_status_create', 'lifecycle_status_update', 'lifecycle_status_delete',
    'opportunity_status_select', 'opportunity_status_create', 'opportunity_status_update', 'opportunity_status_delete',
    'task_status_select', 'task_status_create', 'task_status_update', 'task_status_delete',
    'quote_status_select', 'quote_status_create', 'quote_status_update', 'quote_status_delete',
    'order_status_select', 'order_status_create', 'order_status_update', 'order_status_delete',
    'priority_select', 'priority_create', 'priority_update', 'priority_delete',
    'rating_select', 'rating_create', 'rating_update', 'rating_delete',
    'activity_type_select', 'activity_type_create', 'activity_type_update', 'activity_type_delete',
    'campaign_type_select', 'campaign_type_create', 'campaign_type_update', 'campaign_type_delete',
    'industry_select', 'industry_create', 'industry_update', 'industry_delete',
    'source_select', 'source_create', 'source_update', 'source_delete',
    'currency_select', 'currency_create', 'currency_update', 'currency_delete',
    'unit_select', 'unit_create', 'unit_update', 'unit_delete',
    'organization_select', 'organization_create', 'organization_update', 'organization_delete',
    'person_select', 'person_create', 'person_update', 'person_delete',
    'product_select', 'product_create', 'product_update', 'product_delete',
    'campaign_select', 'campaign_create', 'campaign_update', 'campaign_delete',
    'pipeline_select', 'pipeline_create', 'pipeline_update', 'pipeline_delete',
    'tag_select', 'tag_create', 'tag_update', 'tag_delete',
    'stage_select', 'stage_create', 'stage_update', 'stage_delete',
    'opportunity_select', 'opportunity_create', 'opportunity_update', 'opportunity_delete',
    'quote_select', 'quote_create', 'quote_update', 'quote_delete',
    'order_select', 'order_create', 'order_update', 'order_delete',
    'opportunity_line_select', 'opportunity_line_create', 'opportunity_line_update', 'opportunity_line_delete',
    'quote_line_select', 'quote_line_create', 'quote_line_update', 'quote_line_delete',
    'order_line_select', 'order_line_create', 'order_line_update', 'order_line_delete',
    'task_select', 'task_create', 'task_update', 'task_delete',
    'activity_select', 'activity_create', 'activity_update', 'activity_delete',
    'note_select', 'note_create', 'note_update', 'note_delete',
    'attachment_select', 'attachment_create', 'attachment_update', 'attachment_delete'
];

CREATE user:root SET name = 'Super Admin', email = 'divy.r.vora14@gmail.com';
UPDATE user:root SET password = crypto::argon2::generate("password"), invite_token = NONE;
RELATE groups:root -> link -> user:root;
UPDATE user:root SET last_refreshed_at = time::now();

Error while processing event user_on_create: Couldn't coerce value for field `total_deactivations` of `user:9pei8qqolc496hhvphdg`: Expected `int` but found `NONE`