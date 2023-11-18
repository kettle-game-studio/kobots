shader_type spatial;
render_mode unshaded;

uniform sampler2D camera_texture : repeat_disable, filter_nearest;


void fragment() {
	float value = 0.9 + (sin((UV.y - TIME) * 400.0) + 1.0) * 0.5 * 0.1;
	ALBEDO = textureLod(camera_texture, UV, 0.0).rgb * vec3(0.99, 1.0, 1.0) * value *0.7;
	ALPHA = 0.9;
}
