%dw 2.0
output application/json
---
{
    timestamp: now(),
    correlationId: correlationId,
    status: vars.httpStatus,
    code: vars.errorCode,
    message: vars.errorMessage,
    details: vars.errorDetails
}
