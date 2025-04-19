shader_type canvas_item;

uniform float time_speed = 6;
uniform float scanline_strength = 0.000000005; // Even softer
uniform float distortion_strength = 0.000005;
uniform float chroma_offset = 0.0015;

void fragment() {
    vec2 uv = UV;

    // Very subtle horizontal wave
    uv.y += sin(uv.x * 40.0 + TIME * time_speed) * distortion_strength;

    // Soft RGB separation
    float r = texture(TEXTURE, uv + vec2(chroma_offset, 0.0)).r;
    float g = texture(TEXTURE, uv).g;
    float b = texture(TEXTURE, uv - vec2(chroma_offset, 0.0)).b;
    vec3 color = vec3(r, g, b);

    // Gentle scanlines
    float scanline = sin(uv.y * 240.0) * scanline_strength;
    color -= scanline;

    COLOR = vec4(color, texture(TEXTURE, UV).a);
}
