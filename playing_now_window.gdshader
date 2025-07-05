shader_type canvas_item;

uniform sampler2D alpha;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.a = texture(alpha,UV).a;
	//COLOR.a = 1.0-((cos((UV.x)*PI*2.0)+1.0)/2.0);
	//COLOR.a -= ((cos(UV.y*PI*2.0)+1.0)/2.0);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
