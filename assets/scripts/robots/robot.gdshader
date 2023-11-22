shader_type spatial;

uniform sampler2D base_texture;
uniform sampler2D add_texture;
uniform sampler2D emission_texture;
uniform vec3 color: source_color = vec3(1);
uniform bool enable;
uniform float emission_k = 1.0;
uniform float specular = 1.0;
uniform float roughness = 0.3;

uniform bool emission_blink = false;
uniform float emission_amplitude = 0.1;
uniform float emission_period = 1.0;


void fragment() {
	float k = textureLod(add_texture, UV, 0.0).r;
	ALBEDO = textureLod(base_texture, UV, 0.0).rgb * (1.0 - k) + color * k;
	if (ALBEDO.x + ALBEDO.y + ALBEDO.z > 1.5 && k < 0.1) {
		SPECULAR = specular;
		ROUGHNESS = roughness;
	} else {
		SPECULAR = 0.3;
		ROUGHNESS = 0.4;
	}
	if (enable) {
		float emission_km = emission_k;
		if (emission_blink) {
			emission_km += sin(TIME * emission_period) * emission_amplitude;
		}
		vec3 emission = textureLod(emission_texture, UV, 0.0).rgb;
		float emission_force = (emission.x + emission.y + emission.z) * 0.333;
		EMISSION = emission * color + vec3(emission_km * emission_force);
	}
}
