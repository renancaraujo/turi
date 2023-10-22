#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D tTexture;
uniform sampler2D tGameCanvas;


out vec4 fragColor;


const int samples = 12;// The number of "copies" of the canvas made to emulate the "smoke" effect
const float decay = 0.7;// Decay of the light in each sample
const float exposure = .9;// The exposure to the light
const float density = 18.8;// The density of the smoke
const float lightStrength = 1.0;
const float weight = 0.9;

float random2d(vec2 uv) {
    uv /= 256.;
    vec4 tex = texture(tGameCanvas, uv);
    return mix(tex.r, tex.g, tex.a);
}

float random(vec3 xyz){
    return fract(sin(dot(xyz, vec3(12.9898, 78.233, 151.7182))) * 43758.5453);
}


vec4 occlusion(vec2 uv, vec2 lightpos, vec4 objects) {
    return (1. - smoothstep(0.0, lightStrength, length(lightpos - uv))) * (objects);
}

vec4 sampleGameCanvas(vec2 uv) {
    vec4 texColor = texture(tTexture, uv);
    if (texColor.a != 0.0) {
        return vec4(0.0);
    }

    vec4 textColor = texture(tGameCanvas, uv);

    return textColor;
}


void fragment(vec2 uv, vec2 pos, inout vec4 color) {
    vec4 texColor = texture(tTexture, uv);
    color = vec4(0.0, 0.0, 0.0, 0.0);

    if (texColor.a == 0.0) {
        return;
    }

    float reflectiveness = pow(texColor.r * 1.7, 10.0) * 0.9;
    vec3 col = vec3(0);
    float illumination_decay = 1;
    vec2 _uv = uv;
    vec2 lightSource = vec2(0.5, uv.y);
    if (uv.x > 0.5) {
        vec2 distance = (_uv - lightSource) * (1. / float(samples));
        for (int i=0; i<samples; i++) {
            _uv -= distance;
            col += sampleGameCanvas(_uv).rgb * illumination_decay * 0.06;
            illumination_decay *= decay;
        }
        color = vec4(col * reflectiveness, texColor.a);
    } else {
        vec2 distance = (_uv - lightSource) * (1. / float(samples));
        for (int i=0; i<samples; i++) {
            _uv -= distance;
            col += sampleGameCanvas(_uv).rgb * illumination_decay * 0.06;
            illumination_decay *= decay;
        }
        color = vec4(col * reflectiveness, texColor.a);
    }
}

void main() {
    vec2 pos = FlutterFragCoord().xy;

    vec2 uv = pos / uSize;
    vec4 color;

    fragment(uv, pos, color);

    fragColor = color;
}
