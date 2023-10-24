#version 460 core

precision highp float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uReflecty;
uniform float uTime;

uniform sampler2D tTexture;

out vec4 fragColor;

void fragment(vec2 uv, vec2 pos, inout vec4 color) {
    vec4 waterColor = vec4(1.0);
    color = vec4(0.0);
    vec2 reflectedUv = uv.xy;
    if (uv.y >= uReflecty) {
        reflectedUv.y = 2.0 * uReflecty - reflectedUv.y;
        reflectedUv.y = uReflecty + (reflectedUv.y - uReflecty) * 3;
        reflectedUv.x = reflectedUv.x +(sin((uv.y-uReflecty/1)+uTime*1.0)*0.01);
        reflectedUv.y = reflectedUv.y + cos(1./(uv.y-uReflecty)+uTime*1.0)*0.03;

        waterColor = vec4(1.0);
        waterColor.rgb *=1 - ((uv.y-uReflecty) / (1.0-uReflecty));

        if (reflectedUv.y <=0) {
            color = vec4(0.0);
            return;
        }
    }
    color = texture(tTexture, reflectedUv) * waterColor;
}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    vec4 color;

    fragment(uv, pos, color);

    fragColor = color;
}
