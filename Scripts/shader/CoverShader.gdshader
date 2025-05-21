shader_type canvas_item;

uniform sampler2D dissolve;
uniform sampler2D noise: filter_nearest, repeat_enable;
uniform vec2 noiseOffset;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(dissolve,UV);
	vec4 tex_noise = texture(noise,UV + noiseOffset);
	vec4 tex_noise2 = texture(noise,(UV + noiseOffset)*vec2(0.3,0.4));
	float texure = mix(tex_noise.r,tex_noise2.r,0.5);
	COLOR.a = (tex.a) - (1.0-(tex.r)-(texure));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
