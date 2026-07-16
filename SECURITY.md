# Security Policy

## Supported versions

This project is an early reference implementation. Security fixes are applied to the latest code on the default branch; no production support or SLA is offered.

## Reporting a vulnerability

Do not open a public issue for a suspected vulnerability. Use the repository host's private security-advisory feature and provide a minimal reproduction using synthetic data. Do not include real API specifications, credentials, customer details, or private URLs.

Maintainers should acknowledge a report within seven calendar days when possible. Disclosure timing will be coordinated after triage and remediation.

## Operational warning

Phase 1 has no authentication, authorization, rate limiting, persistence, malware scanning, or full parser-level defenses. Run it only in a controlled development environment. Before any broader deployment, add gateway-enforced authentication, request-size limits, TLS, rate limits, secure configuration management, dependency scanning, and operational monitoring.

See [`docs/security-model.md`](docs/security-model.md) for threats and controls.
