  @basic_tier
Feature: CAMARA Network Access Devices API, vwip - Operation deleteRebootRequest
  # Operation: DELETE /reboot-requests/{rebootRequestId}
  # Required scope: network-access-devices:reboot
  # Documented response codes: 204, 401, 403, 404, 500, 503
  #
  # Tagging:
  # - @network_access_devices_deleteRebootRequest_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common deleteRebootRequest setup
    Given an environment at "apiRoot"
    And the resource "/network-access-devices/vwip/reboot-requests/{rebootRequestId}"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-devices:reboot"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_devices_deleteRebootRequest_01_delete_success
  Scenario: Delete (cancel) a pending Reboot Request
    Given the path parameter "rebootRequestId" is set to the id of a pending Reboot Request created by the calling API client
    When the request "deleteRebootRequest" is sent
    Then the response status code is 204
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body is empty

  @network_access_devices_deleteRebootRequest_02_state_coherence_after_delete
  Scenario: After successful deletion, GET on the same id returns 404
    Given the path parameter "rebootRequestId" is set to the id of a pending Reboot Request created by the calling API client
    And the request "deleteRebootRequest" has been sent and returned 204
    When the request "getRebootRequest" is sent
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"
