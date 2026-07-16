%dw 2.0
output application/json
var failedRules = (vars.ruleResults default []) filter ((rule) -> !rule.passed)
---
{
    analysisId: uuid(),
    fileName: vars.fileName,
    specificationType: vars.specificationType,
    timestamp: now(),
    overallScore: vars.scores.overallScore,
    designScore: vars.scores.designScore,
    securityScore: vars.scores.securityScore,
    documentationScore: vars.scores.documentationScore,
    violations: failedRules map ((rule) -> {
        ruleId: rule.ruleId,
        category: rule.category,
        severity: rule.severity,
        message: rule.violationMessage
    }),
    recommendations: failedRules map ((rule) -> {
        ruleId: rule.ruleId,
        message: rule.recommendation
    })
}
