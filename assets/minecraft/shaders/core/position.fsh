#version 150

#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float GameTime;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec2 ScreenSize;

in float vertexDistance;
in vec4 rawPos;

out vec4 fragColor;

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec3 i) {
    vec2 n = i.xz * abs(i.y / 70 - 5);
    const vec2 d = vec2(0.0, 1.0);
    vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
    return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y) * 2 - 1;
}

float fbm(vec3 x) {
    // Properties
    const int octaves = 4;
    float lacunarity = 2.5;
    float gain = 0.5;

    // Initial values
    float amplitude = 0.5;
    float frequency = 1.;
    float y = 0.0;

    // Octave loop
    for (int i = 0; i < octaves; i++) {
        y += amplitude * noise(frequency*x);
        frequency *= lacunarity;
        amplitude *= gain;
    }
    return y;
}

// This function makes a 3D space that you can sample to get a color.
// In this case, the part that is sampled is a unit sphere around the origin, but you can displace it however you want.
vec3 sampleStarfield(vec3 v) {
    float stars = max(0, noise(v * 100 + GameTime*20.0)-0.7) * 5;
    float starfield = max(0.05, noise(v * vec3(1, 1, 0.5) + GameTime*20.0));
    stars *= starfield;
    
    float res = fbm(v * 2 + vec3(GameTime*10.0, 0, 0));
    vec3 sky = max(0, res+0.1) * vec3(36, 24, 39)/255;
    
    float res2 = fbm(v * 2.5 + vec3(0, GameTime*10.0, 0) + vec3(10.4, 0, 0));
    sky += max(0, res2+0.15) * vec3(21, 38, 76)/255;
    sky += stars;
    sky += starfield * 0.1;
    float grid_position = fract(dot(gl_FragCoord.xy - vec2(0.5,0.5), vec2(1.0/16.0,10.0/36.0)+0.25));
    float dither = grid_position / 256;
    sky += dither;
    return sky;
}

vec3 sampleClouds(vec3 v) {
    float res = fbm(v * 2 + vec3(GameTime*10.0, 0, 0));
    vec3 sky = max(0, res+0.1) * vec3(253, 240, 242)/255;
    return sky;
}

void main() {
    vec2 pos = gl_FragCoord.xy / ScreenSize;
    pos -= vec2(0.5, 0.5);
    pos *= 2;
    vec4 cast_pos = vec4(pos, 1.0, 1.0);
    cast_pos = inverse(ProjMat) * cast_pos;
    cast_pos = normalize(cast_pos);
    vec3 v = normalize(cast_pos.xyz * mat3(ModelViewMat));
    float intensity = 1.0 - (ColorModulator.r + ColorModulator.g + ColorModulator.b);
    if (intensity < 0) {
		fragColor = ColorModulator;
	} else {
        fragColor = vec4(sampleStarfield(v), 1.0) * intensity + ColorModulator;
    }
}


