shader_type canvas_item;
render_mode unshaded;  // Recommended for UI/sprites to avoid lighting

// Uniforms (editable in the inspector)
uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 1.0, 1.0); // Default: white
uniform int outline_thickness : hint_range(0, 20) = 0;                 // Integer thickness in pixels

void fragment() 
{
	vec4 tex_color = texture(TEXTURE, UV);

	// If thickness is 0, just show the original texture
	if (outline_thickness <= 0)
	{
		COLOR = tex_color;
	}
	else
	{
		// Sample alpha in 8 directions around the current pixel
		float alpha = 0.0;

		// Use pixel size for correct thickness regardless of sprite scale
		vec2 pixel_size = TEXTURE_PIXEL_SIZE * float(outline_thickness);

		// 8 directions (for a nice round-ish outline)
		vec2 offsets[4];
		offsets[0] = vec2(1.0, 0.0);
		offsets[1] = vec2(-1.0, 0.0);
		offsets[2] = vec2(0.0, 1.0);
		offsets[3] = vec2(0.0, -1.0);
// 		offsets[4] = vec2(1.0, 1.0);
// 		offsets[5] = vec2(1.0, -1.0);
// 		offsets[6] = vec2(-1.0, 1.0);
// 		offsets[7] = vec2(-1.0, -1.0);

		for (int i = 0; i < 4; i++) {
			vec2 sample_uv = UV + offsets[i] * pixel_size;

			if (
				sample_uv.x >= 0.0 && sample_uv.x <= 1.0 &&
						sample_uv.y >= 0.0 && sample_uv.y <= 1.0
			) {
				alpha = max(alpha, texture(TEXTURE, sample_uv).a);
			}
		}

		// If the current pixel is transparent but a neighbor has alpha, draw outline
		if (tex_color.a < 0.5 && alpha > 0.5) {
			COLOR = outline_color;
		} else {
			COLOR = tex_color;
		}
	}
}