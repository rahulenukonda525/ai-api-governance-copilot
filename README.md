# MuleSoft AI API Governance

MuleSoft AI API Governance Copilot is an open-source reference implementation for evaluating RAML 1.0 and OpenAPI specifications. Its deterministic governance rules remain authoritative. 

> **Disclaimer:** This is an independent reference implementation. It contains no proprietary employer or customer code, data, credentials, organization identifiers, or production URLs. All examples are synthetic. It is not production-ready.

## Capabilities

- `POST /api/v1/analyses` defined in RAML 1.0 and routed by APIkit
- RAML and OpenAPI text accepted in a JSON envelope
- Validation for body shape, non-empty specifications, and supported types
- Five deterministic rules covering title, version, HTTPS, descriptions, and standard errors
- Weighted design, security, documentation, and overall scores
- DataWeave-generated reports and consistent error bodies
- Correlation-ID logging that deliberately excludes specification content
- Optional provider-independent AI request/response model with a local Ollama HTTP adapter
- Structured AI response parsing, validation, normalization, and deterministic-result aggregation
- Prompt-injection safeguards, bounded inputs and outputs, and sanitized fail-open statuses
- MUnit coverage and GitHub Actions validation

## Prerequisites

- Java 17
- Maven 3.9.x
- Mule Enterprise Edition runtime 4.9.x, Anypoint Studio, or Anypoint Code Builder with Mule application support

The build uses only documented Mule artifact coordinates. Maven downloads the Mule Maven Plugin, HTTP Connector, APIkit module, and MUnit artifacts from MuleSoft's releases repository. Phase 2 reuses the existing HTTP Connector 1.11.3 and adds no connector dependency. DataWeave transformations use the Mule EE module, so developers and CI runners must have legitimate access to a compatible Mule Enterprise Edition 4.9 runtime and any license required by MuleSoft. Install it through Anypoint Studio/Code Builder or configure your organization's approved MuleSoft Maven mirror and Maven `settings.xml`. The checked-in GitHub Actions workflow intentionally contains no repository credentials; configure protected CI secrets and an approved settings file in your own repository if the EE runtime is not available anonymously.

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

## Optional AI assistance

AI is disabled by default. With `ai.enabled=false`, the response includes `aiAnalysis.status: DISABLED` and the application makes no Ollama call. AI findings never modify `overallScore`, `designScore`, `securityScore`, or `documentationScore`.

### Local Ollama setup

1. [Install Ollama](https://docs.ollama.com/quickstart) for your operating system.
2. Download the model configured by `ai.model`. The checked-in local example uses:

   ```bash
   ollama pull gemma3
   ```

3. Start Ollama if it is not already running:

   ```bash
   ollama serve
   ```

4. Confirm the local API is reachable:

   ```bash
   curl http://localhost:11434/api/tags
   ```

5. Review these properties in `src/main/resources/config/application.properties`:

   ```properties
   ai.enabled=true
   ai.host=localhost
   ai.port=11434
   ai.model=gemma3
   ai.timeout=10000
   ai.temperature=0.1
   ```

6. Start the Mule application and submit a normal governance request.

The AI service performs `POST /api/chat` against the configured host and port. It sends `stream: false` and `format: json`, then parses the JSON text in Ollama's `message.content`. The official request and response fields are documented in the [Ollama Chat API](https://docs.ollama.com/api/chat).

If Mule runs in a container, `localhost` refers to that container. Configure `ai.host` with an appropriate development-only host address such as `host.docker.internal`, subject to your platform and network policy. Keep Ollama bound to trusted interfaces and do not expose it publicly.

See [`docs/ai-provider-configuration.md`](docs/ai-provider-configuration.md) for the full property contract and [`docs/prompt-injection-threat-model.md`](docs/prompt-injection-threat-model.md) for safeguards and limitations.

## Scoring model

Each category score is the percentage of passing rules in that category. The overall score is rounded to the nearest integer using these fixed weights:

| Category | Weight | Phase 1 rules |
|---|---:|---|
| Design | 40% | title, API version |
| Security | 35% | HTTPS declaration |
| Documentation | 25% | descriptions, 400 and 500 responses |

The deterministic parser intentionally uses transparent text heuristics. It does not claim full semantic RAML/OpenAPI validation. AI output cannot correct or override that deterministic baseline.

## Project layout

```text
src/main/mule/                 API, validation, analysis, and error flows
src/main/resources/api/        RAML 1.0 contract
src/main/resources/dw/         Deterministic and AI DataWeave transformations
src/main/resources/config/     Non-secret local configuration
src/test/munit/                MUnit suites
src/test/resources/            Synthetic fixtures
docs/                          Architecture and security model
examples/                      Synthetic API calls and responses
.github/workflows/             CI validation and tests
mule-artifact.json             Mule runtime and Java compatibility descriptor
```

## Security and contributions

Read [`SECURITY.md`](SECURITY.md), [`CONTRIBUTING.md`](CONTRIBUTING.md), and [`docs/security-model.md`](docs/security-model.md) before contributing. Never submit real customer specifications, secrets, tokens, private endpoints, or proprietary policy content. Specifications are sent to the configured Ollama process when AI is enabled, so they must not contain secrets even when inference remains local.

## License

Copyright © 2026 Rahul Reddy Enukonda

Licensed under the Apache License, Version 2.0.
