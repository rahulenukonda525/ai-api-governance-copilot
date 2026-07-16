# Architecture

## Context

Phase 1 is a stateless Mule 4 Enterprise Edition application because report processing uses DataWeave transformations. A client submits RAML 1.0 or OpenAPI text in a JSON envelope and receives a deterministic governance report. There is no AI provider, database, message broker, or external API call.

## Request path

```text
HTTP Listener
    -> APIkit Router (RAML contract)
        -> Request Validation
            -> Specification Analysis
                -> Governance Rule Evaluation (DataWeave)
                -> Score Calculation (DataWeave)
                -> Report Generation (DataWeave)
    -> JSON response

Any failure -> Central Error Handler -> Consistent JSON error
```

## Responsibilities

| Component | File | Responsibility |
|---|---|---|
| Runtime configuration | `global-config.xml` | HTTP listener, external properties, APIkit contract binding |
| API entry point | `api.xml` | Listener, safe request logging, APIkit routing, endpoint orchestration |
| Validation | `validation.xml` | Body, specification text, type, and normalized metadata |
| Analysis orchestration | `analysis.xml` | Separate rule, scoring, and report subflows |
| Error handling | `error-handling.xml` | Status mapping, safe logging, consistent client/server errors |
| Governance logic | `dw/*.dwl` | Pure deterministic rules, scoring, and response construction |

## Scoring

Design, security, and documentation scores are pass percentages. Overall scoring is `design × 0.40 + security × 0.35 + documentation × 0.25`, rounded to an integer. Rule failures become both violations and actionable recommendations.

## Design decisions and limitations

- APIkit keeps the implementation contract-first and handles routing/media-type failures.
- DataWeave keeps Phase 1 policy logic readable and free of custom Java dependencies.
- No specification body appears in application log messages.
- All processing is in memory and stateless.
- The evaluator uses deterministic text heuristics, not a complete RAML/OpenAPI parser. For example, the description rule detects a non-empty `description` key but does not yet prove that every operation has one.
- The local listener uses HTTP for developer convenience; production-like deployments must terminate or enforce HTTPS at the platform boundary.

## Extension points

Phase 2 can introduce format-aware parsers behind `governance-rule-evaluation-subflow`, versioned rule profiles, richer per-operation evidence, request-size enforcement, and optional AI recommendations behind an explicit adapter. Deterministic results should remain the authoritative baseline.
