shader_type canvas_item;

uniform sampler2D BAR_MAGNITUDES;
uniform vec4 VIS_COLOR: hint_color;

void fragment() {
	ivec2 tex_size = textureSize(BAR_MAGNITUDES, 0);
	float height = texture(BAR_MAGNITUDES, floor(UV * float(tex_size.x)) / float(tex_size.x)).r;

	COLOR = mix(vec4(0.0), VIS_COLOR, float((1.0 - UV.y) < height));
}
