@basic_tier
Feature: CAMARA Network Access Management API, vwip - Operation getRebootRequests
  # Operation: GET /reboot-requests
  # Required scope: network-access-management:reboot
  # Documented response codes: 200, 401, 403, 500, 503
  #
  # Tagging:
  # - @network_access_management_getRebootRequests_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  @network_access_management_getRebootRequests_01_list_success
  Scenario: List Reboot Requests created by the calling API client
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/reboot-requests"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:reboot"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And at least one Reboot Request exists for the calling API client
    When the request "getRebootRequests" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body is an array
    And every element of the response body complies with the schema at "/components/schemas/RebootRequest"
