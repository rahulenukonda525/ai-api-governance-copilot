%dw 2.0
output application/java
var errorType = vars.aiProviderErrorType default ""
---
if (errorType == "HTTP:TIMEOUT")
    {
        status: "TIMEOUT",
        summary: "AI-assisted review timed out; deterministic results are unaffected."
    }
else if (["APP:AI_INVALID_RESPONSE", "MULE:EXPRESSION", "MULE:TRANSFORMATION"] contains errorType)
    {
        status: "INVALID_RESPONSE",
        summary: "The AI provider response was rejected; deterministic results are unaffected."
    }
else
    {
        status: "FAILED",
        summary: "AI-assisted review is unavailable; deterministic results are unaffected."
    }
