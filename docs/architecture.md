# Architecture

## Context

The application is a stateless Mule 4 Enterprise Edition service because report processing uses DataWeave transformations. A client submits RAML 1.0 or OpenAPI text and always receives the authoritative deterministic governance result. When explicitly enabled, a provider-independent AI pipeline appends a separate advisory review. There is no database or message broker.

## Request path

```text
HTTP Listener
    -> APIkit Router (RAML contract)
        -> Request Validation
            -> Specification Analysis
                -> Governance Rule Evaluation (DataWeave)
                -> Score Calculation (DataWeave)
                -> Deterministic Report Generation (DataWeave)
                -> Optional AI Orchestration
                    -> Prompt Construction
                    -> Provider-Neutral Request
                    -> Ollama HTTP Provider Adapter
                    -> Structured Parsing
                    -> Validation and Normalization
                    -> Fail-Open Status Mapping
                -> Deterministic + Advisory Aggregation
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
| AI orchestration | `ai-analysis.xml` | Enablement, prompt, internal model, provider adapter, parsing, validation, normalization, and fallback |
| Error handling | `error-handling.xml` | Status mapping, safe logging, consistent client/server errors |
| Governance logic | `dw/*.dwl` | Deterministic rules plus pure AI request/response transformations |

## Scoring

Design, security, and documentation scores are pass percentages. Overall scoring is `design × 0.40 + security × 0.35 + documentation × 0.25`, rounded to an integer. Rule failures become both violations and actionable recommendations.

AI cannot set or replace these scores. Aggregation starts with the completed deterministic report and adds only the `aiAnalysis` property.

## Provider abstraction

The internal request contains provider, model, specification type, system instructions, untrusted input, and generation controls. `build-ollama-chat-request.dwl` maps that model to Ollama's `/api/chat` contract. `parse-ollama-chat-response.dwl` extracts and parses `message.content`. A future provider should add its own mapper/parser while preserving the internal model and normalized `aiAnalysis` contract.

No new AI-specific connector is used. The existing HTTP Connector performs the outbound request using configurable `ai.host`, `ai.port`, and `ai.timeout` values.

## Design decisions and limitations

- APIkit keeps the implementation contract-first and handles routing/media-type failures.
- DataWeave keeps Phase 1 policy logic readable and free of custom Java dependencies.
- No specification body appears in application log messages.
- All processing is in memory and stateless.
- AI is disabled and makes no outbound provider call by default.
- Ollama failures are converted to advisory failure status objects and never fail the deterministic request.
- A dedicated configuration-validation subflow enforces a non-empty host/model, valid port, positive timeout, and bounded temperature before prompt construction.
- AI output is validated for shape, category, severity, confidence, count, and text length before aggregation.
- The evaluator uses deterministic text heuristics, not a complete RAML/OpenAPI parser. For example, the description rule detects a non-empty `description` key but does not yet prove that every operation has one.
- The local listener uses HTTP for developer convenience; production-like deployments must terminate or enforce HTTPS at the platform boundary.
- Prompt delimiters and instructions reduce prompt-injection risk but cannot eliminate it.

## Extension points

Future phases can introduce format-aware parsers, versioned rule profiles, richer evidence, provider-specific adapters, policy-based provider selection, privacy-preserving redaction, and human approval workflows. Deterministic results should remain the authoritative baseline.
