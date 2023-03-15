SET check_function_bodies = false;
CREATE TYPE public.resource_status AS ENUM (
    'created',
    'updated',
    'deleted',
    'recreated'
);
CREATE TYPE public._resource AS (
	id text,
	txid bigint,
	ts timestamp with time zone,
	resource_type text,
	status public.resource_status,
	resource jsonb
);
CREATE FUNCTION public._fhirbase_to_resource(x public._resource) RETURNS jsonb
    LANGUAGE sql
    AS $$
 select x.resource || jsonb_build_object(
  'resourceType', x.resource_type,
  'id', x.id,
  'meta', coalesce(x.resource->'meta', '{}'::jsonb) || jsonb_build_object(
    'lastUpdated', x.ts,
    'versionId', x.txid::text
  )
 );
$$;
CREATE FUNCTION public.fhirbase_create(resource jsonb) RETURNS jsonb
    LANGUAGE sql
    AS $$
   SELECT fhirbase_create(resource, nextval('transaction_id_seq'));
$$;
CREATE FUNCTION public.fhirbase_create(resource jsonb, txid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _sql text;
  rt text;
  rid text;
  result jsonb;
BEGIN
    rt   := resource->>'resourceType';
    rid  := coalesce(resource->>'id', fhirbase_genid());
    _sql := format($SQL$
      WITH archived AS (
        INSERT INTO %s (id, txid, ts, status, resource)
        SELECT id, txid, ts, status, resource
        FROM %s
        WHERE id = $2
        RETURNING *
      ), inserted AS (
         INSERT INTO %s (id, ts, txid, status, resource)
         VALUES ($2, current_timestamp, $1, 'created', $3)
         ON CONFLICT (id)
         DO UPDATE SET
          txid = $1,
          ts = current_timestamp,
          status = 'recreated',
          resource = $3
         RETURNING *
      )
      select _fhirbase_to_resource(i.*) from inserted i
      $SQL$,
      rt || '_history', rt, rt, rt);
  EXECUTE _sql
  USING txid, rid, jsonb_set(resource, '{id}', to_jsonb(rid::text), true)
  INTO result;
  return result;
END
$_$;
CREATE FUNCTION public.fhirbase_delete(resource_type text, id text) RETURNS jsonb
    LANGUAGE sql
    AS $$
   SELECT fhirbase_delete(resource_type, id, nextval('transaction_id_seq'));
$$;
CREATE FUNCTION public.fhirbase_delete(resource_type text, id text, txid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _sql text;
  rt text;
  rid text;
  result jsonb;
BEGIN
    rt   := resource_type;
    rid  := id;
    _sql := format($SQL$
      WITH archived AS (
        INSERT INTO %s (id, txid, ts, status, resource)
        SELECT id, txid, ts, status, resource
        FROM %s WHERE id = $2
        RETURNING *
      ), deleted AS (
         INSERT INTO %s (id, txid, ts, status, resource)
         SELECT id, $1, current_timestamp, status, resource
         FROM %s WHERE id = $2
         RETURNING *
      ), dropped AS (
         DELETE FROM %s WHERE id = $2 RETURNING *
      )
      select _fhirbase_to_resource(i.*) from archived i
      $SQL$,
      rt || '_history', rt, rt || '_history', rt, rt);
  EXECUTE _sql
  USING txid, rid
  INTO result;
  return result;
END
$_$;
CREATE FUNCTION public.fhirbase_genid() RETURNS text
    LANGUAGE sql
    AS $$
  select gen_random_uuid()::text
$$;
CREATE FUNCTION public.fhirbase_read(resource_type text, id text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _sql text;
  result jsonb;
BEGIN
  _sql := format($SQL$
    SELECT _fhirbase_to_resource(row(r.*)::_resource) FROM %s r WHERE r.id = $1
  $SQL$,
  resource_type
  );
  EXECUTE _sql USING id INTO result;
  return result;
END
$_$;
CREATE FUNCTION public.fhirbase_update(resource jsonb) RETURNS jsonb
    LANGUAGE sql
    AS $$
   SELECT fhirbase_update(resource, nextval('transaction_id_seq'));
$$;
CREATE FUNCTION public.fhirbase_update(resource jsonb, txid bigint) RETURNS jsonb
    LANGUAGE plpgsql
    AS $_$
DECLARE
  _sql text ;
  rt text;
  rid text;
  result jsonb;
BEGIN
    rt   := resource->>'resourceType';
    rid  := resource->>'id';
    CASE WHEN (rid IS NULL) THEN
      RAISE EXCEPTION 'Resource does not have and id' USING HINT = 'Resource does not have and id';
    ELSE
    END CASE;
    _sql := format($SQL$
      WITH archived AS (
        INSERT INTO %s (id, txid, ts, status, resource)
        SELECT id, txid, ts, status, resource
        FROM %s
        WHERE id = $2
        RETURNING *
      ), inserted AS (
         INSERT INTO %s (id, ts, txid, status, resource)
         VALUES ($2, current_timestamp, $1, 'created', $3)
         ON CONFLICT (id)
         DO UPDATE SET
          txid = $1,
          ts = current_timestamp,
          status = 'updated',
          resource = $3
         RETURNING *
      )
      select _fhirbase_to_resource(i.*) from inserted i
      $SQL$,
      rt || '_history', rt, rt, rt);
  EXECUTE _sql
  USING txid, rid, (resource - 'id')
  INTO result;
  return result;
END
$_$;
CREATE TABLE public.account (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Account'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.account_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Account'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.activitydefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ActivityDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.activitydefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ActivityDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.adverseevent (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'AdverseEvent'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.adverseevent_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'AdverseEvent'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.allergyintolerance (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'AllergyIntolerance'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.allergyintolerance_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'AllergyIntolerance'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.appointment (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Appointment'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.appointment_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Appointment'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.appointmentresponse (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'AppointmentResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.appointmentresponse_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'AppointmentResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.auditevent (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'AuditEvent'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.auditevent_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'AuditEvent'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.basic (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Basic'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.basic_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Basic'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public."binary" (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Binary'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.binary_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Binary'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.biologicallyderivedproduct (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'BiologicallyDerivedProduct'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.biologicallyderivedproduct_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'BiologicallyDerivedProduct'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.bodystructure (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'BodyStructure'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.bodystructure_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'BodyStructure'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.capabilitystatement (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CapabilityStatement'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.capabilitystatement_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CapabilityStatement'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.careplan (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CarePlan'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.careplan_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CarePlan'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.careteam (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CareTeam'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.careteam_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CareTeam'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.chargeitem (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ChargeItem'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.chargeitem_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ChargeItem'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.claim (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Claim'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.claim_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Claim'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.claimresponse (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ClaimResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.claimresponse_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ClaimResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.clinicalimpression (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ClinicalImpression'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.clinicalimpression_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ClinicalImpression'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.codesystem (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CodeSystem'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.codesystem_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CodeSystem'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.communication (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Communication'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.communication_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Communication'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.communicationrequest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CommunicationRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.communicationrequest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CommunicationRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.compartmentdefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CompartmentDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.compartmentdefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'CompartmentDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.composition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Composition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.composition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Composition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.concept (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Concept'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.concept_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Concept'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.conceptmap (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ConceptMap'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.conceptmap_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ConceptMap'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.condition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Condition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.condition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Condition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.consent (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Consent'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.consent_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Consent'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.contract (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Contract'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.contract_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Contract'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.coverage (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Coverage'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.coverage_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Coverage'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.detectedissue (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DetectedIssue'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.detectedissue_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DetectedIssue'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.device (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Device'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.device_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Device'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.devicecomponent (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DeviceComponent'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.devicecomponent_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DeviceComponent'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.devicemetric (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DeviceMetric'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.devicemetric_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DeviceMetric'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.devicerequest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DeviceRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.devicerequest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DeviceRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.deviceusestatement (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DeviceUseStatement'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.deviceusestatement_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DeviceUseStatement'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.diagnosticreport (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DiagnosticReport'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.diagnosticreport_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DiagnosticReport'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.documentmanifest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DocumentManifest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.documentmanifest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DocumentManifest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.documentreference (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DocumentReference'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.documentreference_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'DocumentReference'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.eligibilityrequest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EligibilityRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.eligibilityrequest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EligibilityRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.eligibilityresponse (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EligibilityResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.eligibilityresponse_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EligibilityResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.encounter (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Encounter'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.encounter_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Encounter'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.endpoint (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Endpoint'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.endpoint_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Endpoint'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.enrollmentrequest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EnrollmentRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.enrollmentrequest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EnrollmentRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.enrollmentresponse (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EnrollmentResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.enrollmentresponse_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EnrollmentResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.entrydefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EntryDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.entrydefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EntryDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.episodeofcare (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EpisodeOfCare'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.episodeofcare_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EpisodeOfCare'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.eventdefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EventDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.eventdefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'EventDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.examplescenario (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ExampleScenario'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.examplescenario_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ExampleScenario'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.expansionprofile (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ExpansionProfile'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.expansionprofile_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ExpansionProfile'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.explanationofbenefit (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ExplanationOfBenefit'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.explanationofbenefit_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ExplanationOfBenefit'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.familymemberhistory (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'FamilyMemberHistory'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.familymemberhistory_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'FamilyMemberHistory'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.flag (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Flag'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.flag_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Flag'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.goal (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Goal'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.goal_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Goal'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.graphdefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'GraphDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.graphdefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'GraphDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public."group" (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Group'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.group_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Group'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.guidanceresponse (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'GuidanceResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.guidanceresponse_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'GuidanceResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.healthcareservice (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'HealthcareService'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.healthcareservice_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'HealthcareService'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.imagingstudy (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ImagingStudy'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.imagingstudy_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ImagingStudy'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.immunization (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Immunization'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.immunization_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Immunization'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.immunizationevaluation (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ImmunizationEvaluation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.immunizationevaluation_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ImmunizationEvaluation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.immunizationrecommendation (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ImmunizationRecommendation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.immunizationrecommendation_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ImmunizationRecommendation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.implementationguide (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ImplementationGuide'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.implementationguide_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ImplementationGuide'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.invoice (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Invoice'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.invoice_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Invoice'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.iteminstance (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ItemInstance'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.iteminstance_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ItemInstance'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.library (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Library'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.library_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Library'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.linkage (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Linkage'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.linkage_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Linkage'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.list (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'List'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.list_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'List'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.location (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Location'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.location_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Location'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.measure (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Measure'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.measure_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Measure'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.measurereport (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MeasureReport'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.measurereport_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MeasureReport'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.media (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Media'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.media_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Media'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medication (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Medication'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medication_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Medication'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicationadministration (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicationAdministration'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicationadministration_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicationAdministration'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicationdispense (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicationDispense'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicationdispense_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicationDispense'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicationrequest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicationRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicationrequest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicationRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicationstatement (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicationStatement'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicationstatement_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicationStatement'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproduct (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProduct'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproduct_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProduct'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductauthorization (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductAuthorization'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductauthorization_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductAuthorization'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductclinicals (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductClinicals'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductclinicals_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductClinicals'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductdevicespec (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductDeviceSpec'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductdevicespec_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductDeviceSpec'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductingredient (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductIngredient'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductingredient_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductIngredient'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductpackaged (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductPackaged'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductpackaged_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductPackaged'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductpharmaceutical (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductPharmaceutical'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.medicinalproductpharmaceutical_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MedicinalProductPharmaceutical'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.messagedefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MessageDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.messagedefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MessageDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.messageheader (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MessageHeader'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.messageheader_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MessageHeader'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.metadataresource (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MetadataResource'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.metadataresource_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'MetadataResource'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.namingsystem (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'NamingSystem'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.namingsystem_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'NamingSystem'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.nutritionorder (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'NutritionOrder'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.nutritionorder_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'NutritionOrder'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.observation (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Observation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.observation_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Observation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.observationdefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ObservationDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.observationdefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ObservationDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.occupationaldata (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'OccupationalData'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.occupationaldata_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'OccupationalData'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.operationdefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'OperationDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.operationdefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'OperationDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.operationoutcome (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'OperationOutcome'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.operationoutcome_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'OperationOutcome'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.organization (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Organization'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.organization_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Organization'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.organizationrole (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'OrganizationRole'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.organizationrole_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'OrganizationRole'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.parameters (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Parameters'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.parameters_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Parameters'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.patient (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Patient'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.patient_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Patient'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.paymentnotice (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'PaymentNotice'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.paymentnotice_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'PaymentNotice'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.paymentreconciliation (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'PaymentReconciliation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.paymentreconciliation_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'PaymentReconciliation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.person (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Person'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.person_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Person'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.plandefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'PlanDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.plandefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'PlanDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.practitioner (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Practitioner'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.practitioner_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Practitioner'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.practitionerrole (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'PractitionerRole'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.practitionerrole_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'PractitionerRole'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.procedure (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Procedure'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.procedure_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Procedure'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.processrequest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ProcessRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.processrequest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ProcessRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.processresponse (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ProcessResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.processresponse_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ProcessResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.productplan (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ProductPlan'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.productplan_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ProductPlan'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.provenance (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Provenance'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.provenance_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Provenance'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.questionnaire (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Questionnaire'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.questionnaire_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Questionnaire'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.questionnaireresponse (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'QuestionnaireResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.questionnaireresponse_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'QuestionnaireResponse'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.relatedperson (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'RelatedPerson'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.relatedperson_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'RelatedPerson'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.requestgroup (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'RequestGroup'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.requestgroup_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'RequestGroup'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.researchstudy (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ResearchStudy'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.researchstudy_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ResearchStudy'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.researchsubject (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ResearchSubject'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.researchsubject_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ResearchSubject'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.riskassessment (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'RiskAssessment'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.riskassessment_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'RiskAssessment'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.schedule (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Schedule'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.schedule_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Schedule'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.sequence (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Sequence'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.sequence_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Sequence'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.servicerequest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ServiceRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.servicerequest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ServiceRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.slot (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Slot'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.slot_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Slot'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.specimen (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Specimen'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.specimen_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Specimen'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.specimendefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SpecimenDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.specimendefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SpecimenDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.structuredefinition (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'StructureDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.structuredefinition_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'StructureDefinition'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.structuremap (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'StructureMap'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.structuremap_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'StructureMap'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.subscription (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Subscription'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.subscription_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Subscription'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.substance (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Substance'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.substance_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Substance'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.substancepolymer (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SubstancePolymer'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.substancepolymer_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SubstancePolymer'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.substancereferenceinformation (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SubstanceReferenceInformation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.substancereferenceinformation_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SubstanceReferenceInformation'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.substancespecification (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SubstanceSpecification'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.substancespecification_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SubstanceSpecification'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.supplydelivery (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SupplyDelivery'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.supplydelivery_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SupplyDelivery'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.supplyrequest (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SupplyRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.supplyrequest_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'SupplyRequest'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.task (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Task'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.task_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'Task'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.terminologycapabilities (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'TerminologyCapabilities'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.terminologycapabilities_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'TerminologyCapabilities'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.testreport (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'TestReport'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.testreport_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'TestReport'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.testscript (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'TestScript'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.testscript_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'TestScript'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.transaction (
    id integer NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource jsonb
);
CREATE SEQUENCE public.transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.transaction_id_seq OWNED BY public.transaction.id;
CREATE TABLE public.usersession (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'UserSession'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.usersession_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'UserSession'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.valueset (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ValueSet'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.valueset_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'ValueSet'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.verificationresult (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'VerificationResult'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.verificationresult_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'VerificationResult'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.visionprescription (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'VisionPrescription'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
CREATE TABLE public.visionprescription_history (
    id text NOT NULL,
    txid bigint NOT NULL,
    ts timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    resource_type text DEFAULT 'VisionPrescription'::text,
    status public.resource_status NOT NULL,
    resource jsonb NOT NULL
);
ALTER TABLE ONLY public.transaction ALTER COLUMN id SET DEFAULT nextval('public.transaction_id_seq'::regclass);
ALTER TABLE ONLY public.account_history
    ADD CONSTRAINT account_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.activitydefinition_history
    ADD CONSTRAINT activitydefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.activitydefinition
    ADD CONSTRAINT activitydefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.adverseevent_history
    ADD CONSTRAINT adverseevent_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.adverseevent
    ADD CONSTRAINT adverseevent_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.allergyintolerance_history
    ADD CONSTRAINT allergyintolerance_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.allergyintolerance
    ADD CONSTRAINT allergyintolerance_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.appointment_history
    ADD CONSTRAINT appointment_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.appointmentresponse_history
    ADD CONSTRAINT appointmentresponse_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.appointmentresponse
    ADD CONSTRAINT appointmentresponse_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.auditevent_history
    ADD CONSTRAINT auditevent_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.auditevent
    ADD CONSTRAINT auditevent_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.basic_history
    ADD CONSTRAINT basic_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.basic
    ADD CONSTRAINT basic_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.binary_history
    ADD CONSTRAINT binary_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public."binary"
    ADD CONSTRAINT binary_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.biologicallyderivedproduct_history
    ADD CONSTRAINT biologicallyderivedproduct_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.biologicallyderivedproduct
    ADD CONSTRAINT biologicallyderivedproduct_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.bodystructure_history
    ADD CONSTRAINT bodystructure_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.bodystructure
    ADD CONSTRAINT bodystructure_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.capabilitystatement_history
    ADD CONSTRAINT capabilitystatement_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.capabilitystatement
    ADD CONSTRAINT capabilitystatement_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.careplan_history
    ADD CONSTRAINT careplan_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.careplan
    ADD CONSTRAINT careplan_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.careteam_history
    ADD CONSTRAINT careteam_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.careteam
    ADD CONSTRAINT careteam_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.chargeitem_history
    ADD CONSTRAINT chargeitem_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.chargeitem
    ADD CONSTRAINT chargeitem_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.claim_history
    ADD CONSTRAINT claim_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.claim
    ADD CONSTRAINT claim_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.claimresponse_history
    ADD CONSTRAINT claimresponse_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.claimresponse
    ADD CONSTRAINT claimresponse_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.clinicalimpression_history
    ADD CONSTRAINT clinicalimpression_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.clinicalimpression
    ADD CONSTRAINT clinicalimpression_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.codesystem_history
    ADD CONSTRAINT codesystem_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.codesystem
    ADD CONSTRAINT codesystem_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.communication_history
    ADD CONSTRAINT communication_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.communication
    ADD CONSTRAINT communication_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.communicationrequest_history
    ADD CONSTRAINT communicationrequest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.communicationrequest
    ADD CONSTRAINT communicationrequest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.compartmentdefinition_history
    ADD CONSTRAINT compartmentdefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.compartmentdefinition
    ADD CONSTRAINT compartmentdefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.composition_history
    ADD CONSTRAINT composition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.composition
    ADD CONSTRAINT composition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.concept_history
    ADD CONSTRAINT concept_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.concept
    ADD CONSTRAINT concept_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.conceptmap_history
    ADD CONSTRAINT conceptmap_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.conceptmap
    ADD CONSTRAINT conceptmap_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.condition_history
    ADD CONSTRAINT condition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.condition
    ADD CONSTRAINT condition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.consent_history
    ADD CONSTRAINT consent_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.consent
    ADD CONSTRAINT consent_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.contract_history
    ADD CONSTRAINT contract_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.contract
    ADD CONSTRAINT contract_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.coverage_history
    ADD CONSTRAINT coverage_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.coverage
    ADD CONSTRAINT coverage_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.detectedissue_history
    ADD CONSTRAINT detectedissue_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.detectedissue
    ADD CONSTRAINT detectedissue_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.device_history
    ADD CONSTRAINT device_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.device
    ADD CONSTRAINT device_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.devicecomponent_history
    ADD CONSTRAINT devicecomponent_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.devicecomponent
    ADD CONSTRAINT devicecomponent_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.devicemetric_history
    ADD CONSTRAINT devicemetric_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.devicemetric
    ADD CONSTRAINT devicemetric_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.devicerequest_history
    ADD CONSTRAINT devicerequest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.devicerequest
    ADD CONSTRAINT devicerequest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.deviceusestatement_history
    ADD CONSTRAINT deviceusestatement_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.deviceusestatement
    ADD CONSTRAINT deviceusestatement_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.diagnosticreport_history
    ADD CONSTRAINT diagnosticreport_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.diagnosticreport
    ADD CONSTRAINT diagnosticreport_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.documentmanifest_history
    ADD CONSTRAINT documentmanifest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.documentmanifest
    ADD CONSTRAINT documentmanifest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.documentreference_history
    ADD CONSTRAINT documentreference_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.documentreference
    ADD CONSTRAINT documentreference_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.eligibilityrequest_history
    ADD CONSTRAINT eligibilityrequest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.eligibilityrequest
    ADD CONSTRAINT eligibilityrequest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.eligibilityresponse_history
    ADD CONSTRAINT eligibilityresponse_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.eligibilityresponse
    ADD CONSTRAINT eligibilityresponse_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.encounter_history
    ADD CONSTRAINT encounter_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.encounter
    ADD CONSTRAINT encounter_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.endpoint_history
    ADD CONSTRAINT endpoint_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.endpoint
    ADD CONSTRAINT endpoint_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.enrollmentrequest_history
    ADD CONSTRAINT enrollmentrequest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.enrollmentrequest
    ADD CONSTRAINT enrollmentrequest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.enrollmentresponse_history
    ADD CONSTRAINT enrollmentresponse_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.enrollmentresponse
    ADD CONSTRAINT enrollmentresponse_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.entrydefinition_history
    ADD CONSTRAINT entrydefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.entrydefinition
    ADD CONSTRAINT entrydefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.episodeofcare_history
    ADD CONSTRAINT episodeofcare_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.episodeofcare
    ADD CONSTRAINT episodeofcare_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.eventdefinition_history
    ADD CONSTRAINT eventdefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.eventdefinition
    ADD CONSTRAINT eventdefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.examplescenario_history
    ADD CONSTRAINT examplescenario_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.examplescenario
    ADD CONSTRAINT examplescenario_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.expansionprofile_history
    ADD CONSTRAINT expansionprofile_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.expansionprofile
    ADD CONSTRAINT expansionprofile_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.explanationofbenefit_history
    ADD CONSTRAINT explanationofbenefit_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.explanationofbenefit
    ADD CONSTRAINT explanationofbenefit_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.familymemberhistory_history
    ADD CONSTRAINT familymemberhistory_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.familymemberhistory
    ADD CONSTRAINT familymemberhistory_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.flag_history
    ADD CONSTRAINT flag_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.flag
    ADD CONSTRAINT flag_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.goal_history
    ADD CONSTRAINT goal_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.goal
    ADD CONSTRAINT goal_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.graphdefinition_history
    ADD CONSTRAINT graphdefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.graphdefinition
    ADD CONSTRAINT graphdefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.group_history
    ADD CONSTRAINT group_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.guidanceresponse_history
    ADD CONSTRAINT guidanceresponse_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.guidanceresponse
    ADD CONSTRAINT guidanceresponse_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.healthcareservice_history
    ADD CONSTRAINT healthcareservice_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.healthcareservice
    ADD CONSTRAINT healthcareservice_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.imagingstudy_history
    ADD CONSTRAINT imagingstudy_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.imagingstudy
    ADD CONSTRAINT imagingstudy_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.immunization_history
    ADD CONSTRAINT immunization_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.immunization
    ADD CONSTRAINT immunization_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.immunizationevaluation_history
    ADD CONSTRAINT immunizationevaluation_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.immunizationevaluation
    ADD CONSTRAINT immunizationevaluation_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.immunizationrecommendation_history
    ADD CONSTRAINT immunizationrecommendation_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.immunizationrecommendation
    ADD CONSTRAINT immunizationrecommendation_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.implementationguide_history
    ADD CONSTRAINT implementationguide_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.implementationguide
    ADD CONSTRAINT implementationguide_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.invoice_history
    ADD CONSTRAINT invoice_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.iteminstance_history
    ADD CONSTRAINT iteminstance_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.iteminstance
    ADD CONSTRAINT iteminstance_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.library_history
    ADD CONSTRAINT library_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.library
    ADD CONSTRAINT library_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.linkage_history
    ADD CONSTRAINT linkage_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.linkage
    ADD CONSTRAINT linkage_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.list_history
    ADD CONSTRAINT list_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.list
    ADD CONSTRAINT list_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.location_history
    ADD CONSTRAINT location_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.measure_history
    ADD CONSTRAINT measure_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.measure
    ADD CONSTRAINT measure_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.measurereport_history
    ADD CONSTRAINT measurereport_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.measurereport
    ADD CONSTRAINT measurereport_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.media_history
    ADD CONSTRAINT media_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medication_history
    ADD CONSTRAINT medication_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medication
    ADD CONSTRAINT medication_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicationadministration_history
    ADD CONSTRAINT medicationadministration_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicationadministration
    ADD CONSTRAINT medicationadministration_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicationdispense_history
    ADD CONSTRAINT medicationdispense_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicationdispense
    ADD CONSTRAINT medicationdispense_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicationrequest_history
    ADD CONSTRAINT medicationrequest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicationrequest
    ADD CONSTRAINT medicationrequest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicationstatement_history
    ADD CONSTRAINT medicationstatement_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicationstatement
    ADD CONSTRAINT medicationstatement_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicinalproduct_history
    ADD CONSTRAINT medicinalproduct_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicinalproduct
    ADD CONSTRAINT medicinalproduct_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicinalproductauthorization_history
    ADD CONSTRAINT medicinalproductauthorization_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicinalproductauthorization
    ADD CONSTRAINT medicinalproductauthorization_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicinalproductclinicals_history
    ADD CONSTRAINT medicinalproductclinicals_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicinalproductclinicals
    ADD CONSTRAINT medicinalproductclinicals_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicinalproductdevicespec_history
    ADD CONSTRAINT medicinalproductdevicespec_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicinalproductdevicespec
    ADD CONSTRAINT medicinalproductdevicespec_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicinalproductingredient_history
    ADD CONSTRAINT medicinalproductingredient_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicinalproductingredient
    ADD CONSTRAINT medicinalproductingredient_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicinalproductpackaged_history
    ADD CONSTRAINT medicinalproductpackaged_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicinalproductpackaged
    ADD CONSTRAINT medicinalproductpackaged_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.medicinalproductpharmaceutical_history
    ADD CONSTRAINT medicinalproductpharmaceutical_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.medicinalproductpharmaceutical
    ADD CONSTRAINT medicinalproductpharmaceutical_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.messagedefinition_history
    ADD CONSTRAINT messagedefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.messagedefinition
    ADD CONSTRAINT messagedefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.messageheader_history
    ADD CONSTRAINT messageheader_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.messageheader
    ADD CONSTRAINT messageheader_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.metadataresource_history
    ADD CONSTRAINT metadataresource_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.metadataresource
    ADD CONSTRAINT metadataresource_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.namingsystem_history
    ADD CONSTRAINT namingsystem_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.namingsystem
    ADD CONSTRAINT namingsystem_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.nutritionorder_history
    ADD CONSTRAINT nutritionorder_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.nutritionorder
    ADD CONSTRAINT nutritionorder_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.observation_history
    ADD CONSTRAINT observation_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.observation
    ADD CONSTRAINT observation_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.observationdefinition_history
    ADD CONSTRAINT observationdefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.observationdefinition
    ADD CONSTRAINT observationdefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.occupationaldata_history
    ADD CONSTRAINT occupationaldata_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.occupationaldata
    ADD CONSTRAINT occupationaldata_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.operationdefinition_history
    ADD CONSTRAINT operationdefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.operationdefinition
    ADD CONSTRAINT operationdefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.operationoutcome_history
    ADD CONSTRAINT operationoutcome_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.operationoutcome
    ADD CONSTRAINT operationoutcome_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.organization_history
    ADD CONSTRAINT organization_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.organizationrole_history
    ADD CONSTRAINT organizationrole_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.organizationrole
    ADD CONSTRAINT organizationrole_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.parameters_history
    ADD CONSTRAINT parameters_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.patient_history
    ADD CONSTRAINT patient_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.patient
    ADD CONSTRAINT patient_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.paymentnotice_history
    ADD CONSTRAINT paymentnotice_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.paymentnotice
    ADD CONSTRAINT paymentnotice_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.paymentreconciliation_history
    ADD CONSTRAINT paymentreconciliation_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.paymentreconciliation
    ADD CONSTRAINT paymentreconciliation_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.person_history
    ADD CONSTRAINT person_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.plandefinition_history
    ADD CONSTRAINT plandefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.plandefinition
    ADD CONSTRAINT plandefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.practitioner_history
    ADD CONSTRAINT practitioner_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.practitioner
    ADD CONSTRAINT practitioner_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.practitionerrole_history
    ADD CONSTRAINT practitionerrole_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.practitionerrole
    ADD CONSTRAINT practitionerrole_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.procedure_history
    ADD CONSTRAINT procedure_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.procedure
    ADD CONSTRAINT procedure_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.processrequest_history
    ADD CONSTRAINT processrequest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.processrequest
    ADD CONSTRAINT processrequest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.processresponse_history
    ADD CONSTRAINT processresponse_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.processresponse
    ADD CONSTRAINT processresponse_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.productplan_history
    ADD CONSTRAINT productplan_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.productplan
    ADD CONSTRAINT productplan_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.provenance_history
    ADD CONSTRAINT provenance_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.provenance
    ADD CONSTRAINT provenance_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.questionnaire_history
    ADD CONSTRAINT questionnaire_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.questionnaire
    ADD CONSTRAINT questionnaire_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.questionnaireresponse_history
    ADD CONSTRAINT questionnaireresponse_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.questionnaireresponse
    ADD CONSTRAINT questionnaireresponse_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.relatedperson_history
    ADD CONSTRAINT relatedperson_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.relatedperson
    ADD CONSTRAINT relatedperson_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.requestgroup_history
    ADD CONSTRAINT requestgroup_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.requestgroup
    ADD CONSTRAINT requestgroup_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.researchstudy_history
    ADD CONSTRAINT researchstudy_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.researchstudy
    ADD CONSTRAINT researchstudy_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.researchsubject_history
    ADD CONSTRAINT researchsubject_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.researchsubject
    ADD CONSTRAINT researchsubject_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.riskassessment_history
    ADD CONSTRAINT riskassessment_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.riskassessment
    ADD CONSTRAINT riskassessment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.schedule_history
    ADD CONSTRAINT schedule_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.sequence_history
    ADD CONSTRAINT sequence_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT sequence_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.servicerequest_history
    ADD CONSTRAINT servicerequest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.servicerequest
    ADD CONSTRAINT servicerequest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.slot_history
    ADD CONSTRAINT slot_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.slot
    ADD CONSTRAINT slot_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.specimen_history
    ADD CONSTRAINT specimen_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.specimen
    ADD CONSTRAINT specimen_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.specimendefinition_history
    ADD CONSTRAINT specimendefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.specimendefinition
    ADD CONSTRAINT specimendefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.structuredefinition_history
    ADD CONSTRAINT structuredefinition_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.structuredefinition
    ADD CONSTRAINT structuredefinition_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.structuremap_history
    ADD CONSTRAINT structuremap_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.structuremap
    ADD CONSTRAINT structuremap_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.subscription_history
    ADD CONSTRAINT subscription_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.subscription
    ADD CONSTRAINT subscription_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.substance_history
    ADD CONSTRAINT substance_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.substance
    ADD CONSTRAINT substance_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.substancepolymer_history
    ADD CONSTRAINT substancepolymer_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.substancepolymer
    ADD CONSTRAINT substancepolymer_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.substancereferenceinformation_history
    ADD CONSTRAINT substancereferenceinformation_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.substancereferenceinformation
    ADD CONSTRAINT substancereferenceinformation_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.substancespecification_history
    ADD CONSTRAINT substancespecification_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.substancespecification
    ADD CONSTRAINT substancespecification_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.supplydelivery_history
    ADD CONSTRAINT supplydelivery_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.supplydelivery
    ADD CONSTRAINT supplydelivery_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.supplyrequest_history
    ADD CONSTRAINT supplyrequest_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.supplyrequest
    ADD CONSTRAINT supplyrequest_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.terminologycapabilities_history
    ADD CONSTRAINT terminologycapabilities_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.terminologycapabilities
    ADD CONSTRAINT terminologycapabilities_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.testreport_history
    ADD CONSTRAINT testreport_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.testreport
    ADD CONSTRAINT testreport_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.testscript_history
    ADD CONSTRAINT testscript_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.testscript
    ADD CONSTRAINT testscript_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.usersession_history
    ADD CONSTRAINT usersession_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.usersession
    ADD CONSTRAINT usersession_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.valueset_history
    ADD CONSTRAINT valueset_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.valueset
    ADD CONSTRAINT valueset_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.verificationresult_history
    ADD CONSTRAINT verificationresult_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.verificationresult
    ADD CONSTRAINT verificationresult_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.visionprescription_history
    ADD CONSTRAINT visionprescription_history_pkey PRIMARY KEY (id, txid);
ALTER TABLE ONLY public.visionprescription
    ADD CONSTRAINT visionprescription_pkey PRIMARY KEY (id);
