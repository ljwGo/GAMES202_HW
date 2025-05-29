#ifdef GL_ES
precision mediump float;
#endif

varying highp vec3 vVertexColor;

void main(){
  gl_FragColor = vec4(vVertexColor, 1.0);
}