@basic_tier
Feature: CAMARA Network Access Management API, vwip - Operation updateTrustDomain
  # Operation: PATCH /trust-domains/{trustDomainId}
  # Required scope: network-access-management:trust-domains
  # Documented response codes: 200, 400, 401, 403, 404, 500, 503
  #
  # Tagging:
  # - @network_access_management_updateTrustDomain_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common updateTrustDomain setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/trust-domains/{trustDomainId}"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:trust-domains"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/TrustDomainUpdate"

  @network_access_management_updateTrustDomain_01_rename_success
  Scenario: Rename an existing Trust Domain
    Given the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    And the request body property "$.name" is set to "Renamed Network"
    When the request "updateTrustDomain" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.id" equals the path parameter "trustDomainId"
    And the response property "$.name" is "Renamed Network"
    And the response property "$.modifiedAt" is a valid RFC 3339 date-time with timezone

  @network_access_management_updateTrustDomain_02_replace_access_details_success
  Scenario: Replace the accessDetails array on an existing Trust Domain
    Given the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    And the request body property "$.accessDetails" is set to an array containing exactly one valid Wi-Fi:WPA_PERSONAL accessDetail
    When the request "updateTrustDomain" is sent
    Then the response status code is 200
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.accessDetails" has length 1
    And the response property "$.accessDetails[0].accessType" is "Wi-Fi:WPA_PERSONAL"

  @network_access_management_updateTrustDomain_03_toggle_enabled_success
  Scenario: Disable an existing Trust Domain by toggling enabled to false
    Given the path parameter "trustDomainId" is set to the id of an enabled Trust Domain created by the calling API client
    And the request body property "$.enabled" is set to false
    When the request "updateTrustDomain" is sent
    Then the response status code is 200
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.enabled" is false
