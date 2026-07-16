%dw 2.0
output application/java
var text = vars.specificationText default ""
var normalizedText = lower(text)
var lines = (text replace "\r\n" with "\n") splitBy "\n"

fun hasNonEmptyKey(key: String) = do {
    var matchingLines = lines filter ((line) -> lower(trim(line)) startsWith (lower(key) ++ ":"))
    ---
    sizeOf(matchingLines filter ((line) -> sizeOf(trim(line)) > sizeOf(key) + 1)) > 0
}

fun hasResponse(code: String) =
    sizeOf(lines filter ((line) -> do {
        var value = trim(line)
        ---
        (value startsWith (code ++ ":")) or
        (value startsWith ("'" ++ code ++ "':")) or
        (value startsWith ('"' ++ code ++ '":'))
    })) > 0

var titlePresent = hasNonEmptyKey("title")
var versionPresent = hasNonEmptyKey("version")
var httpsDeclared =
    (normalizedText contains "https://") or
    (normalizedText contains "protocols: [ https") or
    (normalizedText contains "- https")
var descriptionsPresent = hasNonEmptyKey("description")
var standardErrorsPresent = hasResponse("400") and hasResponse("500")
---
[
    {
        ruleId: "DESIGN-001",
        category: "DESIGN",
        severity: "HIGH",
        passed: titlePresent,
        message: "API title is present.",
        violationMessage: "The API specification does not declare a title.",
        recommendation: "Add a concise title that identifies the API's business capability."
    },
    {
        ruleId: "DESIGN-002",
        category: "DESIGN",
        severity: "HIGH",
        passed: versionPresent,
        message: "API version is present.",
        violationMessage: "The API specification does not declare an API version.",
        recommendation: "Declare an explicit API version in RAML or in the OpenAPI info object."
    },
    {
        ruleId: "SECURITY-001",
        category: "SECURITY",
        severity: "HIGH",
        passed: httpsDeclared,
        message: "HTTPS transport is declared.",
        violationMessage: "HTTPS is not declared by the specification.",
        recommendation: "Declare an HTTPS base URI or server URL and enforce TLS at the gateway."
    },
    {
        ruleId: "DOC-001",
        category: "DOCUMENTATION",
        severity: "MEDIUM",
        passed: descriptionsPresent,
        message: "Endpoint descriptions are present.",
        violationMessage: "No endpoint description was detected.",
        recommendation: "Document each operation's intent, behavior, and important constraints."
    },
    {
        ruleId: "DOC-002",
        category: "DOCUMENTATION",
        severity: "MEDIUM",
        passed: standardErrorsPresent,
        message: "Standard error responses are documented.",
        violationMessage: "Both 400 and 500 error responses are not documented.",
        recommendation: "Document consistent 400 and 500 response bodies for every applicable operation."
    }
]
