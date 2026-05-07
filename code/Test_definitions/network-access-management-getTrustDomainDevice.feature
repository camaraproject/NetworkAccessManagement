Feature: CAMARA Network Access Management API, vwip - Operation getTrustDomainDevice
  # Operation: GET /trust-domains/{trustDomainId}/devices/{deviceId}
  # Required scope: network-access-management:devices
  # Documented response codes: 200, 401, 403, 404, 500, 503
  #
  # Tagging conventions:
  # - @network_access_management_getTrustDomainDevice_NN_<slug>  unique scenario id
  # - @basic_tier   release-candidate gate (sunny-day + schema validation)
  # - @full_tier    public-release gate (rainy-day matrix)
  # - @requires_oidc scenario depends on real OIDC enforcement at the API provider

  Background: Common getTrustDomainDevice setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/trust-domains/{trustDomainId}/devices/{deviceId}"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:devices"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    And the path parameter "deviceId" is set to the id of a device registered to that Trust Domain

  @network_access_management_getTrustDomainDevice_01_get_by_id_success @basic_tier
  Scenario: Retrieve a single device registered to a Trust Domain by its deviceId
    When the request "getTrustDomainDevice" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainDevice"
    And the response property "$.id" equals the path parameter "deviceId"

  @network_access_management_getTrustDomainDevice_401_01_no_authorization_header @full_tier @requires_oidc
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "getTrustDomainDevice" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
