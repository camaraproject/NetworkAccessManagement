Feature: CAMARA Network Access Management API, vwip - Operation getNetworkAccessDevice
  # Operation: GET /network-access-devices/{networkAccessDeviceId}
  # Required scope: network-access-management:reboot
  # Documented response codes: 200, 401, 403, 404, 500, 503
  #
  # Tagging:
  # - @network_access_management_getNetworkAccessDevice_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common getNetworkAccessDevice setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/network-access-devices/{networkAccessDeviceId}"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:reboot"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_management_getNetworkAccessDevice_01_get_by_id_success @basic_tier
  Scenario: Retrieve a Network Access Device by its id
    Given the path parameter "networkAccessDeviceId" is set to the id of a Network Access Device associated with the subscriber
    When the request "getNetworkAccessDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/NetworkAccessDevice"
    And the response property "$.id" equals the path parameter "networkAccessDeviceId"
