Feature: CAMARA Network Access Devices API, vwip - Operation getNetworkAccessDevices
  # Operation: GET /network-access-devices
  # Required scope: network-access-devices:reboot
  # Documented response codes: 200, 401, 403, 404, 500, 503
  #
  # Tagging conventions:
  # - @network_access_devices_getNetworkAccessDevices_NN_<slug>  unique scenario id
  # - @basic_tier   release-candidate gate (sunny-day + schema validation)
  # - @full_tier    public-release gate (rainy-day matrix)
  # - @requires_oidc scenario depends on real OIDC enforcement at the API provider

  Background: Common getNetworkAccessDevices setup
    Given an environment at "apiRoot"
    And the resource "/network-access-devices/vwip/network-access-devices"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-devices:reboot"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_devices_getNetworkAccessDevices_01_list_success @basic_tier
  Scenario: List Network Access Devices associated with the subscriber
    When the request "getNetworkAccessDevices" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/NetworkAccessDeviceList"
    And every NetworkAccessDevice entry in the response body complies with the schema at "/components/schemas/NetworkAccessDevice"

  @network_access_devices_getNetworkAccessDevices_401_01_no_authorization_header @full_tier @requires_oidc
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "getNetworkAccessDevices" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
