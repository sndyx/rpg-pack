#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform vec4 Color;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec4 normal;
in vec4 tint;

out vec4 fragColor;

#define X_SCALE 0.5;

void main() {
    vec4 color;
    if (texture(Sampler0, vec2(0, 0)) == vec4(1)) {
        vec2 coords = texCoord0;
        coords.x += tint.r * 255;
        coords.x *= X_SCALE;
        color = texture(Sampler0, coords) * vertexColor * ColorModulator;
    } else {
        color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    }
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}