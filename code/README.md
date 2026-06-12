# Network Access Management API Definitions

This directory contains the OpenAPI specifications for the Network Access Management APIs — **Network Access Devices** and **Trust Domains** (see [issue #152](https://github.com/camaraproject/NetworkAccessManagement/issues/152); the `trust-domains` name is provisional pending naming feedback) — organized into modular components for better maintainability and reusability.

## Overview

The API definitions have been restructured from a monolithic approach to a modular, component-based architecture. This allows for better code reuse, easier maintenance, and cleaner separation of concerns.

## Folder Structure

The repository follows the layout defined in the [CAMARA Commonalities Consumption and Bundling Design](https://github.com/camaraproject/Commonalities/blob/main/documentation/Commonalities-Consumption-and-Bundling-Design.md): `common/` and `modules/` sit beside `API_definitions/` under `code/`, not inside it. This is what the central CAMARA release automation expects.

```
code/
├── README.md                                    # This file (authoring & process docs)
├── redocly.yaml                                 # Lint/bundle configuration (Redocly CLI)
├── API_definitions/
│   ├── network-access-devices.yaml              # Network Access Devices API — device info + reboot requests (committed on main)
│   └── trust-domains.yaml                        # Trust Domains API — segments, policy, device registration, services (committed on main)
├── common/
│   └── CAMARA_common.yaml                       # Local cached copy of the Commonalities shared error responses
└── modules/                                     # Modular domain-focused component files
    ├── NAM_Common.yaml                          # Shared primitives (UUID, DateTime, PropertyAddress, ResourceIdentifier, securitySchemes)
    ├── AccessDetail.yaml                        # Discriminated access detail variants (Wi-Fi, Thread)
    ├── Policy.yaml                              # Trust Domain policy schemas (maxDevices, bandwidth, egress)
    ├── NetworkAccessDevices/                    # Network Access Device resource schemas
    ├── RebootRequests/                          # Reboot Request lifecycle schemas
    ├── Services/                                # Service and ServiceSite schemas
    ├── TrustDomainDevices/                      # Trust Domain Device resource schemas
    └── TrustDomains/                            # Trust Domain & related capability schemas
```

## Architecture Rationale

### Why Multiple Files?

**Before:** Single monolithic OpenAPI file (`network-access-management.yaml`)
- ✅ Simple to understand initially
- ❌ Became very large (2000+ lines)
- ❌ Hard to maintain and review
- ❌ Schema duplication across different APIs
- ❌ Merge conflicts in collaborative development
- ❌ No reusability between different API specifications

**After:** Modular component-based structure
- ✅ Each file has a single, clear responsibility
- ✅ Reusable schemas can be shared across APIs
- ✅ Easier to review and maintain individual components
- ✅ Parallel development by different team members
- ✅ Clear separation of concerns
- ✅ Smaller, focused files

### Component Breakdown

| File | Purpose | Reusability |
|------|---------|-------------|
| `CAMARA_common.yaml` | CAMARA-wide error responses and shared schemas (cached from Commonalities) | High — required by every CAMARA API |
| `NAM_Common.yaml` | NAM-wide primitives (UUID, DateTime, PropertyAddress, ResourceIdentifier, securitySchemes) | High — used across all NAM endpoints |
| `Policy.yaml` | Trust Domain governance policies | Medium — Trust Domain specific |
| `AccessDetail.yaml` | Network access configurations | Medium — Network-related schemas |
| `TrustDomains.yaml` | Core Trust Domain schemas | Low — Trust Domain specific |

## Bundling and Validation

### Key Constraint: Bundled Files Are Not Committed on Main

Per the [CAMARA Consumption and Bundling Design](https://github.com/camaraproject/Commonalities/blob/main/documentation/Commonalities-Consumption-and-Bundling-Design.md), **bundled (standalone) API definitions are never committed on `main`**. The committed source specs (`network-access-devices.yaml` and `trust-domains.yaml`) retain their `$ref` references to `../common/` and `../modules/`. Bundled standalone OAS files are produced only on release branches/tags and for local validation.

This avoids merge conflicts in the large bundled output and keeps `main` as the single source of truth for modular schema authoring.

Bundled output files (`*-bundled.yaml`) are listed in `.gitignore`.

### Prerequisites

Install Redocly CLI:
```bash
npm install -g @redocly/cli
```

### Linting

Validate each spec and all referenced modules resolve correctly (Redocly CLI auto-discovers `redocly.yaml` in the current working directory, i.e. `code/`):
```bash
cd code
redocly lint API_definitions/network-access-devices.yaml
redocly lint API_definitions/trust-domains.yaml
```

### Local Bundling (for Validation or Tooling)

To produce fully resolved, standalone OAS files locally:
```bash
cd code
redocly bundle API_definitions/network-access-devices.yaml --output API_definitions/network-access-devices-bundled.yaml
redocly bundle API_definitions/trust-domains.yaml --output API_definitions/trust-domains-bundled.yaml
```

The bundled file is useful for:
- Importing into API tools (Swagger UI, Postman, etc.)
- Validating the fully resolved spec with external validators
- Generating SDKs or documentation locally

**Do not commit `*-bundled.yaml` files to `main`.** They are git-ignored.

### Bundling Configuration

The `redocly.yaml` file contains:
- **Linting rules** - Ensures consistency and quality
- **File resolution** - Allows `.yaml` and `.yml` extensions

Key bundling features:
- Resolves all `$ref` references to external files
- Validates schema compatibility
- Generates self-contained OpenAPI specifications
- Preserves examples and documentation

## File Purposes

### API Specifications

The repository defines **two** APIs (see [issue #152](https://github.com/camaraproject/NetworkAccessManagement/issues/152) — the `trust-domains` name is provisional pending naming feedback). Both are committed on `main` with `$ref` references into `../common/` and `../modules/`; bundling resolves these into standalone OAS files.

- **`API_definitions/network-access-devices.yaml`** - Network Access Devices API: retrieve operator-supplied devices (`/network-access-devices`) and create/monitor reboots (`/reboot-requests`). Uses the `NetworkAccessDevices` and `RebootRequests` modules plus the shared `ServiceSite`.
- **`API_definitions/trust-domains.yaml`** - Trust Domains API: manage Trust Domains (`/trust-domains`), register subscriber/IoT devices (`/trust-domains/{id}/devices`), and enumerate services (`/services`). Uses the `TrustDomains`, `TrustDomainCapabilities`, `TrustDomainDevices`, `Policy`, `AccessDetail`, and `Service` modules.

Modules referenced by **both** APIs (shared, authored once and bundled into each spec): `modules/NAM_Common.yaml`, `common/CAMARA_common.yaml`, and `modules/Services/ServiceSites.yaml` (`ServiceSite`).

### Component Files

- **`common/CAMARA_common.yaml`** - Shared CAMARA-style error responses and common schemas
- **`modules/NAM_Common.yaml`** - Shared fundamental types (UUID, DateTime, ResourceAudit, securitySchemes)
- **`modules/Policy.yaml`** - Trust Domain policy schemas (maxDevices, bandwidth limits, egress rules)
- **`modules/AccessDetail.yaml`** - Network access configuration schemas (Wi-Fi, Thread, security modes)
- **`modules/TrustDomains/TrustDomains.yaml`** - Core Trust Domain schemas and examples
- **`modules/TrustDomains/TrustDomainCapabilities.yaml`** - Trust Domain capability discovery schemas
- **`modules/TrustDomainDevices/TrustDomainDevices.yaml`** - Trust Domain Device resource schemas
- **`modules/NetworkAccessDevices/NetworkAccessDevices.yaml`** - Network Access Device resource schemas
- **`modules/RebootRequests/RebootRequests.yaml`** - Reboot Request lifecycle schemas
- **`modules/Services/Services.yaml`** - Service schemas
- **`modules/Services/ServiceSites.yaml`** - Service Site schemas

## Best Practices

### When to Create New Component Files
- **High reusability** - Schemas used by multiple APIs
- **Logical grouping** - Related schemas that form a cohesive unit
- **Size management** - When a file exceeds ~500 lines

### Schema Design Guidelines
- Use `$ref` for external schema references
- Keep examples close to their schemas
- Use YAML anchors for internal reuse within files
- Document inheritance and discriminator patterns clearly

### Example Cross-Reference Limitations

**Important:** While schemas can be easily shared across files using `$ref`, examples have significant limitations in the distributed component model:

#### The Problem
```yaml
# ❌ This does NOT work - cannot use $ref inside example values
TrustDomainExample:
  summary: Trust Domain with Wi-Fi access
  value:
    name: "My Network"
    accessDetails:
      - $ref: "../modules/AccessDetail.yaml#/components/examples/WiFiExample/value"  # Invalid!
```

#### The Solutions

**Option 1: Local Example Duplication (Recommended)**
```yaml
# ✅ Define examples locally where they're used
TrustDomainExample:
  summary: Trust Domain with Wi-Fi access
  value:
    name: "My Network"
    accessDetails:
      - accessType: "Wi-Fi"
        ssid: "my-network"
        securityMode:
          password: "my-password"
          securityModeType: "WPA2-Personal"
```

**Option 2: YAML Anchors (Within Same File Only)**
```yaml
# ✅ Use anchors for reuse within the same file
_wifi_example: &wifi-access
  accessType: "Wi-Fi"
  ssid: "my-network"
  securityMode:
    password: "my-password"
    securityModeType: "WPA2-Personal"

components:
  examples:
    TrustDomainExample:
      value:
        accessDetails:
          - *wifi-access  # Reuse within same file
```

**Option 3: Component-Level Example References**
```yaml
# ✅ Reference complete examples at component level (not within values)
WiFiAccessExample:
  $ref: "../modules/AccessDetail.yaml#/components/examples/WiFiAccessDetailWPA2Personal"

# But you still can't compose these inside other example values
```
