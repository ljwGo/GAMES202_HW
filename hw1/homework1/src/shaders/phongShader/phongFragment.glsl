#ifdef GL_ES
precision mediump float;
#endif

#define FRUSTUM_SIZE 200.0  // frustumSize是正交投影矩阵的长宽(假设长宽相同); 
#define SHADOW_MAP_SIZE 2048.0  // shadowMapSize阴影贴图的分辨率(假设长宽相同)
#define FILTER_RADIUS 10.0  // 意思是想要查询目标位置周围以10像素为半径的圆的区域
#define LIGHT_WIDTH 5.0
#define NEAR_PLANE_DIS 0.01
#define LIGHT_WIDTH_IN_UV (LIGHT_WIDTH / FRUSTUM_SIZE * 0.5)
#define NEAR_PLANE_DIS_IN_UV (NEAR_PLANE_DIS / FRUSTUM_SIZE * 0.5)

// Phong related variables
uniform sampler2D uSampler;
uniform vec3 uKd;
uniform vec3 uKs;
uniform vec3 uLightPos;
uniform vec3 uCameraPos;
uniform vec3 uLightIntensity;
uniform vec3 uLightDir;

varying highp vec2 vTextureCoord;
varying highp vec3 vFragPos;
varying highp vec3 vNormal;

// Shadow map related variables
#define NUM_SAMPLES 20
#define BLOCKER_SEARCH_NUM_SAMPLES NUM_SAMPLES
#define PCF_NUM_SAMPLES NUM_SAMPLES
#define NUM_RINGS 10

#define EPS 1e-3
#define PI 3.141592653589793
#define PI2 6.283185307179586

uniform sampler2D uShadowMap;

varying vec4 vPositionFromLight;

highp float rand_1to1(highp float x ) { 
  // -1 -1
  return fract(sin(x)*10000.0);
}

highp float rand_2to1(vec2 uv ) { 
  // 0 - 1
	const highp float a = 12.9898, b = 78.233, c = 43758.5453;
	highp float dt = dot( uv.xy, vec2( a,b ) ), sn = mod( dt, PI );
	return fract(sin(sn) * c);
}

float unpack(vec4 rgbaDepth) {
    const vec4 bitShift = vec4(1.0, 1.0/255.0, 1.0/(255.0*255.0), 1.0/(255.0*255.0*255.0));
    return dot(rgbaDepth, bitShift);
}

vec2 poissonDisk[NUM_SAMPLES];

// 有关泊松圆盘分布的情况，参考文档中的codepen链接
void poissonDiskSamples( const in vec2 randomSeed ) {

  float ANGLE_STEP = PI2 * float( NUM_RINGS ) / float( NUM_SAMPLES );
  float INV_NUM_SAMPLES = 1.0 / float( NUM_SAMPLES );

  float angle = rand_2to1( randomSeed ) * PI2;
  float radius = INV_NUM_SAMPLES;
  float radiusStep = radius;

  for( int i = 0; i < NUM_SAMPLES; i ++ ) {
    poissonDisk[i] = vec2( cos( angle ), sin( angle ) ) * pow( radius, 0.75 );
    radius += radiusStep;
    angle += ANGLE_STEP;
  }
}

void uniformDiskSamples( const in vec2 randomSeed ) {

  float randNum = rand_2to1(randomSeed);
  float sampleX = rand_1to1( randNum ) ;
  float sampleY = rand_1to1( sampleX ) ;

  float angle = sampleX * PI2;
  float radius = sqrt(sampleY);

  for( int i = 0; i < NUM_SAMPLES; i ++ ) {
    poissonDisk[i] = vec2( radius * cos(angle) , radius * sin(angle)  );

    sampleX = rand_1to1( sampleY ) ;
    sampleY = rand_1to1( sampleX ) ;

    angle = sampleX * PI2;
    radius = sqrt(sampleY);
  }
}

float getShadowBias(float frustumSize, float shadowMapSize, float filterRadiusInPixel, float coefficient){
  float edgeLen = frustumSize / shadowMapSize * 0.5;
  vec3 normLightDir = normalize(uLightDir);
  vec3 normNormal =  normalize(vNormal);
  float angleTan = 1.0 - dot(normLightDir, normNormal);
  float pixelRange = (1.0 + ceil(filterRadiusInPixel));
  return coefficient * pixelRange * edgeLen * angleTan;
}

float findBlocker( sampler2D shadowMap,  vec2 uv, float zReceiver ) {
	float depthSum = 0.;
  int blockerCount = 0;

  // 利用相似三角形，确定blocker Search的宽度
  float filterRadiusInUV = (zReceiver - NEAR_PLANE_DIS_IN_UV) / zReceiver * LIGHT_WIDTH_IN_UV;
  float filterRadius = filterRadiusInUV * SHADOW_MAP_SIZE;
  uniformDiskSamples(uv);

  for (int i = 0; i < NUM_SAMPLES; ++i){
    vec2 offset = poissonDisk[i] * filterRadiusInUV;

    float neighbor_depth = unpack(texture2D(shadowMap, uv + offset));
    float bias = getShadowBias(FRUSTUM_SIZE, SHADOW_MAP_SIZE, FILTER_RADIUS, 0.15);
    
    if (zReceiver - bias > neighbor_depth + EPS){
      depthSum += neighbor_depth;
      blockerCount++;
    }
  }

  if (blockerCount == 0){
    return -1.0;
  }
  return depthSum / float(blockerCount);  // 返回平均深度
}

float PCF(sampler2D shadowMap, vec4 coords, float filterRadius) {
  float filterRadiusInUV = filterRadius / SHADOW_MAP_SIZE;  // 转换到阴影贴图的uv坐标中

  poissonDiskSamples(coords.xy);

  int visibleCount = 0;
  for (int i = 0; i < NUM_SAMPLES; ++i){
    vec2 offset = poissonDisk[i] * filterRadiusInUV;  // 这里对半径为1的泊松圆盘进行缩放

    float depth = unpack(texture2D(shadowMap, coords.xy + offset));  // 查询周围的点
    float cur_depth = coords.z;
    float bias = getShadowBias(FRUSTUM_SIZE, SHADOW_MAP_SIZE, FILTER_RADIUS, 0.15);
    
    if (cur_depth - bias < depth + EPS){
      visibleCount++;
    }
  }

  return float(visibleCount) / float(NUM_SAMPLES);
}

float PCSS(sampler2D shadowMap, vec4 coords){

  // STEP 1: avgblocker depth
  float avgDepth = findBlocker(shadowMap, coords.xy, coords.z);
  if (avgDepth == -1.0){
    return 1.0;
  }

  // STEP 2: penumbra size
  float filterRadiusInWord = LIGHT_WIDTH / avgDepth * (coords.z - avgDepth);
  float filterRadiusInUV = filterRadiusInWord / FRUSTUM_SIZE;
  float filterRadius = filterRadiusInUV * SHADOW_MAP_SIZE;
  // STEP 3: filtering
  return PCF(shadowMap, coords, filterRadius);
  // return avgDepth;
  // return unpack(texture2D(shadowMap, coords.xy));  //debug
}

float useShadowMap(sampler2D shadowMap, vec4 shadowCoord){
  // 查询到的深度
  float depth = unpack(texture2D(shadowMap, shadowCoord.xy));
  float cur_depth = shadowCoord.z;
  float bias = getShadowBias(FRUSTUM_SIZE, SHADOW_MAP_SIZE, 1.0, 0.5);
  if(cur_depth - bias < depth + EPS){
    return 1.0;
  }
  else{
    return 0.0;
  }
}

vec3 blinnPhong() {
  vec3 color = texture2D(uSampler, vTextureCoord).rgb;
  color = pow(color, vec3(2.2));

  vec3 ambient = 0.05 * color;

  vec3 lightDir = normalize(uLightPos);
  vec3 normal = normalize(vNormal);
  float diff = max(dot(lightDir, normal), 0.0);
  vec3 light_atten_coff =
      uLightIntensity / pow(length(uLightPos - vFragPos), 2.0);
  vec3 diffuse = diff * light_atten_coff * color;

  vec3 viewDir = normalize(uCameraPos - vFragPos);
  vec3 halfDir = normalize((lightDir + viewDir));
  float spec = pow(max(dot(halfDir, normal), 0.0), 32.0);
  vec3 specular = uKs * light_atten_coff * spec;

  vec3 radiance = (ambient + diffuse + specular);
  vec3 phongColor = pow(radiance, vec3(1.0 / 2.2));
  return phongColor;
}

void main(void) {
  //vPositionFromLight为光源空间下投影的裁剪坐标，除以w结果为NDC坐标
  vec3 shadowCoord = vPositionFromLight.xyz / vPositionFromLight.w;
  //把[-1,1]的NDC坐标转换为[0,1]的坐标
  shadowCoord.xyz = (shadowCoord.xyz + 1.0) / 2.0;

  float visibility;
  // visibility = useShadowMap(uShadowMap, vec4(shadowCoord, 1.0));
  // visibility = PCF(uShadowMap, vec4(shadowCoord, 1.0), FILTER_RADIUS);
  visibility = PCSS(uShadowMap, vec4(shadowCoord, 1.0));

  vec3 phongColor = blinnPhong();

  gl_FragColor = vec4(phongColor * visibility, 1.0);
  //gl_FragColor = vec4(phongColor, 1.0);
  // gl_FragColor = vec4(visibility, visibility, visibility, 1.0);  //debug
}