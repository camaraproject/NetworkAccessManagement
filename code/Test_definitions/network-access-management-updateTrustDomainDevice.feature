@basic_tier
Feature: CAMARA Network Access Management API, vwip - Operation updateTrustDomainDevice
  # Operation: PATCH /trust-domains/{trustDomainId}/devices/{deviceId}
  # Required scope: network-access-management:devices
  # Documented response codes: 200, 400, 401, 403, 404, 500, 503
  #
  # Tagging:
  # - @network_access_management_updateTrustDomainDevice_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common updateTrustDomainDevice setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/trust-domains/{trustDomainId}/devices/{deviceId}"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:devices"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/TrustDomainDeviceUpdate"
    And the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    And the path parameter "deviceId" is set to the id of a device registered to that Trust Domain

  @network_access_management_updateTrustDomainDevice_01_rename_success
  Scenario: Update the deviceName of a registered device
    Given the request body property "$.deviceName" is set to "Living Room Thermostat"
    When the request "updateTrustDomainDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainDevice"
    And the response property "$.id" equals the path parameter "deviceId"
    And the response property "$.deviceName" is "Living Room Thermostat"

  @network_access_management_updateTrustDomainDevice_02_replace_credential_success
  Scenario: Replace the deviceCredential on a registered device (full-replacement semantics)
    Given the request body property "$.deviceCredential" is set to a valid DeviceCredential with credentialAction "GENERATE"
    When the request "updateTrustDomainDevice" is sent
    Then the response status code is 200
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainDevice"
    And the response property "$.modifiedAt" is a valid RFC 3339 date-time with timezone
    And the response body does not echo back the request body property "$.deviceCredential.value"
