# Network Access Management — Test Definitions

This directory contains Gherkin (`.feature`) test definitions for the
Network Access Management API. The files describe the behavioral contract
of each operation: happy paths, schema validation, and the documented
error cases. They are runner-agnostic by design — see "Executing the tests"
below.

These tests are produced and graded against the
[CAMARA API Testing Guidelines](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-Testing-Guidelines.md)
and the reusable templates in
[`Commonalities/artifacts/testing/`](https://github.com/camaraproject/Commonalities/tree/main/artifacts/testing)
(`syntax-errors-template.feature`, `C01-device-errors.feature`, etc.).

## Conventions

| Convention | Value |
|---|---|
| Filename | `network-access-management-{operationId}.feature` (one file per `operationId`) |
| Scenario tag | `@network_access_management_{operationId}_{NN}_{slug}` |
| Tier tag | `@basic_tier` (release-candidate gate) or `@full_tier` (public-release gate). Placement: (a) **multi-scenario, single tier** → at Feature level (above `Feature:`, 2-space indent), with each scenario carrying just its unique id tag; (b) **multi-scenario, mixed tiers** (the pilot and every Group B file in this repo, which mix one `@basic_tier` happy path with one `@full_tier @requires_oidc` 401 scenario) → tier tag on each individual scenario alongside its unique id; no Feature-level tier tag. The four interacting `gherkin-lint` rules: `no-homogenous-tags` (scenarios may not all share a tag at scenario level), `required-tags` (every Scenario must have ≥1 tag), `no-superfluous-tags` (no tag duplicated across Feature and Scenario), `indentation` (2-space indent for tags). |
| Auth-dependent tag | `@requires_oidc` — scenario requires real OIDC enforcement; auto-skip when running against a facade in auth-disabled mode |
| Backend-dependent tag | `@backend_controlled` — scenario depends on backend state the facade alone cannot drive (e.g. 409 conflicts) |
| Setup steps | Always factored into a `Background:` block (`apiRoot` + resource + `Authorization` with required scope + `x-correlator` schema check, plus `Content-Type` and a default-valid request body for write ops, plus any path parameters shared across all scenarios). Every file in this directory has at least 2 scenarios — single-scenario files cannot satisfy the lint rule trio above, which is why Group B GETs each carry a 401 `@requires_oidc` scenario alongside the happy path. |
| Schema references | JSON Pointer into the **bundled** OAS (e.g. `/components/schemas/TrustDomain`), not into `modules/...` |
| Error-code coverage | One named `Scenario:` per documented response code; `Scenario Outline:` for parameter-varied cases (e.g. each missing-required-field permutation) |

## Coverage tiers

Per the CAMARA API Testing Guidelines:

- **Basic test plan** (mandatory at release-candidate): sunny-day scenarios
  for every operation plus mandatory request/response schema validation.
- **Full test plan** (mandatory at initial public release): basic, plus one
  scenario per documented error status, auth edge cases, semantic
  validation, optional-field combinations, and CRUD state coherence
  (GET-after-POST agreement).

`network-access-management-createTrustDomain.feature` is authored at the
**full tier** as the canonical exemplar — happy paths plus the full
400/401/403/409 error matrix.

The other 19 operations are authored at **basic tier** for sunny-day
coverage. The 9 single-resource GETs additionally include a `401`
unauthenticated scenario (tagged `@full_tier @requires_oidc`) — added to
satisfy the `gherkin-lint` rule trio that rejects single-scenario files,
and serves as the seed for further full-tier expansion. Group A
multi-scenario files (Trust Domain CRUD, Trust Domain Device CRUD,
Reboot Request CRUD) remain basic-tier-only for now; their full-tier
rainy-day matrices are tracked as a follow-up workstream against the
public-release readiness gate; see
[issue #52](https://github.com/camaraproject/NetworkAccessManagement/issues/52).

## File inventory

One `.feature` file per operationId, 20 files total, all committed.

| Tag group | Operations |
|---|---|
| Services | `getServices`, `getService` |
| Trust Domains | `getTrustDomainCapabilities`, `createTrustDomain`*, `getTrustDomains`, `getTrustDomain`, `updateTrustDomain`, `deleteTrustDomain` |
| Trust Domain Devices | `createTrustDomainDevice`, `getTrustDomainDevices`, `getTrustDomainDevice`, `updateTrustDomainDevice`, `deleteTrustDomainDevice` |
| Network Access Devices | `getNetworkAccessDevices`, `getNetworkAccessDevice` |
| Reboot Requests | `createRebootRequest`, `getRebootRequests`, `getRebootRequest`, `updateRebootRequest`, `deleteRebootRequest` |

`*` = full-tier exemplar (full 4xx error matrix). The remaining 19 are
basic-tier with a 401 `@requires_oidc` scenario added in each Group B
GET file (see Coverage tiers above).

## Executing the tests

CAMARA does not standardize a test runner. The step phrases used in these
files are runner-agnostic — they reference the OAS by `operationId` and
JSON Pointer rather than by literal HTTP details — so a runner needs to:

1. Load the **bundled** OAS (`redocly bundle network-access-management.yaml
   --output network-access-management-bundled.yaml` from
   `code/API_definitions/`) and index `operationId → (method, path, schemas)`.
2. Set `apiRoot` from the target environment.
3. Acquire a token compatible with the scope listed in each operation's
   `security: openId: [...]` block. The test runner is expected to support
   running against an OIDC server (Keycloak, `navikt/mock-oauth2-server`,
   etc.) or a facade dev mode that bypasses token validation.
4. Echo `x-correlator` per request and assert strict equality on response.
5. Validate response bodies against the schema reference cited in the
   `Then ... complies with the OAS schema at ...` step.

Examples of compatible runner stacks: Behave + `requests` + `openapi-core`
(Python), Cucumber-JS + Apickli, Karate. The runner harness is **not**
committed to this repository — it is environment-specific and lives in
the consuming organization's test infrastructure.

## Local lint (run CI's `gherkin-lint` before you push)

CAMARA's centralized lint is what trips PRs to this repo. Reproduce its
gherkin-lint check locally with the exact rule config the CI uses:

```bash
# from anywhere
curl -sSL https://raw.githubusercontent.com/camaraproject/tooling/v0/linting/config/.gherkin-lintrc \
  -o /tmp/camara.gherkin-lintrc
npx --yes gherkin-lint -c /tmp/camara.gherkin-lintrc code/Test_definitions/
```

Exit 0 means the gherkin step in CI will pass. The rules most likely to
catch new authoring mistakes (and the order they typically fire in):
`indentation` (tags need 2-space indent), `no-homogenous-tags` (don't
repeat the same tag on every Scenario), `required-tags` (every Scenario
needs ≥1 tag matching `^@.*$`), `no-superfluous-tags` (don't put the
same tag at Feature *and* Scenario level), `no-background-only-scenario`
(no `Background:` in a file that only has one Scenario).

For the broader MegaLinter pipeline (Spectral on the OAS, yamllint, etc.)
use `npx mega-linter-runner` — that pulls the same Docker image CI runs.

## Authoring guidance

When adding a new file:

1. Start from any existing file as a template:
   - Full-tier: [`network-access-management-createTrustDomain.feature`](network-access-management-createTrustDomain.feature)
     for write operations with the full error matrix.
   - Basic-tier multi-scenario CRUD: any of the Trust Domain or Reboot
     Request CRUD files for the standard Background + multiple-scenario
     shape with each scenario carrying just its unique id tag.
   - GET endpoint with a 401 escape hatch: any of the Group B files (e.g.
     [`network-access-management-getService.feature`](network-access-management-getService.feature))
     for the happy-path + 401 `@requires_oidc` pattern.
2. **Every file must have ≥2 Scenarios.** Single-scenario files cannot
   satisfy the `gherkin-lint` rule trio (`no-homogenous-tags`,
   `required-tags`, `no-superfluous-tags`) — every tag arrangement
   triggers at least one rule. If the operation truly has only one
   sunny-day case, add a 401 `@requires_oidc` scenario as the second
   scenario; that's what every Group B GET file does.
3. Decide where the tier tag goes:
   - **All scenarios at the same tier** → put `@basic_tier` (or
     `@full_tier`) on its own line above `Feature:` (2-space indent).
     Each scenario carries just its unique id tag.
   - **Mixed tiers** (e.g. one basic-tier happy path plus a full-tier
     `@requires_oidc` scenario, like every Group B file) → keep the tier
     tag on each individual scenario alongside its unique id; no
     Feature-level tier tag.
4. Factor common setup into a `Background:` block: `apiRoot`, resource
   path, `Content-Type` (write ops only), `Authorization` plus the
   required scope, `x-correlator` schema check, the default-valid
   request body (write ops), and any path parameters shared across
   scenarios.
5. For request-body operations, adapt scenarios from
   [`syntax-errors-template.feature`](https://github.com/camaraproject/Commonalities/blob/main/artifacts/testing/syntax-errors-template.feature).
6. For full-tier expansion, confirm every documented error status in the
   OAS has at least one scenario.
7. **Validate locally** with the recipe in "Local lint" above. Exit 0
   means CI's gherkin step will pass. Do this every time before
   committing — every CI lint failure on this PR was something
   catchable in five seconds locally.
8. Tag scope-/auth-dependent scenarios with `@requires_oidc` so they are
   automatically skipped in environments without an OIDC server.
