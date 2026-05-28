# Changelog NetworkAccessManagement

<!-- TOC:START -->
## Table of Contents
- [r2.1](#r21)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r2.1

## Release Notes

This pre-release contains the definition and documentation of
* network-access-management 0.2.0-alpha.1

The API definition(s) are based on
* Commonalities 0.8.0-rc.2
* Identity and Consent Management 0.5.0

## network-access-management 0.2.0-alpha.1

**network-access-management 0.2.0-alpha.1 is** the first consumable alpha of this API, providing Trust Domain management, Zero-Touch Onboarding for subscriber devices, and reboot-request operations on operator-supplied network access devices.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/NetworkAccessManagement/r2.1/code/API_definitions/network-access-management.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/NetworkAccessManagement/r2.1/code/API_definitions/network-access-management.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/NetworkAccessManagement/blob/r2.1/code/API_definitions/network-access-management.yaml)

### Added

* Initial Network Access Management API surface:
    - **Trust Domains** — CRUD operations for declarative LAN-scoped network configurations, with policy-driven control over device admission, bandwidth, and egress. Capability discovery endpoint (`GET /trust-domains/capabilities`) exposes operator-supported configurations. Wi-Fi (WPA Personal/Enterprise) and Thread (Structured/TLV) access types supported.
    - **Trust Domain Devices** — CRUD operations for registering subscriber and IoT devices into Trust Domains with Zero-Touch Onboarding via DPP, Matter, and Well-Known SSID Onboarding (WKSO) bootstrapping protocols (#118, #122).
    - **Reboot Requests** — CRUD operations for immediate or scheduled reboot of operator-supplied network access devices.
    - **Services** — read-only enumeration of subscriber service instances (`GET /services`, `GET /services/{serviceId}`).
    - **Network Access Devices** — read-only enumeration of operator-supplied network access equipment (`GET /network-access-devices`, `GET /network-access-devices/{networkAccessDeviceId}`).
* Basic-tier Gherkin test definitions covering sunny-day scenarios for every operation (#120).

### Changed

* Dependency on Commonalities updated to r4.2 (0.8.0-rc.2); ICM dependency updated to r4.2 (#126, #131).

### Fixed

_none_

### Removed

_none_

**Full Changelog**: https://github.com/camaraproject/NetworkAccessManagement/commits/r2.1

