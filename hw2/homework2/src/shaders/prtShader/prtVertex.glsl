#define INV_PI 0.3183098

attribute mat3 aPrecomputeLT;
attribute vec3 aVertexPosition;
attribute vec3 aNormalPosition;
attribute vec2 aTextureCoord;

// uniform mat3 uPrecomputeL[3];
uniform mat3 uPrecomputeLR;
uniform mat3 uPrecomputeLG;
uniform mat3 uPrecomputeLB;
uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
uniform mat4 uMoveWithCamera;
uniform vec3 uKd;

varying highp vec3 vVertexColor;

// 用于将线性空间的图片进行伽马矫正
vec3 toSRGB(vec3 color) {
    vec3 result;
    for (int i=0; i<3; ++i) {
        float value = color[i];

        if (value <= 0.0031308)
            result[i] = 12.92 * value;
        else
            result[i] = (1.0 + 0.055)
                * pow(value, 1.0/2.4) -  0.055;
    }

    return result;
}

void main(){
  vec3 lt_0 = aPrecomputeLT[0];
  vec3 lt_1 = aPrecomputeLT[1];
  vec3 lt_2 = aPrecomputeLT[2];

  vec3 lr_0 = uPrecomputeLR[0];
  vec3 lr_1 = uPrecomputeLR[1];
  vec3 lr_2 = uPrecomputeLR[2];

  vec3 lg_0 = uPrecomputeLG[0];
  vec3 lg_1 = uPrecomputeLG[1];
  vec3 lg_2 = uPrecomputeLG[2];

  vec3 lb_0 = uPrecomputeLB[0];
  vec3 lb_1 = uPrecomputeLB[1];
  vec3 lb_2 = uPrecomputeLB[2];

  vVertexColor = vec3(dot(lt_0, lr_0) + dot(lt_1, lr_1) + dot(lt_2, lr_2),
    dot(lt_0, lg_0) + dot(lt_1, lg_1) + dot(lt_2, lg_2),
    dot(lt_0, lb_0) + dot(lt_1, lb_1) + dot(lt_2, lb_2));

  // 针对漫反射材质的render equation, 最后乘以albedo / pi
  vVertexColor = vVertexColor * uKd * INV_PI;
  vVertexColor = toSRGB(vVertexColor);

  gl_Position = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(aVertexPosition, 1.0);
}