Feature: CAMARA Network Access Domains API, v0.3.0-rc.1 - Operation getTrustDomainDevices
  # Operation: GET /trust-domains/{trustDomainId}/devices
  # Required scope: network-access-domains:devices
  # Documented response codes: 200, 401, 403, 404, 500, 503
  #
  # Tagging conventions:
  # - @network_access_domains_getTrustDomainDevices_NN_<slug>  unique scenario id
  # - @basic_tier   release-candidate gate (sunny-day + schema validation)
  # - @full_tier    public-release gate (rainy-day matrix)
  # - @requires_oidc scenario depends on real OIDC enforcement at the API provider

  Background: Common getTrustDomainDevices setup
    Given an environment at "apiRoot"
    And the resource "/network-access-domains/v0.3rc1/trust-domains/{trustDomainId}/devices"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-domains:devices"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client

  @network_access_domains_getTrustDomainDevices_01_list_success @basic_tier
  Scenario: List devices registered to a Trust Domain owned by the calling API client
    Given the Trust Domain has at least one device registered
    When the request "getTrustDomainDevices" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainDeviceList"
    And every TrustDomainDevice entry in the response body complies with the schema at "/components/schemas/TrustDomainDevice"

  @network_access_domains_getTrustDomainDevices_401_01_no_authorization_header @full_tier @requires_oidc
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "getTrustDomainDevices" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
