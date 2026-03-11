shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0; // 0 = brak, 1 = full
uniform vec4 fill_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float fill_strength : hint_range(0.0, 1.0) = 0.7;

// Zakres pionowy, w którym ma działać efekt
// 0.0 = góra tekstury, 1.0 = dół tekstury
uniform float fill_min_y : hint_range(0.0, 1.0) = 0.0; // "góra" zakresu
uniform float fill_max_y : hint_range(0.0, 1.0) = 1.0; // "dół" zakresu

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    vec4 result = tex;

    // piksele całkiem przezroczyste zostają jak są
    if (tex.a > 0.001) {
        // znormalizowane Y w obrębie [fill_min_y, fill_max_y]
        float height = max(fill_max_y - fill_min_y, 0.0001);
        float y_local = clamp((UV.y - fill_min_y) / height, 0.0, 1.0);

        // progress 0..1 → od dołu do góry
        // 0 = brak wypełnienia, 1 = cały zakres wypełniony
        float cutoff = 1.0 - progress;
        bool in_range = (UV.y >= fill_min_y) && (UV.y <= fill_max_y);
        bool is_filled = in_range && (y_local >= cutoff); // dół → góra

        vec3 base_rgb = tex.rgb;

        if (is_filled) {
            // CZĘŚĆ "NAŁADOWANA" (od dołu do góry)
            vec3 tinted = mix(base_rgb, fill_color.rgb, fill_strength);
            result = vec4(tinted, tex.a);
        } else {
            // Jeszcze nienaładowana
            result = vec4(base_rgb, tex.a);
        }
    }

    COLOR = result;
}