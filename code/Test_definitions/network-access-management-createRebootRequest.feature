  @basic_tier
Feature: CAMARA Network Access Management API, v0.2.0-alpha.1 - Operation createRebootRequest
  # Operation: POST /reboot-requests
  # Required scope: network-access-management:reboot
  # Documented response codes: 201, 400, 401, 403, 404, 409, 422, 500, 503
  #
  # Tagging:
  # - @network_access_management_createRebootRequest_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.
  # Pending full-tier coverage: 400, 401, 403, 404, 409, 422.

  Background: Common createRebootRequest setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/v0.2alpha1/reboot-requests"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:reboot"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/RebootRequestCreate"

  @network_access_management_createRebootRequest_01_immediate_default_device_success @backend_controlled
  Scenario: Request an immediate reboot of the default device (implicit targeting)
    Given the calling subscriber has exactly one reboot-capable Network Access Device
    And the API provider supports default-device inference
    And the request body is set to the example "RebootRequestCreateImmediateDefaultDevice" of the schema "RebootRequestCreate"
    When the request "createRebootRequest" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/RebootRequest"
    And the response property "$.id" is a valid UUID
    And the response property "$.devices" is an array of length 1 containing the inferred default device id

  @network_access_management_createRebootRequest_02_scheduled_explicit_devices_success
  Scenario: Schedule a reboot for an explicit list of multiple devices
    Given the calling subscriber has at least two reboot-capable Network Access Devices
    And the request body is set to the example "RebootRequestCreateScheduledMultipleDevices" of the schema "RebootRequestCreate"
    And the request body property "$.atTime" is set to a valid RFC 3339 date-time at least 1 hour in the future
    When the request "createRebootRequest" is sent
    Then the response status code is 201
    And the response body complies with the OAS schema at "/components/schemas/RebootRequest"
    And the response property "$.devices" matches the request body property "$.devices"
    And the response property "$.atTime" is the same as the request body property "$.atTime"
