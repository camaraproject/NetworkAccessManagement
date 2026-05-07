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
| Tier tag | `@basic_tier` (release-candidate gate) or `@full_tier` (public-release gate). Placement depends on file shape: (a) **multi-scenario, single tier** → both `@basic_tier` and the unique scenario-id tag at Feature level only, scenarios carry no tags of their own; (b) **multi-scenario, mixed tiers** (like the pilot) → tier tag on each individual scenario alongside its unique id; (c) **single-scenario** → both tags at Feature level only (do not duplicate at the Scenario — that fires `no-superfluous-tags`). The interacting `gherkin-lint` rules to keep in mind: `no-homogenous-tags`, `required-tags`, `no-superfluous-tags`, `indentation`. Run `gherkin-lint` locally before pushing — see "Executing the tests" below. |
| Auth-dependent tag | `@requires_oidc` — scenario requires real OIDC enforcement; skip when running against a facade in auth-disabled mode |
| Backend-dependent tag | `@backend_controlled` — scenario depends on backend state the facade alone cannot drive (e.g. 409 conflicts) |
| Setup steps | For files with **2+ scenarios**, factored into a `Background:` block (`apiRoot` + resource + `Authorization` with required scope + `x-correlator` schema check, plus `Content-Type` and a default-valid request body for write ops). For files with a **single scenario**, inlined directly into the scenario — `Background:` is disallowed by `gherkin-lint`'s `no-background-only-scenario`. |
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
**full tier** as the canonical exemplar. The other 19 operations are
authored at the **basic tier** only — happy-path scenarios sufficient for
the release-candidate gate. Their full-tier rainy-day matrices are tracked
as a follow-up workstream against the public-release readiness gate; see
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

`*` = full-tier exemplar; the remaining 19 are basic-tier only pending the
follow-up rainy-day matrices.

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

## Authoring guidance

When adding a new file:

1. Start from the pilot (`network-access-management-createTrustDomain.feature`)
   for the multi-scenario / mixed-tier shape, or from any of the GET-by-id
   files (e.g. `network-access-management-getService.feature`) for the
   single-scenario shape with inlined setup steps.
2. Decide where the tier tag goes based on the file's contents. Four
   interacting `gherkin-lint` rules apply: `no-homogenous-tags`,
   `required-tags`, `no-superfluous-tags`, and `indentation` (2-space
   indent for tags).
   - **Multi-scenario, all the same tier** → put `@basic_tier` (or
     `@full_tier`) on its own line above `Feature:` (2-space indent).
     Each scenario keeps just its unique id tag — that satisfies
     `required-tags`, no two scenarios share scenario-level tags so
     `no-homogenous-tags` is silent, and no tag is duplicated across
     levels so `no-superfluous-tags` is silent.
   - **Multi-scenario, mixed tiers** (like the pilot, where some
     scenarios are basic and others are full) → keep the tier tag on
     each individual scenario alongside its unique id.
   - **Single-scenario file** → put both `@basic_tier` and the unique
     scenario id at Feature level (combined on one line, 2-space
     indent). Do **not** repeat them above the Scenario — that fires
     `no-superfluous-tags`. Note: this configuration depends on the
     centralized CAMARA gherkin-lint config not enforcing
     `required-tags` strictly on Scenario lines that inherit Feature
     tags. **Always validate locally** with `gherkin-lint` before
     pushing to avoid the rule-interaction surprises this PR
     repeatedly hit (see "Executing the tests" for the recipe).
3. Decide whether to use a `Background:` block:
   - 2+ scenarios → factor common setup into a `Background:`.
   - Exactly 1 scenario → inline the setup steps directly into that
     scenario; `gherkin-lint`'s `no-background-only-scenario` rejects a
     `Background:` with only one consumer.
4. For request-body operations, adapt scenarios from
   [`syntax-errors-template.feature`](https://github.com/camaraproject/Commonalities/blob/main/artifacts/testing/syntax-errors-template.feature).
5. For full-tier expansion, confirm every documented error status in the
   OAS has at least one scenario.
6. Run the Gherkin syntax check before committing:
   `npx @cucumber/gherkin-utils format <file>`. The MegaLinter job in CI
   additionally runs `gherkin-lint`; the rules called out above
   (`no-homogenous-tags`, `no-background-only-scenario`) are the ones
   that have caught past PRs.
7. Tag scope-/auth-dependent scenarios with `@requires_oidc` so they are
   automatically skipped in environments without an OIDC server.
