# Changelog

All notable changes are documented here. This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and intends to use [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- Optional, fail-open AI-assisted governance review behind a provider-neutral internal model.
- Local Ollama `/api/chat` adapter using the existing Mule HTTP Connector with configurable host, port, model, timeout, and temperature.
- Safe AI operational logging for provider, model, execution time, finding count, and correlation ID.
- Prompt construction, control-character sanitization, structured parsing, strict response validation, normalization, and advisory aggregation subflows.
- AI statuses for completed, disabled, failed, invalid, and timed-out reviews.
- Mocked AI test fixtures and tests for provider/error/validation/fallback behavior.
- AI provider configuration and prompt-injection threat-model documentation.

- Initial Mule 4.9 and Java 17 Maven project foundation.
- RAML 1.0 contract and APIkit route for `POST /api/v1/analyses`.
- Deterministic validation, five governance rules, weighted scoring, and report generation.
- Centralized errors and safe correlation-ID logging.
- MUnit scenarios, GitHub Actions CI, synthetic examples, and project documentation.
