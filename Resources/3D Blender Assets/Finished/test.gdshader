shader_type spatial;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_nearest;

uniform float edge_threshold = 0.1;

uniform vec3 highlight_color : source_color = vec3(1.);
uniform vec3 shadow_color : source_color = vec3(0.0);

uniform float shadow_strength : hint_range(0.0, 1.0, 0.01) = 0.4;
uniform float highlight_strength : hint_range(0.0, 1.0, 0.01) = 0.1;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 screen_color = texture(SCREEN_TEXTURE, uv);
	float depth = texture(DEPTH_TEXTURE, uv).r;
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;

	vec2 offset = 1.0 / VIEWPORT_SIZE;

	float depth_right = texture(DEPTH_TEXTURE, uv + vec2(offset.x, 0.0)).r;
	float depth_down = texture(DEPTH_TEXTURE, uv + vec2(0.0, offset.y)).r;

	vec3 normal_right = texture(NORMAL_TEXTURE, uv + vec2(offset.x, 0.0)).rgb;
	vec3 normal_down = texture(NORMAL_TEXTURE, uv + vec2(0.0, offset.y)).rgb;

	float edge_depth = abs(depth_right - depth) + abs(depth_down - depth);
	float edge_normal = length(normal_right - normal) + length(normal_down - normal);

	if (edge_depth > edge_threshold || edge_normal > edge_threshold) {
		ALBEDO = mix(screen_color.rgb, highlight_color, highlight_strength); // highlight color works much better 
	} else {
		ALBEDO = mix(screen_color.rgb, shadow_color, shadow_strength); // shadow color for now not working at some angles
	}
}