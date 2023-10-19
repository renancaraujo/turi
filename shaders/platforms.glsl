#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D tTexture;

out vec4 fragColor;

void fragment(vec2 uv, vec2 pos, inout vec4 color) {




        color = texture(tTexture, uv);
        if(color == vec4(0.0, 0.0, 0.0, 1.0)) {
           color = vec4(0.0);
        } else {
            float red = uv.x;
            float green = uv.y;
            float blue = 1.0 - red;
            color = vec4(red, green, blue, 1.0);
        }



}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    vec4 color;

    fragment(uv, pos, color);

    fragColor = color;
}
