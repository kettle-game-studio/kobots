shader_type spatial;

uniform sampler2D add_texture;
uniform sampler2D emission_texture;
uniform vec3 color: source_color = vec3(1);
uniform bool enable;

void fragment() {
	float k = textureLod(add_texture, UV, 0.0).r;
	ALBEDO = vec3(k);
	ALPHA = k;
	if (enable) {
		EMISSION = textureLod(emission_texture, UV, 0.0).rgb * color;
	}
}
