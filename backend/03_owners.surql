USE NS main DB main;

DEFINE FIELD OVERWRITE owned_by ON TABLE category TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
DEFINE FIELD OVERWRITE readers ON TABLE category TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE badge TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE badge TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE challenge TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE challenge TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE csr_activity TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE csr_activity TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE esg_policy TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE esg_policy TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE audit TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE audit TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE product TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE product TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE emission_factor TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE emission_factor TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE product_esg_profile TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_product.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE product_esg_profile TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_product.readers, $this.a_emission_factor.readers, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE environmental_goal TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE environmental_goal TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

DEFINE FIELD OVERWRITE owned_by ON TABLE reward TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_category.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE reward TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_category.readers]))).filter(|$v| $v != NONE);

--DEFINE FIELD OVERWRITE owned_by ON TABLE user TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
-- DEFINE FIELD OVERWRITE readers ON TABLE user TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

-- DEFINE FIELD OVERWRITE owned_by ON TABLE groups TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates;
-- DEFINE FIELD OVERWRITE readers ON TABLE groups TYPE array<record<groups>> VALUE array::distinct(array::flatten([$this.owned_by]));

DEFINE FIELD OVERWRITE owned_by ON TABLE esg_tx TYPE record<groups> REFERENCE ON DELETE REJECT PERMISSIONS FOR select WHERE TRUE FOR create WHERE $value IN $auth.parents OR $value IN $auth.dominates FOR update WHERE $value = $before OR $value IN $auth.dominates VALUE $this.a_from.owned_by;
DEFINE FIELD OVERWRITE readers ON TABLE esg_tx TYPE array<record<groups>> VALUE (array::distinct(array::flatten([$this.owned_by, $this.a_from.readers, $this.a_to.readers, $this.a_category.readers]))).filter(|$v| $v != NONE);

