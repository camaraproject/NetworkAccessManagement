Feature: CAMARA Network Access Management API, vwip - Operation getTrustDomainCapabilities
  # Operation: GET /trust-domains/capabilities
  # Required scope: network-access-management:trust-domains
  # Documented response codes: 200, 401, 403, 500, 503
  #
  # Tagging conventions:
  # - @network_access_management_getTrustDomainCapabilities_NN_<slug>  unique scenario id
  # - @basic_tier   release-candidate gate (sunny-day + schema validation)
  # - @full_tier    public-release gate (rainy-day matrix)
  # - @requires_oidc scenario depends on real OIDC enforcement at the API provider

  Background: Common getTrustDomainCapabilities setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/trust-domains/capabilities"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:trust-domains"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_management_getTrustDomainCapabilities_01_get_capabilities_success @basic_tier
  Scenario: Retrieve the Trust Domain capabilities advertised by the API provider
    When the request "getTrustDomainCapabilities" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainCapabilities"

  @network_access_management_getTrustDomainCapabilities_401_01_no_authorization_header @full_tier @requires_oidc
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "getTrustDomainCapabilities" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
