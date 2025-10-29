# CAMARA User Story Guidance

This document summarizes how to create or modify CAMARA-aligned User Stories using the **Commonalities User Story Template** and how to determine the correct **Scope** value based on the **TM Forum NaaS (TMF 909A)** lifecycle definitions.

---

## 1. Authoritative Sources

Any information in this guide is derived from the following authoritative sources:

| Source | Description | Link |
|--------|--------------|------|
| **CAMARA Commonalities – User Story Template** | Canonical template defining fields, structure, and allowed values (Roles, Scope, etc.). | [github.com/camaraproject/Commonalities/documentation/Userstory-template.md](https://github.com/camaraproject/Commonalities/blob/main/documentation/Userstory-template.md) |
| **CAMARA Commonalities – Guidelines** | Explains how Commonalities artifacts (User Stories, API Guidelines, etc.) are structured. | [camaraproject.org/commonalities](https://camaraproject.org/commonalities/) |
| **TM Forum TMF 909A – NaaS API Component Suite Profile v1.5** | Defines the lifecycle areas used for the “Scope” field. | [TM Forum TMF 909A – NaaS API Component Suite Profile](https://engage.tmforum.org/HigherLogic/System/DownloadDocumentFile.ashx?DocumentFileKey=70781cfc-1ebb-4ef9-b728-44b34e9c14a1) |
| **TM Forum Open APIs** | APIs referenced for each lifecycle area (TMF 633, 640, 645, 653, 656, 677). | [tmforum.org/open-apis](https://www.tmforum.org/open-apis/) |

Start with the [CAMARA Commonalities – User Story Template](https://github.com/camaraproject/Commonalities/blob/main/documentation/Userstory-template.md) for a comprehensive understanding of user story structure and requirements. From there, you will note a `ReferenceArchitecture` powerpoint is mentioned; this includes slides that summarize the alignment with TM Forum lifecycles, which is further detailed in Section 3 of this document.

---

## 2. User Story Template Overview

Each CAMARA User Story should include:

| Field | Description | Guidance |
|-------|--------------|-----------|
| **Title / Summary** | “As a \<role\>, I want \<goal\> so that \<outcome\>.” | User-centric phrasing. |
| **Roles** | Acceptable values: `customer:user`, `customer:administrator`, `customer:business manager` (from Commonalities template). | Choose based on the actor’s function and access level. |
| **Actor(s)** | Entity or system executing or triggering the story (e.g., API Client, Operator BSS, Service Owner). | Prefer roles over specific implementations. |
| **Scope** | Lifecycle area(s) impacted. See Section 3 below. | Select **one or more** of: Design time, P2O, O2A, U2C, T2R. |
| **Pre-conditions / Begins when** | Required system or business state before the story starts. | Often references catalog or active service. |
| **Steps** | Numbered flow of actions. | Keep technology-neutral. |
| **Post-conditions / Ends when** | Expected outcome or state. | Clarify data, service, or operational result. |
| **Exceptions** | Deviations or failure modes. | Include both business and technical exceptions if relevant. |

---

## 3. Scope Reference (Lifecycle Areas)

The **Scope** field classifies a user story according to the TM Forum NaaS (TMF 909A) lifecycle model.
Use this section to determine where a story fits.

| Scope | TM Forum Reference | Summary | Typical APIs / Activities |
|--------|--------------------|----------|----------------------------|
| **Design Time** | TMF 909A § 2.1.5 (Service Catalog) | “Concept-to-Market” activities defining new service specifications. Used for retrieving, creating, or updating service specs prior to runtime. | TMF 633 Service Catalog Management |
| **Prospect to Order (P2O)** | TMF 909A § 2.1.2 | Evaluate what products or services can be offered to a customer. Includes availability checks, feasibility analysis, and resource reservation. | TMF 645 Service Qualification |
| **Order to Activate (O2A)** | TMF 909A § 2.1.1 | Fulfil and activate ordered services, including in-flight modification, suspension, or removal. Covers the operational lifecycle of a service instance. | TMF 640 Activation & Configuration |
| **Usage to Cash (U2C)** | TMF 909A § 2.1.4 | Measure and report service usage for billing or quota management. Includes retrieval, periodic reporting, and threshold notifications. | TMF 677 Usage Consumption |
| **Trouble to Resolution (T2R)** | TMF 909A § 2.1.3 | Monitor, diagnose, and restore services when faults occur. Includes testing, problem creation, updates, and closure. | TMF 656 Service Problem Mgmt, TMF 653 Service Test |

> **Tip:**
> - If the story involves designing or publishing a service → **Design Time**
> - If it checks availability or feasibility before order → **P2O**
> - If it provisions or modifies active services → **O2A**
> - If it deals with usage or quotas → **U2C**
> - If it handles incidents or assurance → **T2R**
