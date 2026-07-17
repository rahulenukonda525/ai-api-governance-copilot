%dw 2.0
output application/java
---
{
    enabled: vars.aiStatus != "DISABLED",
    status: vars.aiStatus,
    provider: "OLLAMA",
    model: Mule::p("ai.model"),
    summary: vars.aiStatusSummary,
    confidence: 0,
    findings: [],
    recommendations: [],
    advisoryDisclaimer: "AI-generated findings are advisory, may be incomplete or incorrect, and never replace the authoritative deterministic governance results or human review."
}
