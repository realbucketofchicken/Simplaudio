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
	COLOR.a = (tex.a) - (1.0-(tex.r)-(tex_noise.b));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
