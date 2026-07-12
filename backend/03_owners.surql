USE NS main DB main;

DEFINE FIELD OVERWRITE owned_by ON TABLE lifecycle_status TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE lifecycle_status TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE opportunity_status TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE opportunity_status TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE task_status TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE task_status TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE quote_status TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE quote_status TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE order_status TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE order_status TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE priority TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE priority TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE rating TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE rating TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE activity_type TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE activity_type TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE campaign_type TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE campaign_type TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE industry TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE industry TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE source TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE source TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE currency TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE currency TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE unit TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE unit TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE organization TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_lifecycle_status.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE organization TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_lifecycle_status.readers, $this.a_industry.readers, $this.a_rating.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE person TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_organization.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE person TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_organization.readers, $this.a_lifecycle_status.readers, $this.a_source.readers, $this.a_rating.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE product TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_unit.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE product TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_unit.readers, $this.a_currency.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE campaign TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_type.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE campaign TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_type.readers, $this.a_status.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE pipeline TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE pipeline TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE tag TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE tag TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE stage TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_pipeline.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE stage TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_pipeline.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE opportunity TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_person.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE opportunity TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_person.readers, $this.a_organization.readers, $this.a_pipeline.readers, $this.a_stage.readers, $this.a_status.readers, $this.a_currency.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE quote TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_opportunity.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE quote TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_opportunity.readers, $this.a_status.readers, $this.a_currency.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE order TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_parent.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE order TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_parent.readers, $this.a_organization.readers, $this.a_status.readers, $this.a_currency.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE opportunity_line TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_opportunity.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE opportunity_line TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_opportunity.readers, $this.a_product.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE quote_line TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_quote.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE quote_line TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_quote.readers, $this.a_product.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE order_line TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_order.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE order_line TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_order.readers, $this.a_product.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE task TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_target.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE task TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_target.readers, $this.a_assigned_to.readers, $this.a_status.readers, $this.a_priority.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE activity TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_target.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE activity TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_target.readers, $this.a_type.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE note TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_target.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE note TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_target.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE attachment TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_target.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE attachment TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_target.readers]))).filter(|$v| $v != NONE);

