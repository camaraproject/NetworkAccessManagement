  @basic_tier @network_access_management_getTrustDomainCapabilities_01_get_capabilities_success
Feature: CAMARA Network Access Management API, vwip - Operation getTrustDomainCapabilities
  # Operation: GET /trust-domains/capabilities
  # Required scope: network-access-management:trust-domains
  # Documented response codes: 200, 401, 403, 500, 503
  #
  # Tagging:
  # - @network_access_management_getTrustDomainCapabilities_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Scenario: Retrieve the Trust Domain capabilities advertised by the API provider
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/trust-domains/capabilities"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:trust-domains"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    When the request "getTrustDomainCapabilities" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainCapabilities"
