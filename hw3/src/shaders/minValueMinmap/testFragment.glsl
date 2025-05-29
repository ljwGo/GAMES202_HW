#version 300 es

#ifdef GL_ES
precision highp float;
#endif

in vec2 uv;

uniform sampler2D uGDepth;
uniform sampler2D uSceneDepthMinmap01;
uniform sampler2D uSceneDepthMinmap02;
uniform sampler2D uSceneDepthMinmap03;
uniform sampler2D uSceneDepthMinmap04;
uniform sampler2D uSceneDepthMinmap05;
uniform sampler2D uSceneDepthMinmap06;
uniform sampler2D uSceneDepthMinmap07;
uniform sampler2D uSceneDepthMinmap08;
uniform sampler2D uSceneDepthMinmap09;

out vec4 oFragColor;

void main(){
  oFragColor = vec4(texture(uSceneDepthMinmap01, uv).xyz / 10., 1.);
  // oFragColor = vec4(uv, 0., 1.);
}