# Ollama Provider Configuration

AI assistance is optional, disabled by default, and advisory. The deterministic rule engine runs first and remains authoritative for every request. Ollama is the Phase 2 local LLM provider.

## Properties

| Property | Default | Purpose |
|---|---|---|
| `ai.enabled` | `false` | Enables the Ollama call when `true` |
| `ai.host` | `localhost` | Ollama host, without scheme or path |
| `ai.port` | `11434` | Ollama HTTP port |
| `ai.model` | `gemma3` | Locally installed Ollama model |
| `ai.timeout` | `10000` | HTTP connection/response timeout in milliseconds |
| `ai.temperature` | `0.1` | Ollama generation temperature from 0 through 2 |
| `ai.maxSpecificationChars` | `50000` | Request and prompt character limit |
| `ai.maxFindings` | `20` | Maximum accepted AI findings |
| `ai.maxTextLength` | `2000` | Maximum accepted length for each AI text field |

The configuration-validation subflow rejects an empty host/model, a port outside 1–65535, a non-positive timeout, or a temperature outside 0–2. Configuration and provider failures always fail open to deterministic results.

## HTTP contract

The `Ollama_HTTP_Request_Config` uses `ai.host`, `ai.port`, and `ai.timeout`. The AI service sends `POST /api/chat` using the existing Mule HTTP Request connector. No AI-specific connector or API credential is required for a default local Ollama installation.

`build-ollama-chat-request.dwl` maps the provider-neutral request to:

- `model`
- system and user `messages`
- `stream: false`
- `format: json`
- `options.temperature`

`parse-ollama-chat-response.dwl` extracts `message.content` and parses it as JSON before the existing strict validation and normalization steps.

## Enabling Ollama

1. Install Ollama from its official distribution.
2. Run `ollama pull gemma3`, or install another model and update `ai.model`.
3. Ensure Ollama is listening on the configured host and port.
4. Set `ai.enabled=true`.
5. Start the Mule application.

For containerized Mule development, change `ai.host` to a host address reachable from the container. Do not expose an unauthenticated Ollama endpoint to an untrusted network.

## Testing without Ollama

MUnit mocks `http:request` and reads synthetic Ollama envelopes from `src/test/resources/ai`. Tests never call a real model. With `ai.enabled=false`, ordinary deterministic tests make no outbound request.
