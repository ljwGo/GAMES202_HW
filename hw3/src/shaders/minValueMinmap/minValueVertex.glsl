#version 300 es

layout(location = 0) in vec3 aVertexPosition;
layout(location = 1) in vec3 aNormalPosition;
layout(location = 2) in vec2 aTextureCoord;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

out mat4 vWorld2Screen;
out highp vec2 uv;

void main(){
  uv = aTextureCoord;
  vWorld2Screen = uProjectionMatrix * uViewMatrix;

  gl_Position = vec4(aVertexPosition, 1.0);
}