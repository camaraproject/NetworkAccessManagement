Feature: CAMARA Network Access Domains API, vwip - Operation getServices
  # Operation: GET /services
  # Required scope: network-access-domains:services:read
  # Documented response codes: 200, 401, 403, 500, 503
  #
  # Tagging conventions:
  # - @network_access_domains_getServices_NN_<slug>  unique scenario id
  # - @basic_tier   release-candidate gate (sunny-day + schema validation)
  # - @full_tier    public-release gate (rainy-day matrix)
  # - @requires_oidc scenario depends on real OIDC enforcement at the API provider

  Background: Common getServices setup
    Given an environment at "apiRoot"
    And the resource "/network-access-domains/vwip/services"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-domains:services:read"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_domains_getServices_01_list_success @basic_tier
  Scenario: List all Services accessible to the authenticated identity
    When the request "getServices" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/ServiceList"
    And every Service entry in the response body complies with the schema at "/components/schemas/Service"

  @network_access_domains_getServices_401_01_no_authorization_header @full_tier @requires_oidc
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    When the request "getServices" is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
