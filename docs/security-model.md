# Security Model

## Assets

- Submitted API specification text, which may contain sensitive design metadata
- Governance results and correlation identifiers
- Availability and integrity of the analysis endpoint
- Rule definitions and scoring behavior

## Trust boundaries

The HTTP listener is the primary untrusted boundary. APIkit and request validation run before analysis. The application makes no outbound calls and persists no request or result in Phase 1.

## Threats and Phase 1 controls

| Threat | Phase 1 control | Remaining work before broader use |
|---|---|---|
| Specification leakage through logs | Logs include correlation ID, type, file name, and outcome but not specification text | Redact untrusted file names and apply centralized log-retention controls |
| Malformed or unsupported input | RAML contract plus explicit type and empty-content validation | Add real parsers, nesting/complexity limits, and adversarial fixtures |
| Oversized request denial of service | None beyond infrastructure defaults | Enforce listener/gateway payload-size, timeout, concurrency, and rate limits |
| Unauthorized analysis | None in Phase 1 | Require gateway authentication and least-privilege authorization |
| Transport interception | HTTPS rule identifies insecure submitted designs | Enforce TLS for this service at the gateway/load balancer |
| Dependency compromise | Versions are explicit and CI is reproducible | Add dependency/SBOM scanning, signature policy, and scheduled updates |
| Error detail leakage | Centralized responses avoid stack traces and internal exception messages | Test all connector/runtime error paths |
| Persistent data exposure | No database or object store | Define retention, encryption, and deletion controls before persistence is added |

## Data handling

Specifications are held only in the Mule event for the duration of a request. Phase 1 deliberately has no persistence and no outbound integration. Use synthetic specifications for development and tests. Never place secrets in a specification submitted to an untrusted deployment.

## Correlation IDs

Mule's event correlation ID is returned as `X-Correlation-ID` and included in structured operational messages. Treat caller-supplied identifiers as untrusted metadata and constrain them at the edge in a hardened deployment.

## Deployment baseline for a future production design

Before production consideration, add TLS, authentication, authorization, payload limits, rate limiting, a web application firewall where appropriate, secrets management, hardened runtime configuration, vulnerability scanning, audit retention, monitoring/alerting, backup and recovery controls for any future persistence, and a formal threat-model review.
