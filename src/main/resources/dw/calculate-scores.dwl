%dw 2.0
output application/java
var rules = vars.ruleResults default []

fun categoryScore(category: String) = do {
    var categoryRules = rules filter ((rule) -> rule.category == category)
    var passedRules = categoryRules filter ((rule) -> rule.passed)
    ---
    if (isEmpty(categoryRules)) 100
    else round((sizeOf(passedRules) / sizeOf(categoryRules)) * 100)
}

var design = categoryScore("DESIGN")
var security = categoryScore("SECURITY")
var documentation = categoryScore("DOCUMENTATION")
---
{
    designScore: design,
    securityScore: security,
    documentationScore: documentation,
    overallScore: round((design * 0.40) + (security * 0.35) + (documentation * 0.25))
}
