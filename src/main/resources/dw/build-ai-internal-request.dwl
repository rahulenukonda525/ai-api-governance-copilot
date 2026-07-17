%dw 2.0
output application/java
---
{
    provider: "OLLAMA",
    model: Mule::p("ai.model"),
    specificationType: vars.specificationType,
    instructions: vars.aiPrompt.systemInstructions,
    untrustedInput: vars.aiPrompt.userContent,
    generation: {
        temperature: Mule::p("ai.temperature") as Number,
        responseFormat: "JSON_OBJECT"
    }
}
