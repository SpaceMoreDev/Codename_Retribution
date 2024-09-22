shader_type spatial;
render_mode cull_disabled, unshaded;

// Uniforms for controlling the sway and other parameters
uniform float Yoffset = 0.5;
uniform float Transparency = 1;
uniform float animation_speed = 0.5;
uniform float sway_intensity = 0.1; // Intensity of the sway effect
uniform float sway_speed = 1.0;     // Speed of the swaying motion
uniform float min_y_position = 0.0; // The lowest y-position where sway begins
uniform float max_y_position = 1.0; // The highest y-position for maximum sway
uniform vec4 flame_color : source_color = vec4(1.0);
uniform sampler2D noise_texture : hint_default_black, repeat_enable;
uniform float blur_amount = 1.0;
uniform float uv_scale = 1.0;

void vertex() {
    // Create a gradient factor based on the vertex's y-position
    // Vertices near 'min_y_position' will have no sway, and those near 'max_y_position' will sway the most
    float gradient = clamp((VERTEX.y - min_y_position) / (max_y_position - min_y_position), 0.0, 1.0);

    // Apply sway to the vertices along the x and z axes (or just the x-axis for a side-to-side motion)
    float sway_x = sin(VERTEX.y * 5.0 + TIME * sway_speed) * sway_intensity * gradient;
    float sway_z = cos(VERTEX.y * 5.0 + TIME * sway_speed) * sway_intensity * gradient;

    // Modify the local position using the gradient sway effect
    VERTEX.x += sway_x;
    VERTEX.z += sway_z;
}

void fragment() {
    // Adjust UV scaling and animate over time
    vec2 uv = UV * uv_scale;
    uv.y += TIME * animation_speed;

    // Wrap UV coordinates to ensure seamless tiling
    uv = fract(uv);

    // Blur sampling with seamless wrapping
    vec2 offsets[9] = vec2[](
        vec2(-1.0, 1.0), vec2(0.0, 1.0), vec2(1.0, 1.0),
        vec2(-1.0, 0.0), vec2(0.0, 0.0), vec2(1.0, 0.0),
        vec2(-1.0, -1.0), vec2(0.0, -1.0), vec2(1.0, -1.0)
    );

    float weights[9] = float[](
        1.0, 2.0, 1.0,
        2.0, 4.0, 2.0,
        1.0, 2.0, 1.0
    );

    vec4 blurred_color = vec4(0.0);
    float total_weight = 16.0;

    // Sample the texture and ensure seamless wrapping at the edges
    for (int i = 0; i < 9; i++) {
        vec2 offset_uv = fract(uv + offsets[i] * blur_amount * 0.01);
        blurred_color += texture(noise_texture, offset_uv) * weights[i];
    }

    blurred_color /= total_weight;

    vec4 final_color = blurred_color;
    final_color.rgb += vec3(UV.y - Yoffset);
    final_color.rgb = smoothstep(.6, .2, final_color.rgb);
    final_color.rgb = vec3(1.0) - final_color.rgb;
    final_color.a = final_color.r;
    final_color.rgb *= flame_color.rgb;
    
    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
}
