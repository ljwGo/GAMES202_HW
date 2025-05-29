#version 300 es

#ifdef GL_ES
precision mediump float;
#endif

uniform float uLigIntensity;
uniform vec3 uLightColor;

out vec4 oFragColor;

void main(void) { oFragColor = vec4(uLightColor, 1.0); }