  @basic_tier
Feature: CAMARA Network Access Management API, v0.2.0-alpha.1 - Operation deleteTrustDomainDevice
  # Operation: DELETE /trust-domains/{trustDomainId}/devices/{deviceId}
  # Required scope: network-access-management:devices
  # Documented response codes: 204, 401, 403, 404, 500, 503
  #
  # Tagging:
  # - @network_access_management_deleteTrustDomainDevice_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common deleteTrustDomainDevice setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/v0.2alpha1/trust-domains/{trustDomainId}/devices/{deviceId}"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:devices"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_management_deleteTrustDomainDevice_01_delete_success
  Scenario: Deregister a device from a Trust Domain
    Given the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    And the path parameter "deviceId" is set to the id of a device registered to that Trust Domain
    When the request "deleteTrustDomainDevice" is sent
    Then the response status code is 204
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body is empty

  @network_access_management_deleteTrustDomainDevice_02_state_coherence_after_delete
  Scenario: After successful deregistration, GET on the same deviceId returns 404
    Given the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    And the path parameter "deviceId" is set to the id of a device registered to that Trust Domain
    And the request "deleteTrustDomainDevice" has been sent and returned 204
    When the request "getTrustDomainDevice" is sent
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"
