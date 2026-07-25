shader_type canvas_item;

uniform float fill_amount : hint_range(0.0, 1.0) = 1.0;
uniform float total_width = 100.0;
uniform vec4 fill_tint : source_color = vec4(1.3, 1.3, 1.3, 1.0); // >1 = lighter, <1 = darker
uniform vec4 empty_tint : source_color = vec4(0.5, 0.5, 0.5, 1.0); // >1 = lighter, <1 = darker

varying float local_x;

void vertex() {
    local_x = VERTEX.x;
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV); // full-color texture, not just a glyph mask
    float threshold = fill_amount * total_width;
    vec4 tint = local_x < threshold ? fill_tint : empty_tint;

    // Multiply blend: keeps every original detail/hue in the texture,
    // just scales brightness up (>1) or down (<1). No color overlay.
    vec3 result_rgb = tex.rgb * tint.rgb;
    COLOR = vec4(result_rgb, tex.a * tint.a);
}