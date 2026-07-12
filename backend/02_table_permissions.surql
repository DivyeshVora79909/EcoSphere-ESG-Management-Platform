USE NS main DB main;

DEFINE TABLE OVERWRITE category SCHEMAFULL PERMISSIONS
    FOR select WHERE 'category_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'category_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'category_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'category_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE badge SCHEMAFULL PERMISSIONS
    FOR select WHERE 'badge_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'badge_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'badge_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'badge_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE challenge SCHEMAFULL PERMISSIONS
    FOR select WHERE 'challenge_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'challenge_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'challenge_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'challenge_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE csr_activity SCHEMAFULL PERMISSIONS
    FOR select WHERE 'csr_activity_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'csr_activity_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'csr_activity_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'csr_activity_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE esg_policy SCHEMAFULL PERMISSIONS
    FOR select WHERE 'esg_policy_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'esg_policy_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'esg_policy_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'esg_policy_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE audit SCHEMAFULL PERMISSIONS
    FOR select WHERE 'audit_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'audit_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'audit_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'audit_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE product SCHEMAFULL PERMISSIONS
    FOR select WHERE 'product_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'product_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'product_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'product_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE emission_factor SCHEMAFULL PERMISSIONS
    FOR select WHERE 'emission_factor_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'emission_factor_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'emission_factor_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'emission_factor_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE product_esg_profile SCHEMAFULL PERMISSIONS
    FOR select WHERE 'product_esg_profile_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'product_esg_profile_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'product_esg_profile_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'product_esg_profile_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE environmental_goal SCHEMAFULL PERMISSIONS
    FOR select WHERE 'environmental_goal_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'environmental_goal_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'environmental_goal_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'environmental_goal_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE reward SCHEMAFULL PERMISSIONS
    FOR select WHERE 'reward_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'reward_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'reward_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'reward_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE user SCHEMAFULL PERMISSIONS
    FOR select WHERE 'user_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'user_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'user_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'user_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE groups SCHEMAFULL PERMISSIONS
    FOR select WHERE 'groups_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'groups_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'groups_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'groups_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE esg_tx SCHEMAFULL PERMISSIONS
    FOR select WHERE 'esg_tx_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'esg_tx_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'esg_tx_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'esg_tx_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

