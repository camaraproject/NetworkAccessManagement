Feature: CAMARA Network Access Management API, vwip - Operation createTrustDomain
  # Reference:
  # - API spec: https://github.com/camaraproject/NetworkAccessManagement/blob/main/code/API_definitions/network-access-management.yaml
  # - CAMARA API Testing Guidelines: https://github.com/camaraproject/Commonalities/blob/main/documentation/API-Testing-Guidelines.md
  #
  # Operation: POST /trust-domains
  # Required scope: network-access-management:trust-domains
  # Documented response codes: 201, 400, 401, 403, 409, 500, 503
  #
  # Tagging conventions used in this file:
  # - @network_access_management_createTrustDomain_NN_<slug>  unique scenario id
  # - @basic_tier        scenario is part of the release-candidate basic test plan
  # - @full_tier         scenario only required for the full (public-release) test plan
  # - @requires_oidc     scenario depends on real OIDC enforcement at the API provider
  #                      (skip when running against a facade in auth-disabled mode)

  Background: Common createTrustDomain setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/trust-domains"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:trust-domains"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/TrustDomainCreate"
  # =====================================================================
  # Sunny-day scenarios (basic tier; sufficient for release-candidate)
  # =====================================================================

  @network_access_management_createTrustDomain_01_wpa2_personal_success @basic_tier
  Scenario: Create a Trust Domain with WPA2-Personal Wi-Fi access
    Given the request body is set to the example "TrustDomainCreateWpa2Personal" of the schema "TrustDomainCreate"
    When the request "createTrustDomain" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.id" is a valid UUID
    And the response property "$.name" is the same as the request body property "$.name"
    And the response property "$.enabled" is the same as the request body property "$.enabled"
    And the response property "$.serviceId" is the same as the request body property "$.serviceId"
    And the response property "$.accessDetails[0].accessType" is "Wi-Fi:WPA_PERSONAL"
    And the response property "$.createdAt" is a valid RFC 3339 date-time with timezone

  @network_access_management_createTrustDomain_02_inferred_ssid_success @basic_tier
  Scenario: Create a Trust Domain with inferred (omitted) SSID
    Given the request body is set to the example "TrustDomainCreateInferredSsid" of the schema "TrustDomainCreate"
    When the request "createTrustDomain" is sent
    Then the response status code is 201
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.accessDetails[0].accessType" is "Wi-Fi:WPA_PERSONAL"
    And the response property "$.accessDetails[0]" does not contain a property "ssid" or contains the SSID resolved by the network operator

  @network_access_management_createTrustDomain_03_thread_structured_success @basic_tier
  Scenario: Create a Trust Domain with Thread:STRUCTURED access
    Given the request body is set to the example "TrustDomainCreateThreadStructured" of the schema "TrustDomainCreate"
    When the request "createTrustDomain" is sent
    Then the response status code is 201
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.accessDetails[0].accessType" is "Thread:STRUCTURED"

  @network_access_management_createTrustDomain_04_policies_success @basic_tier
  Scenario: Create a Trust Domain with QoS / bandwidth policies
    Given the request body is set to the example "TrustDomainCreateQoSPolicies" of the schema "TrustDomainCreate"
    When the request "createTrustDomain" is sent
    Then the response status code is 201
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.policies" matches the request body property "$.policies"

  @network_access_management_createTrustDomain_05_ephemeral_success @basic_tier
  Scenario: Create an ephemeral Trust Domain with expiration
    Given the request body is set to the example "TrustDomainCreateEphemeral" of the schema "TrustDomainCreate"
    And the request body property "$.expiration" is set to a valid RFC 3339 date-time at least 1 hour in the future
    When the request "createTrustDomain" is sent
    Then the response status code is 201
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.expiration" is the same as the request body property "$.expiration"
  # =====================================================================
  # 400 INVALID_ARGUMENT — request shape / schema violations (full tier)
  # Adapts patterns from Commonalities/artifacts/testing/syntax-errors-template.feature
  # =====================================================================

  @network_access_management_createTrustDomain_400_01_no_request_body @full_tier
  Scenario: Missing request body
    Given the request body is removed
    When the request "createTrustDomain" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @network_access_management_createTrustDomain_400_02_empty_request_body @full_tier
  Scenario: Empty object as request body
    Given the request body is set to "{}"
    When the request "createTrustDomain" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @network_access_management_createTrustDomain_400_03_missing_required_property @full_tier
  Scenario Outline: Missing a required top-level property in TrustDomainCreate
    Given the request body property "<property>" is removed
    When the request "createTrustDomain" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a reference to "<property>"

    Examples:
      | property        |
      | $.name          |
      | $.enabled       |
      | $.accessDetails |
      | $.serviceId     |

  @network_access_management_createTrustDomain_400_04_invalid_access_type @full_tier
  Scenario: Invalid accessType discriminator value
    Given the request body property "$.accessDetails[0].accessType" is set to "Wi-Fi:UNKNOWN_PROFILE"
    When the request "createTrustDomain" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @network_access_management_createTrustDomain_400_05_access_type_payload_mismatch @full_tier
  Scenario: accessType discriminator does not match the supplied accessDetail variant
    Given the request body property "$.accessDetails[0].accessType" is set to "Thread:STRUCTURED"
    And the request body property "$.accessDetails[0]" contains the fields of a Wi-Fi:WPA_PERSONAL accessDetail except for "accessType"
    When the request "createTrustDomain" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @network_access_management_createTrustDomain_400_06_invalid_service_id_format @full_tier
  Scenario: serviceId is not a valid lowercase RFC 4122 v1-5 UUID
    Given the request body property "$.serviceId" is set to "NOT-A-UUID"
    When the request "createTrustDomain" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @network_access_management_createTrustDomain_400_07_empty_access_details @full_tier
  Scenario: accessDetails array is empty (violates minItems: 1)
    Given the request body property "$.accessDetails" is set to "[]"
    When the request "createTrustDomain" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @network_access_management_createTrustDomain_400_08_invalid_expiration @full_tier
  Scenario: expiration is not RFC 3339 with timezone
    Given the request body is set to the example "TrustDomainCreateEphemeral" of the schema "TrustDomainCreate"
    And the request body property "$.expiration" is set to "2024-12-31 23:59:59"
    When the request "createTrustDomain" is sent
    Then the response status code is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
  # =====================================================================
  # 401 UNAUTHENTICATED — auth presence / validity (full tier; requires real OIDC enforcement)
  # =====================================================================

  @network_access_management_createTrustDomain_401_01_no_authorization_header @full_tier @requires_oidc
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "createTrustDomain" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  @network_access_management_createTrustDomain_401_02_expired_token @full_tier @requires_oidc
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "createTrustDomain" is sent
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  @network_access_management_createTrustDomain_401_03_malformed_token @full_tier @requires_oidc
  Scenario: Malformed access token
    Given the header "Authorization" is set to "Bearer not-a-jwt"
    When the request "createTrustDomain" is sent
    Then the response status code is 401
    And the response property "$.code" is "UNAUTHENTICATED"
  # =====================================================================
  # 403 PERMISSION_DENIED — scope / authorization (full tier; requires real OIDC enforcement)
  # =====================================================================

  @network_access_management_createTrustDomain_403_01_missing_scope @full_tier @requires_oidc
  Scenario: Access token does not include the network-access-management:trust-domains scope
    Given the access token is replaced with one that does not contain the scope "network-access-management:trust-domains"
    When the request "createTrustDomain" is sent
    Then the response status code is 403
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"

  @network_access_management_createTrustDomain_403_02_read_only_scope @full_tier @requires_oidc
  Scenario: Access token has only the :read-all variant, which does not authorize creation
    # Background's Authorization step set a valid :trust-domains-scoped token; the
    # Given below replaces it with a :read-all-only token to verify that scope alone
    # cannot authorize creation.
    Given the access token is replaced with one whose only NAM scope is "network-access-management:trust-domains:read-all"
    When the request "createTrustDomain" is sent
    Then the response status code is 403
    And the response property "$.code" is "PERMISSION_DENIED"
  # =====================================================================
  # 409 CONFLICT — business-rule conflict (full tier)
  # =====================================================================

  @network_access_management_createTrustDomain_409_01_duplicate_name @full_tier @backend_controlled
  Scenario: A Trust Domain with the same name already exists for this caller and serviceId
    Given a Trust Domain with name "Duplicate Test TD" already exists for the caller against the same serviceId
    And the request body property "$.name" is set to "Duplicate Test TD"
    When the request "createTrustDomain" is sent
    Then the response status code is 409
    And the response property "$.status" is 409
    And the response property "$.code" is "CONFLICT"
