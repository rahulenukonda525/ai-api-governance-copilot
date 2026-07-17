# Prompt-Injection Threat Model

## Security objective

An API specification is untrusted data. Text inside it must not change system instructions, retrieve configuration, disclose credentials, cause tool execution, or trigger automatic changes. AI output is advisory and must not alter deterministic scores.

## Safeguards

- The specification is placed between explicit `BEGIN_UNTRUSTED_API_SPECIFICATION` and `END_UNTRUSTED_API_SPECIFICATION` markers. Occurrences of those reserved marker strings inside submitted content are replaced before prompt construction.
- System instructions say to ignore commands in the specification, return JSON only, avoid exposing secrets, and avoid inventing endpoints.
- Only specification type, bounded specification text, and deterministic findings enter the prompt. Runtime configuration and credentials do not.
- Non-printing control characters, excluding normal tabs/newlines, are removed before prompt construction.
- The request is rejected above 50,000 characters.
- Output is rejected unless it meets allowed categories/severities, confidence range, maximum findings, required fields, and text-length limits.
- Provider errors are sanitized and do not expose raw responses or stack traces to clients.
- No AI-generated fix is applied automatically.
- Logs contain correlation IDs and safe status metadata, not prompts, provider bodies, or specification content.

## Known limitations

Delimiter neutralization and instructions cannot guarantee that a probabilistic model will ignore malicious content. Character limits are not token limits. Control-character removal does not detect every encoding, Unicode confusable, indirect injection, or data-exfiltration technique. Valid JSON can still contain incorrect or harmful advice. Provider infrastructure can retain or process prompts according to its own policy.

Therefore operators must use approved providers, apply data-classification and retention rules, avoid secrets in specifications, keep human review mandatory, and treat all AI content as untrusted advisory text.

## Abuse cases to test in later phases

- Specification descriptions asking the model to ignore system instructions
- Fake closing delimiters and nested JSON/system messages
- Very long Unicode and escaped control sequences
- Requests to reveal keys, configuration, or prior prompts
- JSON that is valid but contains unsupported or misleading values
- Many low-value findings intended to exhaust memory or downstream interfaces
- Provider responses containing markup, URLs, executable code, or sensitive echoes
