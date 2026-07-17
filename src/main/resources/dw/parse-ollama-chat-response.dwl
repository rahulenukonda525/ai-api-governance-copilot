%dw 2.0
output application/java
var rawResponse = vars.aiProviderResult
var ollamaEnvelope =
    if (rawResponse is String or rawResponse is Binary)
        read(rawResponse as String, "application/json")
    else rawResponse
var structuredContent = ollamaEnvelope.message.content default null
---
if (structuredContent is String or structuredContent is Binary)
    read(structuredContent as String, "application/json")
else structuredContent
