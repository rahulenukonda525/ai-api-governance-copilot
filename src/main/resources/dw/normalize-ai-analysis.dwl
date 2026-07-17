%dw 2.0
output application/java
var response = vars.aiParsedResponse
---
{
    enabled: true,
    status: "COMPLETED",
    provider: "OLLAMA",
    model: Mule::p("ai.model"),
    summary: trim(response.summary),
    confidence: response.confidence,
    findings: response.findings map ((finding) -> {
        category: upper(finding.category),
        severity: upper(finding.severity),
        title: trim(finding.title),
        description: trim(finding.description),
        recommendation: trim(finding.recommendation),
        location: trim(finding.location default "")
    }),
    recommendations: response.recommendations map ((recommendation) -> trim(recommendation)),
    advisoryDisclaimer: "AI-generated findings are advisory, may be incomplete or incorrect, and never replace the authoritative deterministic governance results or human review."
}
