shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 animatedUV;
	animatedUV.x = (sin(UV.x + (TIME))/2.0)+0.5;
	animatedUV.y = (sin(UV.y + (TIME+(PI/2.0)))/2.0)+0.5;
	float color1 = 1.0 *animatedUV.x;
	float color2 = 1.0 *animatedUV.y;
	
	COLOR = vec4((color1*0.7)+(color2*0.3),(color1*0.5)+(color2*0.5),(color1*0.3)+(color2*0.7),1);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
