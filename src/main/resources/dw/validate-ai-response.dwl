%dw 2.0
output application/java
var response = vars.aiParsedResponse
var allowedCategories = ["DESIGN", "SECURITY", "DOCUMENTATION", "MAINTAINABILITY", "CONSISTENCY", "ERROR_HANDLING"]
var allowedSeverities = ["CRITICAL", "HIGH", "MEDIUM", "LOW", "INFO"]
var maxFindings = Mule::p("ai.maxFindings") as Number
var maxTextLength = Mule::p("ai.maxTextLength") as Number
var findings = if (response is Object) response.findings default [] else []
var recommendations = if (response is Object) response.recommendations default [] else []

fun validText(value) = value is String and !isEmpty(trim(value)) and sizeOf(value) <= maxTextLength
fun findingErrors(finding, index) =
    if (!(finding is Object))
        ["finding[" ++ index ++ "].notObject"]
    else
        (if (!(finding.category is String) or !(allowedCategories contains upper(finding.category default ""))) ["finding[" ++ index ++ "].category"] else []) ++
        (if (!(finding.severity is String) or !(allowedSeverities contains upper(finding.severity default ""))) ["finding[" ++ index ++ "].severity"] else []) ++
        (if (!validText(finding.title default null)) ["finding[" ++ index ++ "].title"] else []) ++
        (if (!validText(finding.description default null)) ["finding[" ++ index ++ "].description"] else []) ++
        (if (!validText(finding.recommendation default null)) ["finding[" ++ index ++ "].recommendation"] else []) ++
        (if ((finding.location default "") is String and sizeOf(finding.location default "") <= maxTextLength) [] else ["finding[" ++ index ++ "].location"])
---
if (!(response is Object))
    ["response.notObject"]
else
    (if (!validText(response.summary default null)) ["summary"] else []) ++
    (if (!(response.confidence is Number) or response.confidence < 0 or response.confidence > 1) ["confidence"] else []) ++
    (if (!(response.findings is Array)) ["findings.notArray"] else []) ++
    (if (findings is Array and sizeOf(findings) > maxFindings) ["findings.exceedsMaximum"] else []) ++
    (if (findings is Array) flatten(findings map ((finding, index) -> findingErrors(finding, index as String))) else []) ++
    (if (!(response.recommendations is Array)) ["recommendations.notArray"] else []) ++
    (if (recommendations is Array)
        flatten(recommendations map ((recommendation, index) ->
            if (validText(recommendation)) [] else ["recommendation[" ++ (index as String) ++ "]"]))
     else [])
