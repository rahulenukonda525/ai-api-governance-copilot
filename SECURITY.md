# Security Policy

## Supported versions

This project is an early reference implementation. Security fixes are applied to the latest code on the default branch; no production support or SLA is offered.

## Reporting a vulnerability

Do not open a public issue for a suspected vulnerability. Use the repository host's private security-advisory feature and provide a minimal reproduction using synthetic data. Do not include real API specifications, credentials, customer details, or private URLs.

Maintainers should acknowledge a report within seven calendar days when possible. Disclosure timing will be coordinated after triage and remediation.

## Operational warning

This reference implementation has no inbound authentication, authorization, rate limiting, persistence, malware scanning, or full parser-level defenses. Run it only in a controlled development environment. AI is disabled by default. Enabling it sends specification content and deterministic findings to the configured Ollama process. Keep Ollama on trusted interfaces and never submit specifications containing secrets. Before any broader deployment, add gateway-enforced authentication, request-size limits, TLS, rate limits, secure configuration management, dependency scanning, and operational monitoring.

See [`docs/security-model.md`](docs/security-model.md) for threats and controls.
See [`docs/prompt-injection-threat-model.md`](docs/prompt-injection-threat-model.md) for AI-specific threats and residual risks.
