shader_type canvas_item;

uniform float intensity;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 as = texture(screen_texture,SCREEN_UV);
	vec4 a2s = texture(TEXTURE,UV);
	vec4 fart = a2s * (0.1 + as.bgra);
	COLOR = fart * intensity;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
