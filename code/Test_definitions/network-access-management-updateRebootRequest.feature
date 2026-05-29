  @basic_tier
Feature: CAMARA Network Access Management API, v0.3.0-rc.1 - Operation updateRebootRequest
  # Operation: PATCH /reboot-requests/{rebootRequestId}
  # Required scope: network-access-management:reboot
  # Documented response codes: 200, 400, 401, 403, 404, 409, 422, 500, 503
  #
  # Tagging:
  # - @network_access_management_updateRebootRequest_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.
  # Pending full-tier coverage: 400, 401, 403, 404, 409, 422.

  Background: Common updateRebootRequest setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/v0.3rc1/reboot-requests/{rebootRequestId}"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:reboot"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/RebootRequestUpdate"
    And the path parameter "rebootRequestId" is set to the id of a pending Reboot Request created by the calling API client

  @network_access_management_updateRebootRequest_01_reschedule_success
  Scenario: Reschedule a pending Reboot Request to a later atTime
    Given the request body property "$.atTime" is set to a valid RFC 3339 date-time at least 2 hours in the future
    When the request "updateRebootRequest" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/RebootRequest"
    And the response property "$.id" equals the path parameter "rebootRequestId"
    And the response property "$.atTime" is the same as the request body property "$.atTime"

  @network_access_management_updateRebootRequest_02_cancel_success
  Scenario: Cancel a pending Reboot Request via PATCH
    Given the request body property "$.status" is set to a valid cancellation value per the RebootRequestUpdate schema
    When the request "updateRebootRequest" is sent
    Then the response status code is 200
    And the response body complies with the OAS schema at "/components/schemas/RebootRequest"
    And the response property "$.status" reflects the cancellation
