%dw 2.0
output application/json
---
{
	model: vars.aiInternalRequest.model,
	messages: [{
		role: "system",
		content: vars.aiInternalRequest.instructions
	},
        {
		role: "user",
		content: vars.aiInternalRequest.untrustedInput
	}],
	stream: false,
	format: "json",
	options: {
		temperature: vars.aiInternalRequest.generation.temperature,
		"num_predict": 600,
		"num_ctx": 4096
	}
}
