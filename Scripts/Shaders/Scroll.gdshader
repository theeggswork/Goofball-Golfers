shader_type canvas_item;

void vertex() {
	UV.x += TIME / 10.0;
	UV.y += TIME / 10.0;
}

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a = 0.5;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
