#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uReflecty;
uniform float uTime;
uniform vec2 uConcreteSize;

uniform sampler2D tTexture;
uniform sampler2D tConcreteTexture;


out vec4 fragColor;

void fragment(vec2 uv, vec2 pos, inout vec4 color) {

    vec4 waterColor = vec4(1.0);

    if (uv.y >= uReflecty) {
        vec2 oguv = uv.xy;
        uv.y = 2.0 * uReflecty - uv.y;
        uv.y = uReflecty + (uv.y - uReflecty) * 3;
        uv.x = uv.x + sin(2 /(oguv.y-uReflecty+0.5)+uTime*1.0)*0.01;

        uv.y = uv.y + cos(1./(oguv.y-uReflecty)+uTime*1.0)*0.03;

        waterColor = vec4(1, 1, 1.0, 1.0);
        waterColor.rgb *=1 - ((oguv.y-uReflecty) / (1.0-uReflecty));
        waterColor.rgb *= pow(texture(tConcreteTexture, uv).r, 0.8);
        color.rgb *= texture(tConcreteTexture, uv).r;

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
