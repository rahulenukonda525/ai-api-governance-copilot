# Security Model

## Assets

- Submitted API specification text, which may contain sensitive design metadata
- Governance results and correlation identifiers
- Availability and integrity of the analysis endpoint
- Rule definitions and scoring behavior
- Ollama prompt content and advisory output

## Trust boundaries

The HTTP listener is the primary untrusted boundary. APIkit and request validation run before analysis. When AI is enabled, the local Ollama process is a second trust boundary: submitted specification content and deterministic findings leave the Mule process, even if they remain on the same host. The application persists no request or result.

## Threats and controls

| Threat | Phase 1 control | Remaining work before broader use |
|---|---|---|
| Specification leakage through logs | Logs include correlation ID, type, provider, model, duration, count, and outcome but not specification text, prompts, or file names | Apply centralized log-retention controls |
| Malformed or unsupported input | RAML contract plus explicit type and empty-content validation | Add real parsers, nesting/complexity limits, and adversarial fixtures |
| Oversized request denial of service | Contract and flow enforce a 50,000-character specification limit | Also enforce byte-size, timeout, concurrency, and rate limits at the gateway |
| Unauthorized analysis | None in Phase 1 | Require gateway authentication and least-privilege authorization |
| Transport interception | HTTPS rule identifies insecure submitted designs | Enforce TLS for this service at the gateway/load balancer |
| Dependency compromise | Versions are explicit and CI is reproducible | Add dependency/SBOM scanning, signature policy, and scheduled updates |
| Error detail leakage | Centralized responses avoid stack traces and internal exception messages | Test all connector/runtime error paths |
| Persistent data exposure | No database or object store | Define retention, encryption, and deletion controls before persistence is added |
| Prompt injection in specification | Specification is labeled and delimited as untrusted; system instructions prohibit following embedded commands | Provider behavior is probabilistic; require human review and never auto-apply output |
| Malformed or adversarial AI output | JSON parsing plus category, severity, confidence, finding-count, and text-length validation | Add a formal JSON Schema validator and adversarial provider corpus |
| Ollama network exposure | Host and port are configurable; default is local development only | Bind Ollama to trusted interfaces and enforce host firewall/network policy |
| Ollama outage or timeout | Fail-open statuses preserve deterministic results and sanitize errors | Add circuit breaking, telemetry, and a bounded retry policy |
| Model/runtime data handling | AI disabled by default; no prompt is persisted by this application | Review the selected model, Ollama runtime, host access, and operational data policy |

## Data handling

Specifications are held only in the Mule event for the duration of a request. There is no persistence. When AI is enabled, the sanitized specification and deterministic findings are transmitted to the configured Ollama process. Use synthetic specifications for development and tests. Never place secrets in a specification, even for local inference.

## Correlation IDs

Mule's event correlation ID is returned as `X-Correlation-ID` and included in structured operational messages. Treat caller-supplied identifiers as untrusted metadata and constrain them at the edge in a hardened deployment.

## Deployment baseline for a future production design

Before production consideration, add TLS, authentication, authorization, payload limits, rate limiting, a web application firewall where appropriate, secrets management, hardened runtime configuration, vulnerability scanning, audit retention, monitoring/alerting, backup and recovery controls for any future persistence, and a formal threat-model review.
