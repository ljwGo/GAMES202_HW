#version 300 es

layout(location = 0) in vec3 aVertexPosition;
layout(location = 1) in vec3 aNormalPosition;
layout(location = 2) in vec2 aTextureCoord;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
uniform mat4 uLightMVP; 


out mat4 vWorldToScreen;
out mat4 vScreenToWorld;
out highp vec4 vPosWorld;


void main(void) {
  vec4 posWorld = uModelMatrix * vec4(aVertexPosition, 1.0);
  vPosWorld = posWorld.xyzw / posWorld.w;
  vWorldToScreen = uProjectionMatrix * uViewMatrix;

  gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(aVertexPosition, 1.0);
}