  @basic_tier @network_access_management_getServices_01_list_success
Feature: CAMARA Network Access Management API, vwip - Operation getServices
  # Operation: GET /services
  # Required scope: network-access-management:services:read
  # Documented response codes: 200, 401, 403, 500, 503
  #
  # Tagging:
  # - @network_access_management_getServices_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  @basic_tier @network_access_management_getServices_01_list_success
  Scenario: List all Services accessible to the authenticated identity
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/services"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:services:read"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    When the request "getServices" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/ServiceList"
    And every Service entry in the response body complies with the schema at "/components/schemas/Service"
