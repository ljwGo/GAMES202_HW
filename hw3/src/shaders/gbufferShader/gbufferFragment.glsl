#version 300 es

#ifdef GL_ES
// useless in webgl2
// #extension GL_EXT_draw_buffers : require
precision highp float;
#endif

#define INV_PI 0.31830988618

uniform vec3 uLightDir;
uniform vec3 uLightRadiance;
uniform sampler2D uKd;
uniform sampler2D uNt;
uniform sampler2D uShadowMap;

in mat4 vWorldToLight;
in highp vec2 vTextureCoord;
in highp vec4 vPosWorld;
in highp vec3 vNormalWorld;
in highp float vDepth;

// layout(location = 0) out vec4 FragData0;
// layout(location = 1) out vec4 FragData1;
// layout(location = 2) out vec4 FragData2;
// layout(location = 3) out vec4 FragData3;
// layout(location = 4) out vec4 FragData4;
// layout(location = 5) out vec4 FragData5;
out vec4 FragData[6];

//Visibility
float SimpleShadowMap(vec3 posWorld,float bias){
  vec4 posLight = vWorldToLight * vec4(posWorld, 1.0);
  vec2 shadowCoord = clamp(posLight.xy * 0.5 + 0.5, vec2(0.0), vec2(1.0));
  float depthSM = texture(uShadowMap, shadowCoord).x;
  float depth = (posLight.z * 0.5 + 0.5) * 100.0;
  return step(0.0, depthSM - depth + bias);
}

void LocalBasis(vec3 n, out vec3 b1, out vec3 b2) {
  float sign_ = sign(n.z);
  if (n.z == 0.0) {
    sign_ = 1.0;
  }
  float a = -1.0 / (sign_ + n.z);
  float b = n.x * n.y * a;
  b1 = vec3(1.0 + sign_ * n.x * n.x * a, sign_ * b, -sign_ * n.x);
  b2 = vec3(b, sign_ + n.y * n.y * a, -n.y);
}

vec3 ApplyTangentNormalMap() {
  vec3 t, b;
  LocalBasis(vNormalWorld, t, b);
  vec3 nt = texture(uNt, vTextureCoord).xyz * 2.0 - 1.0;
  nt = normalize(nt.x * t + nt.y * b + nt.z * vNormalWorld);
  return nt;
}

void main(void) {
  vec3 kd = texture(uKd, vTextureCoord).rgb;
  float visibility = SimpleShadowMap(vPosWorld.xyz, 1e-2);
  vec3 normalFixed = ApplyTangentNormalMap();

  FragData[0] = vec4(kd, 1.0);  // 反照率插值
  FragData[1] = vec4(vec3(vDepth), 1.0);  // 摄像机下场景深度
  FragData[2] = vec4(normalFixed, 1.0);  // 世界坐标下结合法线贴图和插值的法线
  FragData[3] = vec4(vec3(visibility), 1.0);  // 相机视角下的可见性贴图
  FragData[4] = vec4(vPosWorld.xyz, 1.0);  // 世界坐标插值
  
  //在第二步求出直接光照
  float cos = max(dot(normalize(normalFixed), normalize(uLightDir)), 0.);
  vec3 Lo = uLightRadiance * kd * INV_PI * visibility * cos;
  FragData[5] = vec4(Lo, 1.0);
}
