USE NS main DB main;

DEFINE TABLE OVERWRITE lifecycle_status SCHEMAFULL PERMISSIONS
    FOR select WHERE 'lifecycle_status_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'lifecycle_status_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'lifecycle_status_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'lifecycle_status_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE opportunity_status SCHEMAFULL PERMISSIONS
    FOR select WHERE 'opportunity_status_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'opportunity_status_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'opportunity_status_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'opportunity_status_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE task_status SCHEMAFULL PERMISSIONS
    FOR select WHERE 'task_status_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'task_status_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'task_status_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'task_status_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE quote_status SCHEMAFULL PERMISSIONS
    FOR select WHERE 'quote_status_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'quote_status_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'quote_status_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'quote_status_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE order_status SCHEMAFULL PERMISSIONS
    FOR select WHERE 'order_status_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'order_status_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'order_status_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'order_status_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE priority SCHEMAFULL PERMISSIONS
    FOR select WHERE 'priority_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'priority_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'priority_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'priority_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE rating SCHEMAFULL PERMISSIONS
    FOR select WHERE 'rating_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'rating_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'rating_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'rating_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE activity_type SCHEMAFULL PERMISSIONS
    FOR select WHERE 'activity_type_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'activity_type_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'activity_type_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'activity_type_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE campaign_type SCHEMAFULL PERMISSIONS
    FOR select WHERE 'campaign_type_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'campaign_type_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'campaign_type_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'campaign_type_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE industry SCHEMAFULL PERMISSIONS
    FOR select WHERE 'industry_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'industry_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'industry_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'industry_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE source SCHEMAFULL PERMISSIONS
    FOR select WHERE 'source_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'source_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'source_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'source_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE currency SCHEMAFULL PERMISSIONS
    FOR select WHERE 'currency_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'currency_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'currency_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'currency_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE unit SCHEMAFULL PERMISSIONS
    FOR select WHERE 'unit_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'unit_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'unit_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'unit_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE organization SCHEMAFULL PERMISSIONS
    FOR select WHERE 'organization_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'organization_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'organization_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'organization_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE person SCHEMAFULL PERMISSIONS
    FOR select WHERE 'person_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'person_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'person_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'person_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE product SCHEMAFULL PERMISSIONS
    FOR select WHERE 'product_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'product_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'product_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'product_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE campaign SCHEMAFULL PERMISSIONS
    FOR select WHERE 'campaign_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'campaign_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'campaign_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'campaign_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE pipeline SCHEMAFULL PERMISSIONS
    FOR select WHERE 'pipeline_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'pipeline_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'pipeline_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'pipeline_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE tag SCHEMAFULL PERMISSIONS
    FOR select WHERE 'tag_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'tag_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'tag_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'tag_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE stage SCHEMAFULL PERMISSIONS
    FOR select WHERE 'stage_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'stage_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'stage_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'stage_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE opportunity SCHEMAFULL PERMISSIONS
    FOR select WHERE 'opportunity_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'opportunity_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'opportunity_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'opportunity_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE quote SCHEMAFULL PERMISSIONS
    FOR select WHERE 'quote_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'quote_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'quote_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'quote_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE order SCHEMAFULL PERMISSIONS
    FOR select WHERE 'order_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'order_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'order_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'order_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE opportunity_line SCHEMAFULL PERMISSIONS
    FOR select WHERE 'opportunity_line_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'opportunity_line_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'opportunity_line_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'opportunity_line_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE quote_line SCHEMAFULL PERMISSIONS
    FOR select WHERE 'quote_line_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'quote_line_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'quote_line_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'quote_line_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE order_line SCHEMAFULL PERMISSIONS
    FOR select WHERE 'order_line_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'order_line_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'order_line_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'order_line_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE task SCHEMAFULL PERMISSIONS
    FOR select WHERE 'task_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'task_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'task_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'task_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE activity SCHEMAFULL PERMISSIONS
    FOR select WHERE 'activity_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'activity_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'activity_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'activity_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE note SCHEMAFULL PERMISSIONS
    FOR select WHERE 'note_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'note_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'note_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'note_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

DEFINE TABLE OVERWRITE attachment SCHEMAFULL PERMISSIONS
    FOR select WHERE 'attachment_select' IN $auth.permissions AND (readers CONTAINSANY $auth.parents OR readers CONTAINSANY $auth.dominates)
    FOR create WHERE 'attachment_create' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR update WHERE 'attachment_update' IN $auth.permissions AND (owned_by IN $auth.parents OR owned_by IN $auth.dominates)
    FOR delete WHERE 'attachment_delete' IN $auth.permissions AND (owned_by IN $auth.dominates);

