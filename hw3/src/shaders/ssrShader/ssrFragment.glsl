#version 300 es

#ifdef GL_ES
precision highp float;
#endif

uniform float uMaxMinmapLevel;
uniform float uWidth[10];
uniform float uHeight[10];
uniform vec2 uLastMinmapUVMap[9];  // 索引为1的vec2, 表示第二级minmap的uv映射到第一级minmap uv的关系; 其它同理
uniform vec3 uLightDir;
uniform vec3 uCameraPos;
uniform vec3 uLightRadiance;
uniform sampler2D uGDiffuse;
uniform sampler2D uGDepth;
uniform sampler2D uGNormalWorld;
// uniform sampler2D uGLightDepth;
uniform sampler2D uGShadow;
uniform sampler2D uGPosWorld;
uniform sampler2D uGDirectLight;
uniform sampler2D uSceneDepthMinmap[9];

in mat4 vWorldToScreen;
in mat4 vScreenToWorld;  // screen is [-1, 1]
in highp vec4 vPosWorld;

out vec4 oFragColor;

#define M_PI 3.1415926535897932384626433832795
#define TWO_PI 6.283185307
#define INV_PI 0.31830988618
#define INV_TWO_PI 0.15915494309

float Rand1(inout float p) {
  p = fract(p * .1031);
  p *= p + 33.33;
  p *= p + p;
  return fract(p);
}

vec2 Rand2(inout float p) {
  return vec2(Rand1(p), Rand1(p));
}

float InitRand(vec2 uv) {
	vec3 p3  = fract(vec3(uv.xyx) * .1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

vec3 SampleHemisphereUniform(inout float s, out float pdf) {
  vec2 uv = Rand2(s);
  float z = uv.x;
  float phi = uv.y * TWO_PI;
  float sinTheta = sqrt(1.0 - z*z);
  vec3 dir = vec3(sinTheta * cos(phi), sinTheta * sin(phi), z);
  pdf = INV_TWO_PI;
  return dir;
}

vec3 SampleHemisphereCos(inout float s, out float pdf) {
  vec2 uv = Rand2(s);
  float z = sqrt(1.0 - uv.x);
  float phi = uv.y * TWO_PI;
  float sinTheta = sqrt(uv.x);
  vec3 dir = vec3(sinTheta * cos(phi), sinTheta * sin(phi), z);
  pdf = z * INV_PI;
  return dir;
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

vec4 Project(vec4 a) {
  return a / a.w;
}

float GetDepth(vec3 posWorld) {
  float depth = (vWorldToScreen * vec4(posWorld, 1.0)).w;
  return depth;
}

/*
 * Transform point from world space to screen space([0, 1] x [0, 1])
 *
 */
vec2 GetScreenCoordinate(vec3 posWorld) {
  vec2 uv = Project(vWorldToScreen * vec4(posWorld, 1.0)).xy * 0.5 + 0.5;
  return uv;
}

vec3 GetRayScreenCoord(vec3 posWorld){
  vec3 uv = Project(vWorldToScreen * vec4(posWorld, 1.0)).xyz * 0.5 + 0.5;
  return uv;
}

float GetGBufferDepth(sampler2D m_sample, vec2 uv) {
  float depth = texture(m_sample, uv).x;
  if (depth < 1e-2) {
    depth = 1000.0;
  }
  return depth;
}

vec3 GetGBufferNormalWorld(vec2 uv) {
  vec3 normal = texture(uGNormalWorld, uv).xyz;
  return normal;
}

vec3 GetGBufferPosWorld(vec2 uv) {
  vec3 posWorld = texture(uGPosWorld, uv).xyz;
  return posWorld;
}

float GetGBufferuShadow(vec2 uv) {
  float visibility = texture(uGShadow, uv).x;
  return visibility;
}

vec3 GetGBufferDiffuse(vec2 uv) {
  vec3 diffuse = texture(uGDiffuse, uv).xyz;
  diffuse = pow(diffuse, vec3(2.2));
  return diffuse;
}

/*
 * Evaluate diffuse bsdf value.
 *
 * wi, wo are all in world space.
 * uv is in screen space, [0, 1] x [0, 1].
 * return diffuse bsdf
 */
vec3 EvalDiffuse(vec3 wi, vec3 wo, vec2 uv) {
  vec3 L = vec3(0.0);
  vec3 normal = GetGBufferNormalWorld(uv);
  // 贴图获取到的是反照率
  vec3 albedo = GetGBufferDiffuse(uv);
  // 这里的brdf项将cos考虑进去
  L = albedo * INV_PI * max(dot(normalize(normal), normalize(wi)), 0.0);
  return L;
}

/*
 * Evaluate directional light with shadow map
 * uv is in screen space, [0, 1] x [0, 1].
 *
 */
vec3 EvalDirectionalLight(vec2 uv, bool useTexture) {
  if (useTexture){
    return texture(uGDirectLight, uv).xyz;
  }
  
  vec3 Le = vec3(0.0);
  float visibility = GetGBufferuShadow(uv);
  if (visibility <= 0.0) return Le;

  //wo no use
  Le = visibility * uLightRadiance * EvalDiffuse(uLightDir, vec3(0,0,0), uv);

  return Le;
}

#define RAY_STEP_IN_WORLD 0.05
#define MAX_RAY_STEP_COUNT 150
#define SAMPLE_NUM 32
#define MAX_RAY_STEP_COUNT_BVH 3

float GetLevelDepth(int level, vec2 uv){
  float depth = 1000.;
  switch (level){
    case 0:
      depth = GetGBufferDepth(uGDepth, uv); break;
    case 1:
      depth = GetGBufferDepth(uSceneDepthMinmap[0], uv); break;
    case 2:
      depth = GetGBufferDepth(uSceneDepthMinmap[1], uv); break;
    case 3:
      depth = GetGBufferDepth(uSceneDepthMinmap[2], uv); break;
    case 4:
      depth = GetGBufferDepth(uSceneDepthMinmap[3], uv); break;
    case 5:
      depth = GetGBufferDepth(uSceneDepthMinmap[4], uv); break;
    case 6:
      depth = GetGBufferDepth(uSceneDepthMinmap[5], uv); break;
    case 7:
      depth = GetGBufferDepth(uSceneDepthMinmap[6], uv); break;
    case 8:
      depth = GetGBufferDepth(uSceneDepthMinmap[7], uv); break;
    case 9:
      depth = GetGBufferDepth(uSceneDepthMinmap[8], uv); break;
  }
  return depth;
}

bool CheckRayHit(float fromLevel, vec3 screenOri, vec3 screenDir, float limitMul, out vec3 hitPos){
  int checkLevel = int(fromLevel - 1.);
  vec2 oriUV = screenOri.xy;
  vec2 dirUV = screenDir.xy;
  vec2 mapUV = uLastMinmapUVMap[checkLevel];
  vec2 mapOriUV = oriUV * mapUV;
  vec2 mapDirUV = dirUV * mapUV;
  vec3 mapScreenOri = vec3(mapOriUV, screenOri.z);
  vec3 mapScreenDir = vec3(mapDirUV, screenDir.z);
  float offset = 0.;

  vec2 rayMulitpler = vec2(0.);
  vec3 rayScreenPos = mapScreenOri + mapScreenDir * rayMulitpler.y;
  vec2 rayScreenUV = rayScreenPos.xy;

  vec2 invRayDirXYWeight = vec2(1. / abs(mapDirUV.x), 1. / abs(mapDirUV.y));

  vec2 texelUV = vec2(1. / uWidth[checkLevel], 1. / uHeight[checkLevel]);

  for (int i = 0; i < 3 && rayMulitpler.y < limitMul; ++i){
    // 深度测试
    vec3 rayScreenPosN1_P1 = rayScreenPos * 2.0 - 1.0;
    vec3 rayWorldPos = (vScreenToWorld * vec4(rayScreenPosN1_P1, 1.0)).xyz;
    float rayDepth = GetDepth(rayWorldPos.xyz);
    float depth;
    if (checkLevel == 0){
      depth = GetLevelDepth(0, rayScreenUV);
      hitPos = rayWorldPos;
      return true;
    }
    else{
      depth = GetLevelDepth(checkLevel, rayScreenUV);
    }
    
    // 命中
    if (rayDepth - 1e-4 > depth){
      vec3 newScreenOriRay = mapScreenOri + mapScreenDir * rayMulitpler.x;
      // GLSL不支持函数递归, 因此这些算法白写了. 改实在太麻烦, 因此只能够放弃这次提高.
      // if (CheckRayHit(fromLevel - 1., newScreenOriRay, mapScreenDir, rayMulitpler.y - rayMulitpler.x + offset, hitPos))
      //   return true;
    }

    // 左下角uv
    vec2 texelId = floor(rayScreenUV / texelUV);
    vec2 uvInTexel = rayScreenUV - texelId * texelUV;

    vec2 absIncreaseUV = vec2(0.);
    absIncreaseUV.x = dirUV.x > 0. ? texelUV.x - uvInTexel.x : uvInTexel.x;
    absIncreaseUV.y = dirUV.y > 0. ? texelUV.y - uvInTexel.y : uvInTexel.y;

    vec2 texelAddMul = invRayDirXYWeight * absIncreaseUV;
    float minTexelUVAddMul = texelAddMul.x < texelAddMul.y ? texelAddMul.x : texelAddMul.y;
    float maxTexelUVAddMul = texelAddMul.x > texelAddMul.y ? texelAddMul.x : texelAddMul.y;
    // 进行微小的位移，使得不会在边界
    offset = (maxTexelUVAddMul - minTexelUVAddMul) * 0.1;
    minTexelUVAddMul += offset;
    maxTexelUVAddMul -= offset;

    // x保存小的值，y保存大的值
    rayMulitpler += vec2(minTexelUVAddMul, maxTexelUVAddMul);
    rayScreenPos = mapScreenOri + mapScreenDir * rayMulitpler.y;
    rayScreenUV = rayScreenPos.xy;
  }
  return false;
}

bool RayMarch(float level, vec3 ori, vec3 dir, out vec3 hitPos){
  int levelIx = int(level - 1.);
  vec2 texelUV = vec2(1. / uWidth[levelIx + 1], 1. / uHeight[levelIx + 1]);
  float offset = 0.;

  vec3 rayScreenOri = GetRayScreenCoord(ori);
  vec3 rayScreenDir = GetRayScreenCoord(dir);
  // rayScreenDir 在x, y分量的导数
  vec2 invRayDirXYWeight = vec2(1. / abs(rayScreenDir.x), 1. / abs(rayScreenDir.y));

  vec2 rayMulitpler = vec2(0.);
  vec3 rayScreenPos = rayScreenOri + rayScreenDir * rayMulitpler.y;
  vec2 rayScreenUV = rayScreenPos.xy;

  for (int i = 0; i < MAX_RAY_STEP_COUNT_BVH; ++i){
    // 深度测试
    vec3 rayScreenPosN1_P1 = rayScreenPos * 2.0 - 1.0;
    vec3 rayWorldPos = (vScreenToWorld * vec4(rayScreenPosN1_P1, 1.0)).xyz;
    float rayDepth = GetDepth(rayWorldPos.xyz);
    float depth = GetLevelDepth(levelIx + 1, rayScreenUV);
    // 命中
    if (rayDepth - 1e-4 > depth){
      vec3 newScreenOriRay = rayScreenOri + rayScreenDir * rayMulitpler.x;
      if (CheckRayHit(level, newScreenOriRay, rayScreenDir, rayMulitpler.y - rayMulitpler.x + offset, hitPos))
        return true;
    }
    // 未命中(选取光线大的点)
    rayMulitpler.x = rayMulitpler.y;
    // 深度测试 End

    vec2 texelId = floor(rayScreenUV / texelUV);
    vec2 uvInTexel = rayScreenUV - texelId * texelUV;

    vec2 absIncreaseUV = vec2(0.);
    absIncreaseUV.x = rayScreenDir.x > 0. ? texelUV.x - uvInTexel.x : uvInTexel.x;
    absIncreaseUV.y = rayScreenDir.y > 0. ? texelUV.y - uvInTexel.y : uvInTexel.y;

    vec2 texelAddMul = invRayDirXYWeight * absIncreaseUV;
    float minTexelUVAddMul = texelAddMul.x < texelAddMul.y ? texelAddMul.x : texelAddMul.y;
    float maxTexelUVAddMul = texelAddMul.x > texelAddMul.y ? texelAddMul.x : texelAddMul.y;
    // 进行微小的位移，使得不会在边界
    offset = (maxTexelUVAddMul - minTexelUVAddMul) * 0.05;
    minTexelUVAddMul += offset;
    maxTexelUVAddMul -= offset;

    // x保存小的值，y保存大的值
    rayMulitpler += vec2(minTexelUVAddMul, maxTexelUVAddMul);
    rayScreenPos = rayScreenOri + rayScreenDir * rayMulitpler.y;
    rayScreenUV = rayScreenPos.xy;
  }

  return false;
}

bool RayMarchNoBVH(vec3 ori, vec3 dir, out vec3 hitPos) {
  vec3 test_point;
  for (int i = 1; i <= MAX_RAY_STEP_COUNT; ++i){
    test_point = ori + dir * float(i) * RAY_STEP_IN_WORLD;

    vec2 uv = GetScreenCoordinate(test_point);
    float depthInTexture = GetGBufferDepth(uGDepth, uv);
    float depth = (vWorldToScreen * vec4(test_point, 1.0)).w;

    if (depth - depthInTexture >= 1e-3){
      hitPos = test_point;
      return true;
    }
  }
  
  return false;
}

// specular test
vec3 EvalSpecularIndirect(vec2 uv){
  vec3 posWorld = GetGBufferPosWorld(uv);
  vec3 normal = GetGBufferNormalWorld(uv);

  vec3 wo = normalize(uCameraPos - posWorld);
  vec3 projectH = normal * (dot(wo, normal));
  vec3 specularWi = normalize(2.0 * projectH - wo);
  
  vec3 hitPos;
  if (RayMarchNoBVH(posWorld, specularWi, hitPos)){
    vec2 hitUV = GetScreenCoordinate(hitPos);
    return EvalDirectionalLight(hitUV, true);
  }
  return vec3(0.0);
}

// diffuse item
vec3 EvalDiffuseIndirect(inout float s, vec2 uv, vec3 normal){
  vec3 indirectColor = vec3(0.0);
  float pdf;
  vec3 t, b;
  vec3 hitPos;
  vec3 randomDir;
  vec3 worldDir;

  for (int i = 0; i < SAMPLE_NUM; ++i){
    // 局部上半球的随机方向
    randomDir = SampleHemisphereUniform(s, pdf);
    // randomDir = SampleHemisphereCos(s, pdf);
    // 获取世界法向量的两个切线向量
    LocalBasis(normal, t, b);
    // 随机局部方向向量转换到世界坐标
    worldDir = normalize(randomDir.x * t + randomDir.y * b + randomDir.z * normal);
    if (RayMarchNoBVH(vPosWorld.xyz, worldDir, hitPos)){
      vec2 hitUV = GetScreenCoordinate(hitPos);
      vec3 Li = EvalDirectionalLight(hitUV, true);
      indirectColor += Li / pdf * EvalDiffuse(worldDir, vec3(0.0), uv);
    }
  }

  indirectColor /= float(SAMPLE_NUM);
  return indirectColor;
}

void main() {
  float s = InitRand(gl_FragCoord.xy);

  vec2 uv = GetScreenCoordinate(vPosWorld.xyz);
  vec3 normal = GetGBufferNormalWorld(uv);

  vec3 directColor = EvalDirectionalLight(uv, true);
  
  vec3 indirectColor = EvalDiffuseIndirect(s, uv, normal);
  // vec3 indirectColor = EvalSpecularIndirect(uv);

  oFragColor = vec4(pow(directColor + indirectColor, vec3(1.0/2.2)), 1.0);
  
  // test code
  // oFragColor = vec4(pow(indirectColor, vec3(1.0/2.2)), 1.0);
  // oFragColor = vec4(pow(directColor, vec3(1.0/2.2)), 1.0);
  // oFragColor = vec4(vec3(GetGBufferDepth(uGDepth, uv)) / 10., 1.0);
  // oFragColor = vec4(texture(uSceneDepthMinmap[8], uv).xyz / 10., 1.0);
  // oFragColor = vec4(texture(uGLightDepth, uv).xyz, 1.0);
}
