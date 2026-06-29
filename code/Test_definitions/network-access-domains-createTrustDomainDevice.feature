  @basic_tier
Feature: CAMARA Network Access Domains API, vwip - Operation createTrustDomainDevice
  # Operation: POST /trust-domains/{trustDomainId}/devices
  # Required scope: network-access-domains:devices
  # Documented response codes: 201, 400, 401, 403, 404, 409, 500, 503
  #
  # Tagging:
  # - @network_access_domains_createTrustDomainDevice_NN_<slug>  unique scenario id
  # - @basic_tier  release-candidate gate (sunny-day + schema validation)
  # Full-tier (rainy-day) scenarios are tracked as a follow-up workstream
  # against the public-release readiness gate; see issue #52.

  Background: Common createTrustDomainDevice setup
    Given an environment at "apiRoot"
    And the resource "/network-access-domains/vwip/trust-domains/{trustDomainId}/devices"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the access token has the scope "network-access-domains:devices"
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/TrustDomainDeviceCreate"
    And the path parameter "trustDomainId" is set to the id of a Trust Domain created by the calling API client

  @network_access_domains_createTrustDomainDevice_01_iot_success
  Scenario: Register an IoT device with a hardware-address identifier
    Given the request body is set to the example "TrustDomainDeviceCreateIoT" of the schema "TrustDomainDeviceCreate"
    When the request "createTrustDomainDevice" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainDevice"
    And the response property "$.id" is a valid UUID
    And the response property "$.deviceName" is the same as the request body property "$.deviceName"

  @network_access_domains_createTrustDomainDevice_02_minimal_success
  Scenario: Register a device with the minimal valid payload
    Given the request body is set to the example "TrustDomainDeviceCreateMinimal" of the schema "TrustDomainDeviceCreate"
    When the request "createTrustDomainDevice" is sent
    Then the response status code is 201
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainDevice"

  @network_access_domains_createTrustDomainDevice_03_matter_success
  Scenario: Register a Matter device with bootstrappingInfo
    Given the request body is set to the example "TrustDomainDeviceCreateMatter" of the schema "TrustDomainDeviceCreate"
    When the request "createTrustDomainDevice" is sent
    Then the response status code is 201
    And the response body complies with the OAS schema at "/components/schemas/TrustDomainDevice"
    And the response property "$.bootstrappingInfo" is present and non-null
