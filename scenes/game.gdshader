shader_type canvas_item;

uniform float softness : hint_range(0.0, 1.0) = 0.5;
uniform float intensity : hint_range(0.0, 1.0) = 0.8;
uniform vec4 vignette_color : source_color = vec4(0, 0, 0, 1.0);

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // convert to range [-1,1]
    float len = length(uv);
    float vignette = smoothstep(softness, 1.0, len);
    COLOR = mix(COLOR, vignette_color, vignette * intensity);
}
