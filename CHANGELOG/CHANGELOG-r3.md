# Changelog NetworkAccessManagement

<!-- TOC:START -->
## Table of Contents
- [r3.1](#r31)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r3.1

## Release Notes

This release candidate contains the definition and documentation of
* network-access-devices 0.3.0-rc.1
* network-access-domains 0.3.0-rc.1

The API definition(s) are based on
* Commonalities 0.8.0
* Identity and Consent Management 0.5.0

## network-access-devices 0.3.0-rc.1

**network-access-devices 0.3.0-rc.1 is a release-candidate version of this API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/NetworkAccessManagement/r3.1/code/API_definitions/network-access-devices.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/NetworkAccessManagement/r3.1/code/API_definitions/network-access-devices.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/NetworkAccessManagement/blob/r3.1/code/API_definitions/network-access-devices.yaml)

### Breaking changes
* Carved out of the former `network-access-management` API (alpha, r2.1). Reboot Requests and Network Access Device enumeration are now provided by the **network-access-devices** API, with the reboot scope renamed to `network-access-devices:reboot` (#153).
* Conflict error handling changed to align with Commonalities (which deprecated the `409 CONFLICT` code): a client that handled `409 CONFLICT` must now handle `409 ALREADY_EXISTS` and `409 INCOMPATIBLE_STATE` (#166).

### Added

* Initial **network-access-devices** API surface (split from network-access-management):
    - **Reboot Requests** — CRUD operations for immediate or scheduled reboot of operator-supplied network access devices.
    - **Network Access Devices** — read-only enumeration of operator-supplied network access equipment (`GET /network-access-devices`, `GET /network-access-devices/{networkAccessDeviceId}`), including each device's reported `deviceStatus` (#56).
* `400` input-validation response on all read and delete operations (#149).
* `409 ALREADY_EXISTS` (duplicate reboot request) and `409 INCOMPATIBLE_STATE` (update of a reboot request in a conflicting state) error codes (#166).

### Changed

* Tightened schema constraints: integer `format` with min/max bounds and string `maxLength` (#150), and `maxItems` bounds on array fields (#156).
* Dependency on Commonalities updated to r4.3 (0.8.0) (#144, #145).

### Fixed

* N/A

### Removed

* `409 CONFLICT` error code — deprecated by Commonalities; replaced by `ALREADY_EXISTS` / `INCOMPATIBLE_STATE` (#166).

## network-access-domains 0.3.0-rc.1

**network-access-domains 0.3.0-rc.1 is a release-candidate version of this API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/NetworkAccessManagement/r3.1/code/API_definitions/network-access-domains.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/NetworkAccessManagement/r3.1/code/API_definitions/network-access-domains.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/NetworkAccessManagement/blob/r3.1/code/API_definitions/network-access-domains.yaml)

### Breaking changes

* Carved out of the former `network-access-management` API (alpha, r2.1). Trust Domains, Trust Domain Devices, and Services are now provided by the **network-access-domains** API, with scopes renamed to `network-access-domains:trust-domains`, `network-access-domains:trust-domains:read-all`, `network-access-domains:devices`, and `network-access-domains:services:read` (#153).
* Conflict error handling changed to align with Commonalities (which deprecated the `409 CONFLICT` code): a client that handled `409 CONFLICT` must now handle `409 ALREADY_EXISTS` (#166).

### Added

* Initial **network-access-domains** API surface (split from network-access-management):
    - **Trust Domains** — CRUD operations for declarative LAN-scoped network configurations, with policy-driven control over device admission, bandwidth, and egress. Capability discovery endpoint (`GET /trust-domains/capabilities`) exposes operator-supported configurations. Wi-Fi (WPA Personal/Enterprise) and Thread (Structured/TLV) access types supported.
    - **Trust Domain Devices** — CRUD operations for registering subscriber and IoT devices into Trust Domains with Zero-Touch Onboarding via DPP, Matter, and Well-Known SSID Onboarding (WKSO) bootstrapping protocols.
    - **Services** — read-only enumeration of subscriber service instances (`GET /services`, `GET /services/{serviceId}`).
* `400` input-validation response on all read and delete operations (#149).
* `409 ALREADY_EXISTS` error code (duplicate Trust Domain name or device registration) (#166).

### Changed

* Tightened schema constraints: integer `format` with min/max bounds and string `maxLength` (#150), and `maxItems` bounds on array fields (#156).
* Dependency on Commonalities updated to r4.3 (0.8.0) (#144, #145).

### Fixed

* N/A

### Removed

* `409 CONFLICT` error code — deprecated by Commonalities; replaced by `ALREADY_EXISTS` (#166).

**Full Changelog**: https://github.com/camaraproject/NetworkAccessManagement/commits/r3.1
