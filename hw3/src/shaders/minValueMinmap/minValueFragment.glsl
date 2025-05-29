#version 300 es

#ifdef GL_ES
// #extension GL_EXT_draw_buffers : require
precision highp float;
#endif

uniform float uLevel;
uniform float uWidth;
uniform float uHeight;
uniform sampler2D uSceneDepthMinmap;

in mat4 vWorld2Screen;
in highp vec2 uv;

out vec4 FragData;

float GetGBufferDepth(vec2 uv) {
  float depth = texture(uSceneDepthMinmap, uv).x;
  if (depth < 1e-2) {
    depth = 1000.0;
  }
  return depth;
}

void main(){
  // opengl1.0不支持<<操作; 使用floor(x+0.5)做到四舍五入函数的代替

  vec2 pixelUV = vec2(1. / uWidth, 1. / uHeight);
  vec2 quarterPixelUV = pixelUV * 0.25;

  // 获取周围四格的uv
  // r is right; l is left; b is bottom; t is top;
  vec2 rtUV = clamp(uv + quarterPixelUV, vec2(0.), vec2(1.));
  vec2 lbUV = clamp(uv - quarterPixelUV, vec2(0.), vec2(1.));
  vec2 rbUV = clamp(vec2(uv.x + quarterPixelUV.x, uv.y - quarterPixelUV.y), vec2(0.), vec2(1.));
  vec2 ltUV = clamp(vec2(uv.x - quarterPixelUV.x, uv.y + quarterPixelUV.y), vec2(0.), vec2(1.));

  //比较周围四个的深度值，并求最小值
  float rtDepth = GetGBufferDepth(rtUV);
  float rbDepth = GetGBufferDepth(rbUV);
  float ltDepth = GetGBufferDepth(ltUV);
  float lbDepth = GetGBufferDepth(lbUV);

  // bug03: minDepth不能太大，否则会导致深度贴图背景是白色的
  float minDepth = 1000.;
  float esp = 1e-3;
  if (minDepth > rtDepth && rtDepth > esp) minDepth = rtDepth;
  if (minDepth > rbDepth && rbDepth > esp) minDepth = rbDepth;
  if (minDepth > ltDepth && ltDepth > esp) minDepth = ltDepth;
  if (minDepth > lbDepth && lbDepth > esp) minDepth = lbDepth;

  // 周围都是背景，因此将深度置为0
  if (minDepth >= 1000.) minDepth = 0.;

  FragData = vec4(vec3(minDepth), 1.0);
}