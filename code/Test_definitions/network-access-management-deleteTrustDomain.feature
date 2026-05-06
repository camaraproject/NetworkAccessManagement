Feature: CAMARA Network Access Management API, vwip - Operation deleteTrustDomain
  # Operation: DELETE /trust-domains/{trustDomainId}
  # Required scope: network-access-management:trust-domains
  # Documented response codes: 204, 401, 403, 404, 500, 503
  #
  # Tagging:
  # - @network_access_management_deleteTrustDomain_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common deleteTrustDomain setup
    Given an environment at "apiRoot"
    And the resource "/network-access-management/vwip/trust-domains/{trustDomainId}"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-management:trust-domains"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

  @network_access_management_deleteTrustDomain_01_delete_success @basic_tier
  Scenario: Delete a Trust Domain owned by the calling API client
    Given the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    When the request "deleteTrustDomain" is sent
    Then the response status code is 204
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body is empty

  @network_access_management_deleteTrustDomain_02_state_coherence_after_delete @basic_tier
  Scenario: After successful deletion, GET on the same id returns 404 IDENTIFIER_NOT_FOUND
    Given the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client
    And the request "deleteTrustDomain" has been sent and returned 204
    When the request "getTrustDomain" is sent with the same trustDomainId
    Then the response status code is 404
    And the response property "$.code" is "NOT_FOUND"
