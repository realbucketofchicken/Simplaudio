shader_type canvas_item;

uniform sampler2D dissolve;
uniform sampler2D dissolve2 : repeat_enable;
uniform float secondIntensity;
uniform float secondSpeed;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 tex = texture(dissolve,UV);
	COLOR.a = tex.a;
	COLOR.a -= (texture(dissolve2,UV+(vec2(TIME,TIME*0.3)*secondSpeed))*1.0-tex.a*secondIntensity).r;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}