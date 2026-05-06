@basic_tier
Feature: CAMARA Network Access Management API, vwip - Operation getTrustDomain
  # Operation: GET /trust-domains/{trustDomainId}
  # Required scope: network-access-management:trust-domains
  #     OR        : network-access-management:trust-domains:read-all
  # Documented response codes: 200, 401, 403, 404, 500, 503
  #
  # Tagging:
  # - @network_access_management_getTrustDomain_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common getTrustDomain setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/trust-domains/{trustDomainId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_management_getTrustDomain_01_caller_owned_success
  Scenario: Retrieve a Trust Domain owned by the calling API client
    Given the access token has the scope "network-access-management:trust-domains"
    And the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    When the request "getTrustDomain" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.id" equals the path parameter "trustDomainId"

  @network_access_management_getTrustDomain_02_read_all_success
  Scenario: Retrieve a Trust Domain via the read-all scope
    Given the access token has the scope "network-access-management:trust-domains:read-all"
    And the path parameter "trustDomainId" is set to the id of a Trust Domain associated with the subscriber but created by a different API client
    When the request "getTrustDomain" is sent
    Then the response status code is 200
    And the response body complies with the OAS schema at "/components/schemas/TrustDomain"
    And the response property "$.id" equals the path parameter "trustDomainId"
