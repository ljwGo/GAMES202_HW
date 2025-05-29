#version 300 es

#ifdef GL_ES
// #extension GL_EXT_draw_buffers : require
precision highp float;
#endif

uniform vec3 uCameraPos;

in highp vec3 vNormal;
in highp vec2 vTextureCoord;
in highp float vDepth;

// gl_开头的属性是指内置的
out vec4 FragData;

vec4 EncodeFloatRGBA(float v) {
  vec4 enc = vec4(1.0, 255.0, 65025.0, 160581375.0) * v;
  enc = fract(enc);
  enc -= enc.yzww * vec4(1.0/255.0,1.0/255.0,1.0/255.0,0.0);
  return enc;
}

void main(){
  FragData = vec4(vec3(gl_FragCoord.z) * 100.0, 1.0);
  // FragData = EncodeFloatRGBA(gl_FragCoord.z * 100.0);
}