SET check_function_bodies = false;
CREATE SCHEMA cdm;
CREATE TABLE cdm.care_site (
    care_site_id integer NOT NULL,
    care_site_name character varying(255),
    place_of_service_concept_id integer,
    location_id integer,
    care_site_source_value character varying(50),
    place_of_service_source_value character varying(50)
);
CREATE TABLE cdm.cdm_source (
    cdm_source_name character varying(255) NOT NULL,
    cdm_source_abbreviation character varying(25) NOT NULL,
    cdm_holder character varying(255) NOT NULL,
    source_description text,
    source_documentation_reference character varying(255),
    cdm_etl_reference character varying(255),
    source_release_date date NOT NULL,
    cdm_release_date date NOT NULL,
    cdm_version character varying(10),
    cdm_version_concept_id integer NOT NULL,
    vocabulary_version character varying(20) NOT NULL
);
CREATE TABLE cdm.cohort (
    cohort_definition_id integer NOT NULL,
    subject_id integer NOT NULL,
    cohort_start_date date NOT NULL,
    cohort_end_date date NOT NULL
);
CREATE TABLE cdm.cohort_definition (
    cohort_definition_id integer NOT NULL,
    cohort_definition_name character varying(255) NOT NULL,
    cohort_definition_description text,
    definition_type_concept_id integer NOT NULL,
    cohort_definition_syntax text,
    subject_concept_id integer NOT NULL,
    cohort_initiation_date date
);
CREATE TABLE cdm.concept (
    concept_id integer NOT NULL,
    concept_name character varying(255) NOT NULL,
    domain_id character varying(20) NOT NULL,
    vocabulary_id character varying(20) NOT NULL,
    concept_class_id character varying(20) NOT NULL,
    standard_concept character varying(1),
    concept_code character varying(50) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);
CREATE TABLE cdm.concept_ancestor (
    ancestor_concept_id integer NOT NULL,
    descendant_concept_id integer NOT NULL,
    min_levels_of_separation integer NOT NULL,
    max_levels_of_separation integer NOT NULL
);
CREATE TABLE cdm.concept_class (
    concept_class_id character varying(20) NOT NULL,
    concept_class_name character varying(255) NOT NULL,
    concept_class_concept_id integer NOT NULL
);
CREATE TABLE cdm.concept_relationship (
    concept_id_1 integer NOT NULL,
    concept_id_2 integer NOT NULL,
    relationship_id character varying(20) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);
CREATE TABLE cdm.concept_synonym (
    concept_id integer NOT NULL,
    concept_synonym_name character varying(1000) NOT NULL,
    language_concept_id integer NOT NULL
);
CREATE TABLE cdm.condition_era (
    condition_era_id integer NOT NULL,
    person_id integer NOT NULL,
    condition_concept_id integer NOT NULL,
    condition_era_start_date timestamp without time zone NOT NULL,
    condition_era_end_date timestamp without time zone NOT NULL,
    condition_occurrence_count integer
);
CREATE TABLE cdm.condition_occurrence (
    condition_occurrence_id integer NOT NULL,
    person_id integer NOT NULL,
    condition_concept_id integer NOT NULL,
    condition_start_date date NOT NULL,
    condition_start_datetime timestamp without time zone,
    condition_end_date date,
    condition_end_datetime timestamp without time zone,
    condition_type_concept_id integer NOT NULL,
    condition_status_concept_id integer,
    stop_reason character varying(20),
    provider_id integer,
    visit_occurrence_id integer,
    visit_detail_id integer,
    condition_source_value character varying(50),
    condition_source_concept_id integer,
    condition_status_source_value character varying(50)
);
CREATE TABLE cdm.cost (
    cost_id integer NOT NULL,
    cost_event_id integer NOT NULL,
    cost_domain_id character varying(20) NOT NULL,
    cost_type_concept_id integer NOT NULL,
    currency_concept_id integer,
    total_charge numeric,
    total_cost numeric,
    total_paid numeric,
    paid_by_payer numeric,
    paid_by_patient numeric,
    paid_patient_copay numeric,
    paid_patient_coinsurance numeric,
    paid_patient_deductible numeric,
    paid_by_primary numeric,
    paid_ingredient_cost numeric,
    paid_dispensing_fee numeric,
    payer_plan_period_id integer,
    amount_allowed numeric,
    revenue_code_concept_id integer,
    revenue_code_source_value character varying(50),
    drg_concept_id integer,
    drg_source_value character varying(3)
);
CREATE TABLE cdm.death (
    person_id integer NOT NULL,
    death_date date NOT NULL,
    death_datetime timestamp without time zone,
    death_type_concept_id integer,
    cause_concept_id integer,
    cause_source_value character varying(50),
    cause_source_concept_id integer
);
CREATE TABLE cdm.device_exposure (
    device_exposure_id integer NOT NULL,
    person_id integer NOT NULL,
    device_concept_id integer NOT NULL,
    device_exposure_start_date date NOT NULL,
    device_exposure_start_datetime timestamp without time zone,
    device_exposure_end_date date,
    device_exposure_end_datetime timestamp without time zone,
    device_type_concept_id integer NOT NULL,
    unique_device_id character varying(255),
    production_id character varying(255),
    quantity integer,
    provider_id integer,
    visit_occurrence_id integer,
    visit_detail_id integer,
    device_source_value character varying(50),
    device_source_concept_id integer,
    unit_concept_id integer,
    unit_source_value character varying(50),
    unit_source_concept_id integer
);
CREATE TABLE cdm.domain (
    domain_id character varying(20) NOT NULL,
    domain_name character varying(255) NOT NULL,
    domain_concept_id integer NOT NULL
);
CREATE TABLE cdm.dose_era (
    dose_era_id integer NOT NULL,
    person_id integer NOT NULL,
    drug_concept_id integer NOT NULL,
    unit_concept_id integer NOT NULL,
    dose_value numeric NOT NULL,
    dose_era_start_date timestamp without time zone NOT NULL,
    dose_era_end_date timestamp without time zone NOT NULL
);
CREATE TABLE cdm.drug_era (
    drug_era_id integer NOT NULL,
    person_id integer NOT NULL,
    drug_concept_id integer NOT NULL,
    drug_era_start_date timestamp without time zone NOT NULL,
    drug_era_end_date timestamp without time zone NOT NULL,
    drug_exposure_count integer,
    gap_days integer
);
CREATE TABLE cdm.drug_exposure (
    drug_exposure_id integer NOT NULL,
    person_id integer NOT NULL,
    drug_concept_id integer NOT NULL,
    drug_exposure_start_date date NOT NULL,
    drug_exposure_start_datetime timestamp without time zone,
    drug_exposure_end_date date NOT NULL,
    drug_exposure_end_datetime timestamp without time zone,
    verbatim_end_date date,
    drug_type_concept_id integer NOT NULL,
    stop_reason character varying(20),
    refills integer,
    quantity numeric,
    days_supply integer,
    sig text,
    route_concept_id integer,
    lot_number character varying(50),
    provider_id integer,
    visit_occurrence_id integer,
    visit_detail_id integer,
    drug_source_value character varying(50),
    drug_source_concept_id integer,
    route_source_value character varying(50),
    dose_unit_source_value character varying(50)
);
CREATE TABLE cdm.drug_strength (
    drug_concept_id integer NOT NULL,
    ingredient_concept_id integer NOT NULL,
    amount_value numeric,
    amount_unit_concept_id integer,
    numerator_value numeric,
    numerator_unit_concept_id integer,
    denominator_value numeric,
    denominator_unit_concept_id integer,
    box_size integer,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);
CREATE TABLE cdm.episode (
    episode_id bigint NOT NULL,
    person_id bigint NOT NULL,
    episode_concept_id integer NOT NULL,
    episode_start_date date NOT NULL,
    episode_start_datetime timestamp without time zone,
    episode_end_date date,
    episode_end_datetime timestamp without time zone,
    episode_parent_id bigint,
    episode_number integer,
    episode_object_concept_id integer NOT NULL,
    episode_type_concept_id integer NOT NULL,
    episode_source_value character varying(50),
    episode_source_concept_id integer
);
CREATE TABLE cdm.episode_event (
    episode_id bigint NOT NULL,
    event_id bigint NOT NULL,
    episode_event_field_concept_id integer NOT NULL
);
CREATE TABLE cdm.fact_relationship (
    domain_concept_id_1 integer NOT NULL,
    fact_id_1 integer NOT NULL,
    domain_concept_id_2 integer NOT NULL,
    fact_id_2 integer NOT NULL,
    relationship_concept_id integer NOT NULL
);
CREATE TABLE cdm.location (
    location_id integer NOT NULL,
    address_1 character varying(50),
    address_2 character varying(50),
    city character varying(50),
    state character varying(2),
    zip character varying(9),
    county character varying(20),
    location_source_value character varying(50),
    country_concept_id integer,
    country_source_value character varying(80),
    latitude numeric,
    longitude numeric
);
CREATE TABLE cdm.measurement (
    measurement_id integer NOT NULL,
    person_id integer NOT NULL,
    measurement_concept_id integer NOT NULL,
    measurement_date date NOT NULL,
    measurement_datetime timestamp without time zone,
    measurement_time character varying(10),
    measurement_type_concept_id integer NOT NULL,
    operator_concept_id integer,
    value_as_number numeric,
    value_as_concept_id integer,
    unit_concept_id integer,
    range_low numeric,
    range_high numeric,
    provider_id integer,
    visit_occurrence_id integer,
    visit_detail_id integer,
    measurement_source_value character varying(50),
    measurement_source_concept_id integer,
    unit_source_value character varying(50),
    unit_source_concept_id integer,
    value_source_value character varying(50),
    measurement_event_id bigint,
    meas_event_field_concept_id integer
);
CREATE TABLE cdm.metadata (
    metadata_id integer NOT NULL,
    metadata_concept_id integer NOT NULL,
    metadata_type_concept_id integer NOT NULL,
    name character varying(250) NOT NULL,
    value_as_string character varying(250),
    value_as_concept_id integer,
    value_as_number numeric,
    metadata_date date,
    metadata_datetime timestamp without time zone
);
CREATE TABLE cdm.note (
    note_id integer NOT NULL,
    person_id integer NOT NULL,
    note_date date NOT NULL,
    note_datetime timestamp without time zone,
    note_type_concept_id integer NOT NULL,
    note_class_concept_id integer NOT NULL,
    note_title character varying(250),
    note_text text NOT NULL,
    encoding_concept_id integer NOT NULL,
    language_concept_id integer NOT NULL,
    provider_id integer,
    visit_occurrence_id integer,
    visit_detail_id integer,
    note_source_value character varying(50),
    note_event_id bigint,
    note_event_field_concept_id integer
);
CREATE TABLE cdm.note_nlp (
    note_nlp_id integer NOT NULL,
    note_id integer NOT NULL,
    section_concept_id integer,
    snippet character varying(250),
    "offset" character varying(50),
    lexical_variant character varying(250) NOT NULL,
    note_nlp_concept_id integer,
    note_nlp_source_concept_id integer,
    nlp_system character varying(250),
    nlp_date date NOT NULL,
    nlp_datetime timestamp without time zone,
    term_exists character varying(1),
    term_temporal character varying(50),
    term_modifiers character varying(2000)
);
CREATE TABLE cdm.observation (
    observation_id integer NOT NULL,
    person_id integer NOT NULL,
    observation_concept_id integer NOT NULL,
    observation_date date NOT NULL,
    observation_datetime timestamp without time zone,
    observation_type_concept_id integer NOT NULL,
    value_as_number numeric,
    value_as_string character varying(60),
    value_as_concept_id integer,
    qualifier_concept_id integer,
    unit_concept_id integer,
    provider_id integer,
    visit_occurrence_id integer,
    visit_detail_id integer,
    observation_source_value character varying(50),
    observation_source_concept_id integer,
    unit_source_value character varying(50),
    qualifier_source_value character varying(50),
    value_source_value character varying(50),
    observation_event_id bigint,
    obs_event_field_concept_id integer
);
CREATE TABLE cdm.observation_period (
    observation_period_id integer NOT NULL,
    person_id integer NOT NULL,
    observation_period_start_date date NOT NULL,
    observation_period_end_date date NOT NULL,
    period_type_concept_id integer NOT NULL
);
CREATE TABLE cdm.payer_plan_period (
    payer_plan_period_id integer NOT NULL,
    person_id integer NOT NULL,
    payer_plan_period_start_date date NOT NULL,
    payer_plan_period_end_date date NOT NULL,
    payer_concept_id integer,
    payer_source_value character varying(50),
    payer_source_concept_id integer,
    plan_concept_id integer,
    plan_source_value character varying(50),
    plan_source_concept_id integer,
    sponsor_concept_id integer,
    sponsor_source_value character varying(50),
    sponsor_source_concept_id integer,
    family_source_value character varying(50),
    stop_reason_concept_id integer,
    stop_reason_source_value character varying(50),
    stop_reason_source_concept_id integer
);
CREATE TABLE cdm.person (
    person_id integer NOT NULL,
    gender_concept_id integer NOT NULL,
    year_of_birth integer NOT NULL,
    month_of_birth integer,
    day_of_birth integer,
    birth_datetime timestamp without time zone,
    race_concept_id integer NOT NULL,
    ethnicity_concept_id integer NOT NULL,
    location_id integer,
    provider_id integer,
    care_site_id integer,
    person_source_value character varying(50),
    gender_source_value character varying(50),
    gender_source_concept_id integer,
    race_source_value character varying(50),
    race_source_concept_id integer,
    ethnicity_source_value character varying(50),
    ethnicity_source_concept_id integer
);
CREATE TABLE cdm.procedure_occurrence (
    procedure_occurrence_id integer NOT NULL,
    person_id integer NOT NULL,
    procedure_concept_id integer NOT NULL,
    procedure_date date NOT NULL,
    procedure_datetime timestamp without time zone,
    procedure_end_date date,
    procedure_end_datetime timestamp without time zone,
    procedure_type_concept_id integer NOT NULL,
    modifier_concept_id integer,
    quantity integer,
    provider_id integer,
    visit_occurrence_id integer,
    visit_detail_id integer,
    procedure_source_value character varying(50),
    procedure_source_concept_id integer,
    modifier_source_value character varying(50)
);
CREATE TABLE cdm.provider (
    provider_id integer NOT NULL,
    provider_name character varying(255),
    npi character varying(20),
    dea character varying(20),
    specialty_concept_id integer,
    care_site_id integer,
    year_of_birth integer,
    gender_concept_id integer,
    provider_source_value character varying(50),
    specialty_source_value character varying(50),
    specialty_source_concept_id integer,
    gender_source_value character varying(50),
    gender_source_concept_id integer
);
CREATE TABLE cdm.relationship (
    relationship_id character varying(20) NOT NULL,
    relationship_name character varying(255) NOT NULL,
    is_hierarchical character varying(1) NOT NULL,
    defines_ancestry character varying(1) NOT NULL,
    reverse_relationship_id character varying(20) NOT NULL,
    relationship_concept_id integer NOT NULL
);
CREATE TABLE cdm.source_to_concept_map (
    source_code character varying(50) NOT NULL,
    source_concept_id integer NOT NULL,
    source_vocabulary_id character varying(20) NOT NULL,
    source_code_description character varying(255),
    target_concept_id integer NOT NULL,
    target_vocabulary_id character varying(20) NOT NULL,
    valid_start_date date NOT NULL,
    valid_end_date date NOT NULL,
    invalid_reason character varying(1)
);
CREATE TABLE cdm.specimen (
    specimen_id integer NOT NULL,
    person_id integer NOT NULL,
    specimen_concept_id integer NOT NULL,
    specimen_type_concept_id integer NOT NULL,
    specimen_date date NOT NULL,
    specimen_datetime timestamp without time zone,
    quantity numeric,
    unit_concept_id integer,
    anatomic_site_concept_id integer,
    disease_status_concept_id integer,
    specimen_source_id character varying(50),
    specimen_source_value character varying(50),
    unit_source_value character varying(50),
    anatomic_site_source_value character varying(50),
    disease_status_source_value character varying(50)
);
CREATE TABLE cdm.visit_detail (
    visit_detail_id integer NOT NULL,
    person_id integer NOT NULL,
    visit_detail_concept_id integer NOT NULL,
    visit_detail_start_date date NOT NULL,
    visit_detail_start_datetime timestamp without time zone,
    visit_detail_end_date date NOT NULL,
    visit_detail_end_datetime timestamp without time zone,
    visit_detail_type_concept_id integer NOT NULL,
    provider_id integer,
    care_site_id integer,
    visit_detail_source_value character varying(50),
    visit_detail_source_concept_id integer,
    admitted_from_concept_id integer,
    admitted_from_source_value character varying(50),
    discharged_to_source_value character varying(50),
    discharged_to_concept_id integer,
    preceding_visit_detail_id integer,
    parent_visit_detail_id integer,
    visit_occurrence_id integer NOT NULL
);
CREATE TABLE cdm.visit_occurrence (
    visit_occurrence_id integer NOT NULL,
    person_id integer NOT NULL,
    visit_concept_id integer NOT NULL,
    visit_start_date date NOT NULL,
    visit_start_datetime timestamp without time zone,
    visit_end_date date NOT NULL,
    visit_end_datetime timestamp without time zone,
    visit_type_concept_id integer NOT NULL,
    provider_id integer,
    care_site_id integer,
    visit_source_value character varying(50),
    visit_source_concept_id integer,
    admitted_from_concept_id integer,
    admitted_from_source_value character varying(50),
    discharged_to_concept_id integer,
    discharged_to_source_value character varying(50),
    preceding_visit_occurrence_id integer
);
CREATE TABLE cdm.vocabulary (
    vocabulary_id character varying(20) NOT NULL,
    vocabulary_name character varying(255) NOT NULL,
    vocabulary_reference character varying(255),
    vocabulary_version character varying(255),
    vocabulary_concept_id integer NOT NULL
);
ALTER TABLE ONLY cdm.care_site
    ADD CONSTRAINT xpk_care_site PRIMARY KEY (care_site_id);
ALTER TABLE ONLY cdm.concept
    ADD CONSTRAINT xpk_concept PRIMARY KEY (concept_id);
ALTER TABLE ONLY cdm.concept_class
    ADD CONSTRAINT xpk_concept_class PRIMARY KEY (concept_class_id);
ALTER TABLE ONLY cdm.condition_era
    ADD CONSTRAINT xpk_condition_era PRIMARY KEY (condition_era_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT xpk_condition_occurrence PRIMARY KEY (condition_occurrence_id);
ALTER TABLE ONLY cdm.cost
    ADD CONSTRAINT xpk_cost PRIMARY KEY (cost_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT xpk_device_exposure PRIMARY KEY (device_exposure_id);
ALTER TABLE ONLY cdm.domain
    ADD CONSTRAINT xpk_domain PRIMARY KEY (domain_id);
ALTER TABLE ONLY cdm.dose_era
    ADD CONSTRAINT xpk_dose_era PRIMARY KEY (dose_era_id);
ALTER TABLE ONLY cdm.drug_era
    ADD CONSTRAINT xpk_drug_era PRIMARY KEY (drug_era_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT xpk_drug_exposure PRIMARY KEY (drug_exposure_id);
ALTER TABLE ONLY cdm.episode
    ADD CONSTRAINT xpk_episode PRIMARY KEY (episode_id);
ALTER TABLE ONLY cdm.location
    ADD CONSTRAINT xpk_location PRIMARY KEY (location_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT xpk_measurement PRIMARY KEY (measurement_id);
ALTER TABLE ONLY cdm.metadata
    ADD CONSTRAINT xpk_metadata PRIMARY KEY (metadata_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT xpk_note PRIMARY KEY (note_id);
ALTER TABLE ONLY cdm.note_nlp
    ADD CONSTRAINT xpk_note_nlp PRIMARY KEY (note_nlp_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT xpk_observation PRIMARY KEY (observation_id);
ALTER TABLE ONLY cdm.observation_period
    ADD CONSTRAINT xpk_observation_period PRIMARY KEY (observation_period_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT xpk_payer_plan_period PRIMARY KEY (payer_plan_period_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT xpk_person PRIMARY KEY (person_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT xpk_procedure_occurrence PRIMARY KEY (procedure_occurrence_id);
ALTER TABLE ONLY cdm.provider
    ADD CONSTRAINT xpk_provider PRIMARY KEY (provider_id);
ALTER TABLE ONLY cdm.relationship
    ADD CONSTRAINT xpk_relationship PRIMARY KEY (relationship_id);
ALTER TABLE ONLY cdm.specimen
    ADD CONSTRAINT xpk_specimen PRIMARY KEY (specimen_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT xpk_visit_detail PRIMARY KEY (visit_detail_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT xpk_visit_occurrence PRIMARY KEY (visit_occurrence_id);
ALTER TABLE ONLY cdm.vocabulary
    ADD CONSTRAINT xpk_vocabulary PRIMARY KEY (vocabulary_id);
CREATE INDEX idx_care_site_id_1 ON cdm.care_site USING btree (care_site_id);
ALTER TABLE cdm.care_site CLUSTER ON idx_care_site_id_1;
CREATE INDEX idx_concept_ancestor_id_1 ON cdm.concept_ancestor USING btree (ancestor_concept_id);
ALTER TABLE cdm.concept_ancestor CLUSTER ON idx_concept_ancestor_id_1;
CREATE INDEX idx_concept_ancestor_id_2 ON cdm.concept_ancestor USING btree (descendant_concept_id);
CREATE INDEX idx_concept_class_class_id ON cdm.concept_class USING btree (concept_class_id);
ALTER TABLE cdm.concept_class CLUSTER ON idx_concept_class_class_id;
CREATE INDEX idx_concept_class_id ON cdm.concept USING btree (concept_class_id);
CREATE INDEX idx_concept_code ON cdm.concept USING btree (concept_code);
CREATE INDEX idx_concept_concept_id ON cdm.concept USING btree (concept_id);
ALTER TABLE cdm.concept CLUSTER ON idx_concept_concept_id;
CREATE INDEX idx_concept_domain_id ON cdm.concept USING btree (domain_id);
CREATE INDEX idx_concept_relationship_id_1 ON cdm.concept_relationship USING btree (concept_id_1);
ALTER TABLE cdm.concept_relationship CLUSTER ON idx_concept_relationship_id_1;
CREATE INDEX idx_concept_relationship_id_2 ON cdm.concept_relationship USING btree (concept_id_2);
CREATE INDEX idx_concept_relationship_id_3 ON cdm.concept_relationship USING btree (relationship_id);
CREATE INDEX idx_concept_synonym_id ON cdm.concept_synonym USING btree (concept_id);
ALTER TABLE cdm.concept_synonym CLUSTER ON idx_concept_synonym_id;
CREATE INDEX idx_concept_vocabluary_id ON cdm.concept USING btree (vocabulary_id);
CREATE INDEX idx_condition_concept_id_1 ON cdm.condition_occurrence USING btree (condition_concept_id);
CREATE INDEX idx_condition_era_concept_id_1 ON cdm.condition_era USING btree (condition_concept_id);
CREATE INDEX idx_condition_era_person_id_1 ON cdm.condition_era USING btree (person_id);
ALTER TABLE cdm.condition_era CLUSTER ON idx_condition_era_person_id_1;
CREATE INDEX idx_condition_person_id_1 ON cdm.condition_occurrence USING btree (person_id);
ALTER TABLE cdm.condition_occurrence CLUSTER ON idx_condition_person_id_1;
CREATE INDEX idx_condition_visit_id_1 ON cdm.condition_occurrence USING btree (visit_occurrence_id);
CREATE INDEX idx_cost_event_id ON cdm.cost USING btree (cost_event_id);
CREATE INDEX idx_death_person_id_1 ON cdm.death USING btree (person_id);
ALTER TABLE cdm.death CLUSTER ON idx_death_person_id_1;
CREATE INDEX idx_device_concept_id_1 ON cdm.device_exposure USING btree (device_concept_id);
CREATE INDEX idx_device_person_id_1 ON cdm.device_exposure USING btree (person_id);
ALTER TABLE cdm.device_exposure CLUSTER ON idx_device_person_id_1;
CREATE INDEX idx_device_visit_id_1 ON cdm.device_exposure USING btree (visit_occurrence_id);
CREATE INDEX idx_domain_domain_id ON cdm.domain USING btree (domain_id);
ALTER TABLE cdm.domain CLUSTER ON idx_domain_domain_id;
CREATE INDEX idx_dose_era_concept_id_1 ON cdm.dose_era USING btree (drug_concept_id);
CREATE INDEX idx_dose_era_person_id_1 ON cdm.dose_era USING btree (person_id);
ALTER TABLE cdm.dose_era CLUSTER ON idx_dose_era_person_id_1;
CREATE INDEX idx_drug_concept_id_1 ON cdm.drug_exposure USING btree (drug_concept_id);
CREATE INDEX idx_drug_era_concept_id_1 ON cdm.drug_era USING btree (drug_concept_id);
CREATE INDEX idx_drug_era_person_id_1 ON cdm.drug_era USING btree (person_id);
ALTER TABLE cdm.drug_era CLUSTER ON idx_drug_era_person_id_1;
CREATE INDEX idx_drug_person_id_1 ON cdm.drug_exposure USING btree (person_id);
ALTER TABLE cdm.drug_exposure CLUSTER ON idx_drug_person_id_1;
CREATE INDEX idx_drug_strength_id_1 ON cdm.drug_strength USING btree (drug_concept_id);
ALTER TABLE cdm.drug_strength CLUSTER ON idx_drug_strength_id_1;
CREATE INDEX idx_drug_strength_id_2 ON cdm.drug_strength USING btree (ingredient_concept_id);
CREATE INDEX idx_drug_visit_id_1 ON cdm.drug_exposure USING btree (visit_occurrence_id);
CREATE INDEX idx_fact_relationship_id1 ON cdm.fact_relationship USING btree (domain_concept_id_1);
CREATE INDEX idx_fact_relationship_id2 ON cdm.fact_relationship USING btree (domain_concept_id_2);
CREATE INDEX idx_fact_relationship_id3 ON cdm.fact_relationship USING btree (relationship_concept_id);
CREATE INDEX idx_gender ON cdm.person USING btree (gender_concept_id);
CREATE INDEX idx_location_id_1 ON cdm.location USING btree (location_id);
ALTER TABLE cdm.location CLUSTER ON idx_location_id_1;
CREATE INDEX idx_measurement_concept_id_1 ON cdm.measurement USING btree (measurement_concept_id);
CREATE INDEX idx_measurement_person_id_1 ON cdm.measurement USING btree (person_id);
ALTER TABLE cdm.measurement CLUSTER ON idx_measurement_person_id_1;
CREATE INDEX idx_measurement_visit_id_1 ON cdm.measurement USING btree (visit_occurrence_id);
CREATE INDEX idx_metadata_concept_id_1 ON cdm.metadata USING btree (metadata_concept_id);
ALTER TABLE cdm.metadata CLUSTER ON idx_metadata_concept_id_1;
CREATE INDEX idx_note_concept_id_1 ON cdm.note USING btree (note_type_concept_id);
CREATE INDEX idx_note_nlp_concept_id_1 ON cdm.note_nlp USING btree (note_nlp_concept_id);
CREATE INDEX idx_note_nlp_note_id_1 ON cdm.note_nlp USING btree (note_id);
ALTER TABLE cdm.note_nlp CLUSTER ON idx_note_nlp_note_id_1;
CREATE INDEX idx_note_person_id_1 ON cdm.note USING btree (person_id);
ALTER TABLE cdm.note CLUSTER ON idx_note_person_id_1;
CREATE INDEX idx_note_visit_id_1 ON cdm.note USING btree (visit_occurrence_id);
CREATE INDEX idx_observation_concept_id_1 ON cdm.observation USING btree (observation_concept_id);
CREATE INDEX idx_observation_period_id_1 ON cdm.observation_period USING btree (person_id);
ALTER TABLE cdm.observation_period CLUSTER ON idx_observation_period_id_1;
CREATE INDEX idx_observation_person_id_1 ON cdm.observation USING btree (person_id);
ALTER TABLE cdm.observation CLUSTER ON idx_observation_person_id_1;
CREATE INDEX idx_observation_visit_id_1 ON cdm.observation USING btree (visit_occurrence_id);
CREATE INDEX idx_period_person_id_1 ON cdm.payer_plan_period USING btree (person_id);
ALTER TABLE cdm.payer_plan_period CLUSTER ON idx_period_person_id_1;
CREATE INDEX idx_person_id ON cdm.person USING btree (person_id);
ALTER TABLE cdm.person CLUSTER ON idx_person_id;
CREATE INDEX idx_procedure_concept_id_1 ON cdm.procedure_occurrence USING btree (procedure_concept_id);
CREATE INDEX idx_procedure_person_id_1 ON cdm.procedure_occurrence USING btree (person_id);
ALTER TABLE cdm.procedure_occurrence CLUSTER ON idx_procedure_person_id_1;
CREATE INDEX idx_procedure_visit_id_1 ON cdm.procedure_occurrence USING btree (visit_occurrence_id);
CREATE INDEX idx_provider_id_1 ON cdm.provider USING btree (provider_id);
ALTER TABLE cdm.provider CLUSTER ON idx_provider_id_1;
CREATE INDEX idx_relationship_rel_id ON cdm.relationship USING btree (relationship_id);
ALTER TABLE cdm.relationship CLUSTER ON idx_relationship_rel_id;
CREATE INDEX idx_source_to_concept_map_1 ON cdm.source_to_concept_map USING btree (source_vocabulary_id);
CREATE INDEX idx_source_to_concept_map_2 ON cdm.source_to_concept_map USING btree (target_vocabulary_id);
CREATE INDEX idx_source_to_concept_map_3 ON cdm.source_to_concept_map USING btree (target_concept_id);
ALTER TABLE cdm.source_to_concept_map CLUSTER ON idx_source_to_concept_map_3;
CREATE INDEX idx_source_to_concept_map_c ON cdm.source_to_concept_map USING btree (source_code);
CREATE INDEX idx_specimen_concept_id_1 ON cdm.specimen USING btree (specimen_concept_id);
CREATE INDEX idx_specimen_person_id_1 ON cdm.specimen USING btree (person_id);
ALTER TABLE cdm.specimen CLUSTER ON idx_specimen_person_id_1;
CREATE INDEX idx_visit_concept_id_1 ON cdm.visit_occurrence USING btree (visit_concept_id);
CREATE INDEX idx_visit_det_concept_id_1 ON cdm.visit_detail USING btree (visit_detail_concept_id);
CREATE INDEX idx_visit_det_occ_id ON cdm.visit_detail USING btree (visit_occurrence_id);
CREATE INDEX idx_visit_det_person_id_1 ON cdm.visit_detail USING btree (person_id);
ALTER TABLE cdm.visit_detail CLUSTER ON idx_visit_det_person_id_1;
CREATE INDEX idx_visit_person_id_1 ON cdm.visit_occurrence USING btree (person_id);
ALTER TABLE cdm.visit_occurrence CLUSTER ON idx_visit_person_id_1;
CREATE INDEX idx_vocabulary_vocabulary_id ON cdm.vocabulary USING btree (vocabulary_id);
ALTER TABLE cdm.vocabulary CLUSTER ON idx_vocabulary_vocabulary_id;
ALTER TABLE ONLY cdm.care_site
    ADD CONSTRAINT fpk_care_site_location_id FOREIGN KEY (location_id) REFERENCES cdm.location(location_id);
ALTER TABLE ONLY cdm.care_site
    ADD CONSTRAINT fpk_care_site_place_of_service_concept_id FOREIGN KEY (place_of_service_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.cdm_source
    ADD CONSTRAINT fpk_cdm_source_cdm_version_concept_id FOREIGN KEY (cdm_version_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.concept_ancestor
    ADD CONSTRAINT fpk_concept_ancestor_ancestor_concept_id FOREIGN KEY (ancestor_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.concept_ancestor
    ADD CONSTRAINT fpk_concept_ancestor_descendant_concept_id FOREIGN KEY (descendant_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.concept_class
    ADD CONSTRAINT fpk_concept_class_concept_class_concept_id FOREIGN KEY (concept_class_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.concept
    ADD CONSTRAINT fpk_concept_concept_class_id FOREIGN KEY (concept_class_id) REFERENCES cdm.concept_class(concept_class_id);
ALTER TABLE ONLY cdm.concept
    ADD CONSTRAINT fpk_concept_domain_id FOREIGN KEY (domain_id) REFERENCES cdm.domain(domain_id);
ALTER TABLE ONLY cdm.concept_relationship
    ADD CONSTRAINT fpk_concept_relationship_concept_id_1 FOREIGN KEY (concept_id_1) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.concept_relationship
    ADD CONSTRAINT fpk_concept_relationship_concept_id_2 FOREIGN KEY (concept_id_2) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.concept_relationship
    ADD CONSTRAINT fpk_concept_relationship_relationship_id FOREIGN KEY (relationship_id) REFERENCES cdm.relationship(relationship_id);
ALTER TABLE ONLY cdm.concept_synonym
    ADD CONSTRAINT fpk_concept_synonym_concept_id FOREIGN KEY (concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.concept_synonym
    ADD CONSTRAINT fpk_concept_synonym_language_concept_id FOREIGN KEY (language_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.concept
    ADD CONSTRAINT fpk_concept_vocabulary_id FOREIGN KEY (vocabulary_id) REFERENCES cdm.vocabulary(vocabulary_id);
ALTER TABLE ONLY cdm.condition_era
    ADD CONSTRAINT fpk_condition_era_condition_concept_id FOREIGN KEY (condition_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.condition_era
    ADD CONSTRAINT fpk_condition_era_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT fpk_condition_occurrence_condition_concept_id FOREIGN KEY (condition_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT fpk_condition_occurrence_condition_source_concept_id FOREIGN KEY (condition_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT fpk_condition_occurrence_condition_status_concept_id FOREIGN KEY (condition_status_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT fpk_condition_occurrence_condition_type_concept_id FOREIGN KEY (condition_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT fpk_condition_occurrence_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT fpk_condition_occurrence_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT fpk_condition_occurrence_visit_detail_id FOREIGN KEY (visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.condition_occurrence
    ADD CONSTRAINT fpk_condition_occurrence_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.cost
    ADD CONSTRAINT fpk_cost_cost_domain_id FOREIGN KEY (cost_domain_id) REFERENCES cdm.domain(domain_id);
ALTER TABLE ONLY cdm.cost
    ADD CONSTRAINT fpk_cost_cost_type_concept_id FOREIGN KEY (cost_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.cost
    ADD CONSTRAINT fpk_cost_currency_concept_id FOREIGN KEY (currency_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.cost
    ADD CONSTRAINT fpk_cost_drg_concept_id FOREIGN KEY (drg_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.cost
    ADD CONSTRAINT fpk_cost_revenue_code_concept_id FOREIGN KEY (revenue_code_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.death
    ADD CONSTRAINT fpk_death_cause_concept_id FOREIGN KEY (cause_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.death
    ADD CONSTRAINT fpk_death_cause_source_concept_id FOREIGN KEY (cause_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.death
    ADD CONSTRAINT fpk_death_death_type_concept_id FOREIGN KEY (death_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.death
    ADD CONSTRAINT fpk_death_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_device_concept_id FOREIGN KEY (device_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_device_source_concept_id FOREIGN KEY (device_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_device_type_concept_id FOREIGN KEY (device_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_unit_concept_id FOREIGN KEY (unit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_unit_source_concept_id FOREIGN KEY (unit_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_visit_detail_id FOREIGN KEY (visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.device_exposure
    ADD CONSTRAINT fpk_device_exposure_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.domain
    ADD CONSTRAINT fpk_domain_domain_concept_id FOREIGN KEY (domain_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.dose_era
    ADD CONSTRAINT fpk_dose_era_drug_concept_id FOREIGN KEY (drug_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.dose_era
    ADD CONSTRAINT fpk_dose_era_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.dose_era
    ADD CONSTRAINT fpk_dose_era_unit_concept_id FOREIGN KEY (unit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_era
    ADD CONSTRAINT fpk_drug_era_drug_concept_id FOREIGN KEY (drug_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_era
    ADD CONSTRAINT fpk_drug_era_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT fpk_drug_exposure_drug_concept_id FOREIGN KEY (drug_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT fpk_drug_exposure_drug_source_concept_id FOREIGN KEY (drug_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT fpk_drug_exposure_drug_type_concept_id FOREIGN KEY (drug_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT fpk_drug_exposure_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT fpk_drug_exposure_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT fpk_drug_exposure_route_concept_id FOREIGN KEY (route_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT fpk_drug_exposure_visit_detail_id FOREIGN KEY (visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.drug_exposure
    ADD CONSTRAINT fpk_drug_exposure_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.drug_strength
    ADD CONSTRAINT fpk_drug_strength_amount_unit_concept_id FOREIGN KEY (amount_unit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_strength
    ADD CONSTRAINT fpk_drug_strength_denominator_unit_concept_id FOREIGN KEY (denominator_unit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_strength
    ADD CONSTRAINT fpk_drug_strength_drug_concept_id FOREIGN KEY (drug_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_strength
    ADD CONSTRAINT fpk_drug_strength_ingredient_concept_id FOREIGN KEY (ingredient_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.drug_strength
    ADD CONSTRAINT fpk_drug_strength_numerator_unit_concept_id FOREIGN KEY (numerator_unit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.episode
    ADD CONSTRAINT fpk_episode_episode_concept_id FOREIGN KEY (episode_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.episode
    ADD CONSTRAINT fpk_episode_episode_object_concept_id FOREIGN KEY (episode_object_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.episode
    ADD CONSTRAINT fpk_episode_episode_source_concept_id FOREIGN KEY (episode_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.episode
    ADD CONSTRAINT fpk_episode_episode_type_concept_id FOREIGN KEY (episode_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.episode_event
    ADD CONSTRAINT fpk_episode_event_episode_event_field_concept_id FOREIGN KEY (episode_event_field_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.episode_event
    ADD CONSTRAINT fpk_episode_event_episode_id FOREIGN KEY (episode_id) REFERENCES cdm.episode(episode_id);
ALTER TABLE ONLY cdm.episode
    ADD CONSTRAINT fpk_episode_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.fact_relationship
    ADD CONSTRAINT fpk_fact_relationship_domain_concept_id_1 FOREIGN KEY (domain_concept_id_1) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.fact_relationship
    ADD CONSTRAINT fpk_fact_relationship_domain_concept_id_2 FOREIGN KEY (domain_concept_id_2) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.fact_relationship
    ADD CONSTRAINT fpk_fact_relationship_relationship_concept_id FOREIGN KEY (relationship_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.location
    ADD CONSTRAINT fpk_location_country_concept_id FOREIGN KEY (country_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_meas_event_field_concept_id FOREIGN KEY (meas_event_field_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_measurement_concept_id FOREIGN KEY (measurement_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_measurement_source_concept_id FOREIGN KEY (measurement_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_measurement_type_concept_id FOREIGN KEY (measurement_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_operator_concept_id FOREIGN KEY (operator_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_unit_concept_id FOREIGN KEY (unit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_unit_source_concept_id FOREIGN KEY (unit_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_value_as_concept_id FOREIGN KEY (value_as_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_visit_detail_id FOREIGN KEY (visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.measurement
    ADD CONSTRAINT fpk_measurement_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.metadata
    ADD CONSTRAINT fpk_metadata_metadata_concept_id FOREIGN KEY (metadata_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.metadata
    ADD CONSTRAINT fpk_metadata_metadata_type_concept_id FOREIGN KEY (metadata_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.metadata
    ADD CONSTRAINT fpk_metadata_value_as_concept_id FOREIGN KEY (value_as_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_encoding_concept_id FOREIGN KEY (encoding_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_language_concept_id FOREIGN KEY (language_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note_nlp
    ADD CONSTRAINT fpk_note_nlp_note_nlp_concept_id FOREIGN KEY (note_nlp_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note_nlp
    ADD CONSTRAINT fpk_note_nlp_note_nlp_source_concept_id FOREIGN KEY (note_nlp_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note_nlp
    ADD CONSTRAINT fpk_note_nlp_section_concept_id FOREIGN KEY (section_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_note_class_concept_id FOREIGN KEY (note_class_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_note_event_field_concept_id FOREIGN KEY (note_event_field_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_note_type_concept_id FOREIGN KEY (note_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_visit_detail_id FOREIGN KEY (visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.note
    ADD CONSTRAINT fpk_note_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_obs_event_field_concept_id FOREIGN KEY (obs_event_field_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_observation_concept_id FOREIGN KEY (observation_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_observation_source_concept_id FOREIGN KEY (observation_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_observation_type_concept_id FOREIGN KEY (observation_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.observation_period
    ADD CONSTRAINT fpk_observation_period_period_type_concept_id FOREIGN KEY (period_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.observation_period
    ADD CONSTRAINT fpk_observation_period_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_qualifier_concept_id FOREIGN KEY (qualifier_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_unit_concept_id FOREIGN KEY (unit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_value_as_concept_id FOREIGN KEY (value_as_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_visit_detail_id FOREIGN KEY (visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.observation
    ADD CONSTRAINT fpk_observation_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_payer_concept_id FOREIGN KEY (payer_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_payer_plan_period_id FOREIGN KEY (payer_plan_period_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_payer_source_concept_id FOREIGN KEY (payer_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_plan_concept_id FOREIGN KEY (plan_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_plan_source_concept_id FOREIGN KEY (plan_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_sponsor_concept_id FOREIGN KEY (sponsor_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_sponsor_source_concept_id FOREIGN KEY (sponsor_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_stop_reason_concept_id FOREIGN KEY (stop_reason_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.payer_plan_period
    ADD CONSTRAINT fpk_payer_plan_period_stop_reason_source_concept_id FOREIGN KEY (stop_reason_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_care_site_id FOREIGN KEY (care_site_id) REFERENCES cdm.care_site(care_site_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_ethnicity_concept_id FOREIGN KEY (ethnicity_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_ethnicity_source_concept_id FOREIGN KEY (ethnicity_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_gender_concept_id FOREIGN KEY (gender_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_gender_source_concept_id FOREIGN KEY (gender_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_location_id FOREIGN KEY (location_id) REFERENCES cdm.location(location_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_race_concept_id FOREIGN KEY (race_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.person
    ADD CONSTRAINT fpk_person_race_source_concept_id FOREIGN KEY (race_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT fpk_procedure_occurrence_modifier_concept_id FOREIGN KEY (modifier_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT fpk_procedure_occurrence_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT fpk_procedure_occurrence_procedure_concept_id FOREIGN KEY (procedure_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT fpk_procedure_occurrence_procedure_source_concept_id FOREIGN KEY (procedure_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT fpk_procedure_occurrence_procedure_type_concept_id FOREIGN KEY (procedure_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT fpk_procedure_occurrence_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT fpk_procedure_occurrence_visit_detail_id FOREIGN KEY (visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.procedure_occurrence
    ADD CONSTRAINT fpk_procedure_occurrence_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.provider
    ADD CONSTRAINT fpk_provider_care_site_id FOREIGN KEY (care_site_id) REFERENCES cdm.care_site(care_site_id);
ALTER TABLE ONLY cdm.provider
    ADD CONSTRAINT fpk_provider_gender_concept_id FOREIGN KEY (gender_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.provider
    ADD CONSTRAINT fpk_provider_gender_source_concept_id FOREIGN KEY (gender_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.provider
    ADD CONSTRAINT fpk_provider_specialty_concept_id FOREIGN KEY (specialty_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.provider
    ADD CONSTRAINT fpk_provider_specialty_source_concept_id FOREIGN KEY (specialty_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.relationship
    ADD CONSTRAINT fpk_relationship_relationship_concept_id FOREIGN KEY (relationship_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.source_to_concept_map
    ADD CONSTRAINT fpk_source_to_concept_map_source_concept_id FOREIGN KEY (source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.source_to_concept_map
    ADD CONSTRAINT fpk_source_to_concept_map_target_concept_id FOREIGN KEY (target_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.source_to_concept_map
    ADD CONSTRAINT fpk_source_to_concept_map_target_vocabulary_id FOREIGN KEY (target_vocabulary_id) REFERENCES cdm.vocabulary(vocabulary_id);
ALTER TABLE ONLY cdm.specimen
    ADD CONSTRAINT fpk_specimen_anatomic_site_concept_id FOREIGN KEY (anatomic_site_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.specimen
    ADD CONSTRAINT fpk_specimen_disease_status_concept_id FOREIGN KEY (disease_status_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.specimen
    ADD CONSTRAINT fpk_specimen_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.specimen
    ADD CONSTRAINT fpk_specimen_specimen_concept_id FOREIGN KEY (specimen_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.specimen
    ADD CONSTRAINT fpk_specimen_specimen_type_concept_id FOREIGN KEY (specimen_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.specimen
    ADD CONSTRAINT fpk_specimen_unit_concept_id FOREIGN KEY (unit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_admitted_from_concept_id FOREIGN KEY (admitted_from_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_care_site_id FOREIGN KEY (care_site_id) REFERENCES cdm.care_site(care_site_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_discharged_to_concept_id FOREIGN KEY (discharged_to_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_parent_visit_detail_id FOREIGN KEY (parent_visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_preceding_visit_detail_id FOREIGN KEY (preceding_visit_detail_id) REFERENCES cdm.visit_detail(visit_detail_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_visit_detail_concept_id FOREIGN KEY (visit_detail_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_visit_detail_source_concept_id FOREIGN KEY (visit_detail_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_visit_detail_type_concept_id FOREIGN KEY (visit_detail_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_detail
    ADD CONSTRAINT fpk_visit_detail_visit_occurrence_id FOREIGN KEY (visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_admitted_from_concept_id FOREIGN KEY (admitted_from_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_care_site_id FOREIGN KEY (care_site_id) REFERENCES cdm.care_site(care_site_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_discharged_to_concept_id FOREIGN KEY (discharged_to_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_person_id FOREIGN KEY (person_id) REFERENCES cdm.person(person_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_preceding_visit_occurrence_id FOREIGN KEY (preceding_visit_occurrence_id) REFERENCES cdm.visit_occurrence(visit_occurrence_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_provider_id FOREIGN KEY (provider_id) REFERENCES cdm.provider(provider_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_visit_concept_id FOREIGN KEY (visit_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_visit_source_concept_id FOREIGN KEY (visit_source_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.visit_occurrence
    ADD CONSTRAINT fpk_visit_occurrence_visit_type_concept_id FOREIGN KEY (visit_type_concept_id) REFERENCES cdm.concept(concept_id);
ALTER TABLE ONLY cdm.vocabulary
    ADD CONSTRAINT fpk_vocabulary_vocabulary_concept_id FOREIGN KEY (vocabulary_concept_id) REFERENCES cdm.concept(concept_id);
