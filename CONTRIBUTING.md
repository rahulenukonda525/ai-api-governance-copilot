# Contributing

Thank you for helping improve MuleSoft AI API Governance.

## Ground rules

- Use only synthetic data and public, independently authored examples.
- Do not submit employer, customer, or other third-party proprietary code or specifications.
- Never commit credentials, API keys, organization IDs, private hostnames, certificates, or production URLs.
- Keep governance rules deterministic, documented, and testable.
- Do not add AI services, databases, or deployment targets as part of Phase 1 maintenance.
- Do not describe the project as production-ready.

## Development workflow

1. Use Java 17 and a Mule 4.9-compatible development environment.
2. Create a focused branch and make the smallest coherent change.
3. Update tests, RAML, examples, and documentation when behavior changes.
4. Run `mvn validate` and `mvn test`.
5. Record user-visible changes under `Unreleased` in `CHANGELOG.md`.
6. Open a pull request describing behavior, test evidence, and security impact.

## Governance rules

New rules should have a stable ID, category, severity, pass condition, violation message, recommendation, and positive/negative tests. Explain heuristic limitations. Avoid rules that depend on nondeterministic network calls.

## Dependency changes

Use official MuleSoft artifact coordinates and keep versions in Maven properties. Link to official compatibility or release documentation in the pull request. Document any connector or runtime component that developers must install manually.

By contributing, you agree that your contributions are licensed under Apache License 2.0.
