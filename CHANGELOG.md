# Changelog NetworkAccessManagement

## Table of Contents

- **[r1.1](#r11)**

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r1.1

## Release Notes

This pre-release contains the definition and documentation of

- network-access-management v0.1.0-alpha.1

The API definition(s) are based on

- Commonalities r3.4
- Identity and Consent Management r3.3

## network-access-management v0.1.0-alpha.1

**network-access-management v0.1.0-alpha.1 is the first alpha release of this API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/NetworkAccessManagement/r1.1/code/API_definitions/network-access-management.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/NetworkAccessManagement/r1.1/code/API_definitions/network-access-management.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/NetworkAccessManagement/blob/r1.1/code/API_definitions/network-access-management.yaml)

### Added

- Initial API definition for managing network operator-supplied network access devices, focused on Trust Domain lifecycle management and Reboot Request management
- Trust Domain CRUD operations with support for multiple access types: Wi-Fi (WPA Personal, WPA Enterprise) and Thread (Structured, TLV)
- Trust Domain capabilities discovery endpoint for querying provider-supported configurations
- Configurable Trust Domain policies: device limits, bandwidth control (upstream/downstream), and egress allowed lists
- Trust Domain expiration support for ephemeral/time-bounded network configurations
- Reboot Request CRUD operations with immediate and scheduled execution modes
- Reboot Request device targeting: explicit (by device UUID) and inferred (default device)
- Service and Network Access Device read endpoints for subscriber resource enumeration
- Scope-based authorization model with resource isolation by API client identity
- Alignment with Commonalities r3.4 error response patterns and `CAMARA_common.yaml` schemas

### Changed

- N/A (first release)

### Fixed

- N/A (first release)

### Removed

- N/A (first release)