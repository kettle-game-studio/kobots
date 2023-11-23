shader_type spatial;

uniform sampler2D base_texture;
uniform sampler2D emission_texture;
uniform float emission_k = 1.0;
uniform vec3 color: source_color = vec3(1);

void fragment() {
	float emisstion = textureLod(emission_texture, UV, 0.0).r;
	ALBEDO = textureLod(base_texture, UV, 0.0).rgb * (1.0 - emisstion);
	EMISSION = emisstion * emission_k * color;
}
