  @basic_tier @network_access_management_getRebootRequest_01_get_by_id_success
Feature: CAMARA Network Access Management API, vwip - Operation getRebootRequest
  # Operation: GET /reboot-requests/{rebootRequestId}
  # Required scope: network-access-management:reboot
  # Documented response codes: 200, 401, 403, 404, 500, 503
  #
  # Tagging:
  # - @network_access_management_getRebootRequest_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  @basic_tier @network_access_management_getRebootRequest_01_get_by_id_success
  Scenario: Retrieve a Reboot Request by its id
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/reboot-requests/{rebootRequestId}"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:reboot"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "rebootRequestId" is set to the id of a Reboot Request created by the calling API client
    When the request "getRebootRequest" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/RebootRequest"
    And the response property "$.id" equals the path parameter "rebootRequestId"
