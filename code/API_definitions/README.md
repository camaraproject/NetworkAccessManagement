# Network Access Management API Definitions

This directory contains the OpenAPI specifications for the Network Access Management API, organized into modular components for better maintainability and reusability.

## Overview

The API definitions have been restructured from a monolithic approach to a modular, component-based architecture. This allows for better code reuse, easier maintenance, and cleaner separation of concerns.

## Folder Structure

```
API_definitions/
├── README.md                                    # This file
├── redocly.yaml                                 # Bundling configuration
├── network-access-management.yaml               # The bundled API specification (generated)
├── Templates/                                   # Pre-bundled template specifications
│   ├── capabilities-template.yaml               # Network Access Device capabilities API template
│   └── network-access-management-template.yaml  # Complete Network Access Management API template
└── Domain/                                      # Reusable schema components
    ├── AccessDetail.yaml                        # Network access detail schemas (Wi-Fi, Thread)
    ├── Capabilities.yaml                        # Network Access Device capability schemas
    ├── Common.yaml                              # Shared schemas (UUID, DateTime, etc.)
    ├── Policy.yaml                              # Trust Domain policy schemas
    └── TrustDomains/
        └── TrustDomains.yaml                    # Trust Domain core schemas and examples
        └── TrustDomainCapabilities.yaml          # Trust Domain capabilities schemas
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
| `Common.yaml` | Base types (UUID, DateTime, ErrorInfo) | High - used across all APIs |
| `Policy.yaml` | Trust Domain governance policies | Medium - Trust Domain specific |
| `AccessDetail.yaml` | Network access configurations | Medium - Network-related APIs |
| `TrustDomains.yaml` | Core Trust Domain schemas | Low - Trust Domain specific |

## Bundling Process

### Prerequisites

Install Redocly CLI:
```bash
npm install -g @redocly/cli
```

### Creating Bundled Specifications

The `redocly.yaml` configuration file defines how to bundle the modular components into complete API specifications.

#### Bundle Network Access Management API
```bash
cd code/API_definitions
# Generate the complete Network Access Management API specification
redocly bundle Templates/network-access-management-template.yaml --output network-access-management-bundled.yaml

# Validate the bundled specification
redocly lint network-access-management-bundled.yaml
```

#### Overwrite Official OpenAPI Specification

Once you've created and validated a bundled specification, you can deploy it as the official API specification:

**Manual Deployment:**
```bash
# After bundling and validation, overwrite the official specification
cp network-access-management-bundled.yaml network-access-management.yaml

# Commit the updated official specification
git add network-access-management.yaml
git commit -m "Update official API specification from template"
```

**Automated Deployment:**
You can automate the bundling and deployment process using a script or CI/CD pipeline to ensure the official specification is always up-to-date with the latest templates.

### Bundling Configuration

The `redocly.yaml` file contains:
- **Linting rules** - Ensures consistency and quality
- **Bundling options** - Controls how references are resolved
- **Validation settings** - Catches errors early in development

Key bundling features:
- Resolves all `$ref` references to external files
- Validates schema compatibility
- Generates self-contained OpenAPI specifications
- Preserves examples and documentation

## File Purposes

### Source Template Files

- **`network-access-management-template.yaml`** - Main Network Access Management API template (source for bundling)

### Generated API Files

- **`network-access-management.yaml`** - Complete bundled Network Access Management API specification (generated from template)

### Template Files

- **`Templates/capabilities.yaml`** - Device capabilities API template
- **`Templates/network-access-management.yaml`** - Complete Network Access Management API template (alternative source)

### Component Files

- **`Domain/Common.yaml`** - Shared fundamental types (UUID, DateTime, Error schemas)
- **`Domain/Policy.yaml`** - Trust Domain policy schemas (maxDevices, bandwidth limits, egress rules)
- **`Domain/AccessDetail.yaml`** - Network access configuration schemas (Wi-Fi, Thread, security modes)
- **`Domain/TrustDomains/TrustDomains.yaml`** - Core Trust Domain schemas and examples

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
      - $ref: "../AccessDetail.yaml#/components/examples/WiFiExample/value"  # Invalid!
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
  $ref: "../AccessDetail.yaml#/components/examples/WiFiAccessDetailWPA2Personal"

# But you still can't compose these inside other example values
```
