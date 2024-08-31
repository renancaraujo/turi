#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float showGrain;
uniform vec4[25] colors;
uniform float[25] colorBias;

out vec4 fragColor;


float getLuma(vec3 color) {
    vec3 weights = vec3(0.299, 0.587, 0.114);
    return dot(color, weights);
}

vec2 vertices(int index) {
    float x = mod(index, 5.0) / 4.0;
    float y = floor(index / 5.0) / 4.0;
    return vec2(x, y);
}

void getColor(int index, out vec4 color, out float bias) {
    color = colors[0];
    bias = colorBias[0];

    if (index == 1) {
        color = colors[1];
        bias = colorBias[1];
    }
    if (index == 2) {
        color = colors[2];
        bias = colorBias[2];
    }
    if (index == 3) {
        color = colors[3];
        bias = colorBias[3];
    }
    if (index == 4) {
        color = colors[4];
        bias = colorBias[4];
    }
    if (index == 5) {
        color = colors[5];
        bias = colorBias[5];
    }
    if (index == 6) {
        color = colors[6];
        bias = colorBias[6];
    }
    if (index == 7) {
        color = colors[7];
        bias = colorBias[7];
    }
    if (index == 8) {
        color = colors[8];
        bias = colorBias[8];
    }
    if (index == 9) {
        color = colors[9];
        bias = colorBias[9];
    }
    if (index == 10) {
        color = colors[10];
        bias = colorBias[10];
    }
    if (index == 11) {
        color = colors[11];
        bias = colorBias[11];
    }
    if (index == 12) {
        color = colors[12];
        bias = colorBias[12];
    }
    if (index == 13) {
        color = colors[13];
        bias = colorBias[13];
    }
    if (index == 14) {
        color = colors[14];
        bias = colorBias[14];
    }
    if (index == 15) {
        color = colors[15];
        bias = colorBias[15];
    }
    if (index == 16) {
        color = colors[16];
        bias = colorBias[16];
    }
    if (index == 17) {
        color = colors[17];
        bias = colorBias[17];
    }
    if (index == 18) {
        color = colors[18];
        bias = colorBias[18];
    }
    if (index == 19) {
        color = colors[19];
        bias = colorBias[19];
    }
    if (index == 20) {
        color = colors[20];
        bias = colorBias[20];
    }
    if (index == 21) {
        color = colors[21];
        bias = colorBias[21];
    }
    if (index == 22) {
        color = colors[22];
        bias = colorBias[22];
    }
    if (index == 23) {
        color = colors[23];
        bias = colorBias[23];
    }
    if (index == 24) {
        color = colors[24];
        bias = colorBias[24];
    }
}

vec4 fragment(vec2 uv, vec2 pos) {
    vec4 color = vec4(0.0);

    /// define in which square we are in
    int index = int(floor(uv.x * 4.0) + floor(uv.y * 4.0) * 5.0);

    vec2 topLeft = vertices(index);
    vec2 topRight = vertices(index + 1);
    vec2 bottomLeft = vertices(index + 5);
    vec2 bottomRight = vertices(index + 6);

    // uv within the square
    vec2 uvInSquare = (uv - topLeft) / (bottomRight - topLeft);

    // get the colors
    vec4 colorTopLeft;
    float biasTopLeft;
    getColor(index, colorTopLeft, biasTopLeft);

    vec4 colorTopRight;
    float biasTopRight;
    getColor(index + 1, colorTopRight, biasTopRight);

    vec4 colorBottomLeft;
    float biasBottomLeft;
    getColor(index + 5, colorBottomLeft, biasBottomLeft);

    vec4 colorBottomRight;
    float biasBottomRight;
    getColor(index + 6, colorBottomRight, biasBottomRight);

    vec4 trashBucket;
    float biasLeftToTopLeft;
    float biasLeftToBottomLeft;
    if (mod(index, 5) == 0) {
        biasLeftToTopLeft = 0.0;
        biasLeftToBottomLeft = 0.0;
    } else {
        getColor(index - 1, trashBucket, biasLeftToTopLeft);
        getColor(index + 4, trashBucket, biasLeftToBottomLeft);
    }

    float biasRightToTopRight;
    float biasRightToBottomRight;
    if (mod(index, 5)  == 4) {
        biasRightToTopRight = 0.0;
        biasRightToBottomRight = 0.0;
    } else {
        getColor(index + 2, trashBucket, biasRightToTopRight);
        getColor(index + 7, trashBucket, biasRightToBottomRight);
    }

    // interpolate the colors
    float hasSoroundingBias = biasTopLeft + biasTopRight + biasBottomLeft + biasBottomRight;
    float hasVerticalBias = biasLeftToTopLeft + biasLeftToBottomLeft + biasRightToTopRight + biasRightToBottomRight;

    vec4 a;
    vec4 b;
    if (hasSoroundingBias != 0.0) {
        if (biasTopLeft != 0.0 || biasTopRight != 0.0) {
            a = mix(colorTopLeft, colorTopRight, smoothstep(0.0, 1.0, uvInSquare.x));
        } else {
            a = mix(colorTopLeft, colorTopRight, uvInSquare.x);
        }

        if (biasBottomLeft != 0.0 || biasBottomRight != 0.0) {
            b = mix(colorBottomLeft, colorBottomRight, smoothstep(0.0, 1.0, uvInSquare.x));
        } else {
            b = mix(colorBottomLeft, colorBottomRight, uvInSquare.x);
        }

        color = mix(a, b, smoothstep(0.0, 1.0, uvInSquare.y));
    } else if (hasVerticalBias != 0.0)  {
        if (biasLeftToTopLeft != 0.0 || biasLeftToBottomLeft != 0.0) {
            a = mix(colorTopLeft, colorBottomLeft, smoothstep(0.0, 1.0, uvInSquare.y));
        } else {
            a = mix(colorTopLeft, colorBottomLeft, uvInSquare.y);
        }

        if (biasRightToTopRight != 0.0 || biasRightToBottomRight != 0.0) {
            b = mix(colorTopRight, colorBottomRight, smoothstep(0.0, 1.0, uvInSquare.y));
        } else {
            b = mix(colorTopRight, colorBottomRight, uvInSquare.y);
        }

        color = mix(a, b, uvInSquare.x);
    } else {
        b = mix(colorBottomLeft, colorBottomRight, uvInSquare.x);
        a = mix(colorTopLeft, colorTopRight, uvInSquare.x);
        color = mix(a, b, uvInSquare.y);
    }


    return color;
}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    vec4 color = fragment(uv, pos);

    if(showGrain == 1.0) {
        float mdf = 0.07;
        float noise = (fract(sin(dot(uv, vec2(12.9898, 78.233)*2.0)) * 43758.5453));
        float luma = getLuma(color.rgb);
        mdf *= (luma - 0.33) *3;
        color += noise * mdf;
    }

    fragColor = color;
}
