shader_type spatial;

uniform sampler2D base_texture;
uniform sampler2D add_texture;
uniform sampler2D emission_texture;
uniform vec3 color: source_color = vec3(1);
uniform bool enable;
uniform float emission_k = 1.0;

void fragment() {
	float k = textureLod(add_texture, UV, 0.0).r;
	ALBEDO = textureLod(base_texture, UV, 0.0).rgb * (1.0 - k) + color * k;
	if (enable) {
		vec3 emission = textureLod(emission_texture, UV, 0.0).rgb;
		float emission_force = (emission.x + emission.y + emission.z) * 0.333;
		EMISSION = emission * color + vec3(emission_k * emission_force);
	}
}
