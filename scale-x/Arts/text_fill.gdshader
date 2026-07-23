shader_type canvas_item;

uniform float fill_amount : hint_range(0.0, 1.0) = 1.0;
uniform float total_width = 100.0;
uniform vec4 fill_color : source_color = vec4(0.2, 0.85, 0.3, 1.0);
uniform vec4 empty_color : source_color = vec4(0.4, 0.4, 0.4, 1.0);

varying float local_x;

void vertex() {
    local_x = VERTEX.x;
}

void fragment() {
    float glyph_alpha = texture(TEXTURE, UV).a; // glyph shape mask
    float threshold = fill_amount * total_width;
    vec4 col = local_x < threshold ? fill_color : empty_color;
    COLOR = vec4(col.rgb, col.a * glyph_alpha);
}