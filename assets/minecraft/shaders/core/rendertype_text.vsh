#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    if (Color.rgb == vec3(1.0, 1.0, 254.0 / 255.0)) {
        vertexColor = vec4(0.85 + 0.15 * sin(gl_Position.x + GameTime * 5000.0), 0.33, 1.0, Color.a);
        gl_Position.y += sin(GameTime * 5000.0 + (gl_Position.x * 30)) / 150.0;
    } else {
        vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    }
    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    texCoord0 = UV0;
}
