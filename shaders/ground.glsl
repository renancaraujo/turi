#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uReflecty;
uniform float uBoundaryLeft;
uniform float uBoundaryRight;
uniform float uTime;

uniform sampler2D tTexture;


out vec4 fragColor;

void fragment(vec2 uv, vec2 pos, inout vec4 color) {
    if (uv.x < uBoundaryLeft || uv.x > uBoundaryRight) {
        color = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    vec4 waterColor = vec4(1.0);

    if (uv.y >= uReflecty) {
        float oy = uv.y;
        uv.y = 2.0 * uReflecty - uv.y;
        // magnify reflection
        uv.y = uReflecty + (uv.y - uReflecty) * 3;
        uv.y = uv.y + sin(1./(oy-uReflecty)+uTime*10.0)*0.03;

        waterColor = vec4(1, 1, 1.0, 1.0);
        waterColor.rgb *=1 - ((oy-uReflecty) / (1.0-uReflecty));

        if (uv.y <=0) {
            color = vec4(0.0, 0.0, 0.0, 0.0);
            return;
        }
    }

    color = texture(tTexture, uv) * waterColor;
}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    vec4 color;

    fragment(uv, pos, color);

    fragColor = color;
}
