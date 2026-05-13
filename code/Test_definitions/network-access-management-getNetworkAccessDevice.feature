Feature: CAMARA Network Access Management API, v0.2.0-alpha.1 - Operation getNetworkAccessDevice
  # Operation: GET /network-access-devices/{networkAccessDeviceId}
  # Required scope: network-access-management:reboot
  # Documented response codes: 200, 401, 403, 404, 500, 503
  #
  # Tagging conventions:
  # - @network_access_management_getNetworkAccessDevice_NN_<slug>  unique scenario id
  # - @basic_tier   release-candidate gate (sunny-day + schema validation)
  # - @full_tier    public-release gate (rainy-day matrix)
  # - @requires_oidc scenario depends on real OIDC enforcement at the API provider

  Background: Common getNetworkAccessDevice setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/v0.2alpha1/network-access-devices/{networkAccessDeviceId}"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:reboot"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "networkAccessDeviceId" is set to the id of a Network Access Device associated with the subscriber

  @network_access_management_getNetworkAccessDevice_01_get_by_id_success @basic_tier
  Scenario: Retrieve a Network Access Device by its id
    When the request "getNetworkAccessDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/NetworkAccessDevice"
    And the response property "$.id" equals the path parameter "networkAccessDeviceId"

  @network_access_management_getNetworkAccessDevice_401_01_no_authorization_header @full_tier @requires_oidc
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "getNetworkAccessDevice" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
