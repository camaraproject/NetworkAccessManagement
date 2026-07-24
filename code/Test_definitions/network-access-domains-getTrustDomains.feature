  @basic_tier
Feature: CAMARA Network Access Domains API, v0.3.0-rc.1 - Operation getTrustDomains
  # Operation: GET /trust-domains
  # Required scope: network-access-domains:trust-domains
  #     OR        : network-access-domains:trust-domains:read-all
  # Documented response codes: 200, 401, 403, 500, 503
  #
  # Tagging:
  # - @network_access_domains_getTrustDomains_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common getTrustDomains setup
    Given an environment at "apiRoot"
    And the resource "/network-access-domains/v0.3rc1/trust-domains"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_domains_getTrustDomains_01_caller_owned_success
  Scenario: List Trust Domains owned by the calling API client
    Given the access token has the scope "network-access-domains:trust-domains"
    And at least one Trust Domain exists for the calling API client
    When the request "getTrustDomains" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body is an array
    And every element of the response body complies with the schema at "/components/schemas/TrustDomain"
    And every element of the response body has a "createdBy" property identifying the calling API client

  @network_access_domains_getTrustDomains_02_read_all_success @backend_controlled
  Scenario: List all Trust Domains visible to the subscriber via the read-all scope
    Given the access token has the scope "network-access-domains:trust-domains:read-all"
    And at least one Trust Domain exists for the subscriber, created by another API client
    When the request "getTrustDomains" is sent
    Then the response status code is 200
    And the response body is an array
    And every element of the response body complies with the schema at "/components/schemas/TrustDomain"
