shader_type canvas_item;

uniform vec2 highlight_pos = vec2(300.0, 200.0);   // top-left corner, screen pixels
uniform vec2 highlight_size = vec2(200.0, 150.0);
uniform float feather = 6.0;                       // soft edge width in pixels
uniform float dim_alpha : hint_range(0.0, 1.0) = 0.85;

void fragment() {
    vec2 frag = FRAGCOORD.xy;
    vec2 min_b = highlight_pos;
    vec2 max_b = highlight_pos + highlight_size;

    float inside_x = smoothstep(min_b.x - feather, min_b.x, frag.x) 
                    - smoothstep(max_b.x, max_b.x + feather, frag.x);
    float inside_y = smoothstep(min_b.y - feather, min_b.y, frag.y) 
                    - smoothstep(max_b.y, max_b.y + feather, frag.y);
    float inside = inside_x * inside_y;

    COLOR = vec4(0.0, 0.0, 0.0, dim_alpha * (1.0 - inside));
}