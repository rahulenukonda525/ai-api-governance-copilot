# MuleSoft AI API Governance Copilot

MuleSoft AI API Governance Copilot is an open-source reference implementation for evaluating RAML 1.0 and OpenAPI specifications against deterministic API governance rules. Phase 1 exposes an APIkit-based Mule 4 endpoint and returns a structured, repeatable governance report. Despite the project name, **Phase 1 contains no AI integration**.

> **Disclaimer:** This is an independent reference implementation. It contains no proprietary employer or customer code, data, credentials, organization identifiers, or production URLs. All examples are synthetic. It is not production-ready.

## Phase 1 capabilities

- `POST /api/v1/analyses` defined in RAML 1.0 and routed by APIkit
- RAML and OpenAPI text accepted in a JSON envelope
- Validation for body shape, non-empty specifications, and supported types
- Five deterministic rules covering title, version, HTTPS, descriptions, and standard errors
- Weighted design, security, documentation, and overall scores
- DataWeave-generated reports and consistent error bodies
- Correlation-ID logging that deliberately excludes specification content
- MUnit coverage and GitHub Actions validation

## Prerequisites

- Java 17
- Maven 3.9.x
- Mule Enterprise Edition runtime 4.9.x, Anypoint Studio, or Anypoint Code Builder with Mule application support

The build uses only documented Mule artifact coordinates. Maven downloads the Mule Maven Plugin, HTTP Connector, APIkit module, and MUnit artifacts from MuleSoft's releases repository. DataWeave transformations use the Mule EE module, so developers and CI runners must have legitimate access to a compatible Mule Enterprise Edition 4.9 runtime and any license required by MuleSoft. Install it through Anypoint Studio/Code Builder or configure your organization's approved MuleSoft Maven mirror and Maven `settings.xml`. The checked-in GitHub Actions workflow intentionally contains no repository credentials; configure protected CI secrets and an approved settings file in your own repository if the EE runtime is not available anonymously. No other connector is required and no credentials should be added to this repository. Older Maven releases do not provide the resolver APIs required by the configured Mule Maven Plugin.

Versions are centralized in [`pom.xml`](pom.xml) properties.

## Build and test

```bash
mvn --batch-mode --no-transfer-progress validate
mvn --batch-mode --no-transfer-progress test
```

To run the application from a Mule-capable IDE, import it as an existing Maven/Mule project and run it with Java 17 and Mule 4.9.x. The local listener defaults to `0.0.0.0:8081`; these mock-development values are in `src/main/resources/config/application.properties`.

## API usage

The request envelope is:

```json
{
  "specificationType": "RAML",
  "specification": "#%RAML 1.0\ntitle: Orders API\nversion: v1",
  "fileName": "orders-api.raml"
}
```

Call the local endpoint with a synthetic example:

```bash
curl --request POST http://localhost:8081/api/v1/analyses \
  --header 'Content-Type: application/json' \
  --header 'X-Correlation-ID: local-demo-001' \
  --data @examples/raml-request.json
```

See [`examples/`](examples/) for RAML and OpenAPI requests plus success and error responses.

## Scoring model

Each category score is the percentage of passing rules in that category. The overall score is rounded to the nearest integer using these fixed weights:

| Category | Weight | Phase 1 rules |
|---|---:|---|
| Design | 40% | title, API version |
| Security | 35% | HTTPS declaration |
| Documentation | 25% | descriptions, 400 and 500 responses |

The Phase 1 parser intentionally uses transparent text heuristics. It does not claim full semantic RAML/OpenAPI validation. Parser-backed analysis is recommended for Phase 2.

## Project layout

```text
src/main/mule/                 API, validation, analysis, and error flows
src/main/resources/api/        RAML 1.0 contract
src/main/resources/dw/         Rule, score, report, and error DataWeave
src/main/resources/config/     Non-secret local configuration
src/test/munit/                MUnit suites
src/test/resources/            Synthetic fixtures
docs/                          Architecture and security model
examples/                      Synthetic API calls and responses
.github/workflows/             CI validation and tests
mule-artifact.json             Mule runtime and Java compatibility descriptor
```

## Security and contributions

Read [`SECURITY.md`](SECURITY.md), [`CONTRIBUTING.md`](CONTRIBUTING.md), and [`docs/security-model.md`](docs/security-model.md) before contributing. Never submit real customer specifications, secrets, tokens, private endpoints, or proprietary policy content.

## License

Licensed under the Apache License 2.0. See [`LICENSE`](LICENSE).
