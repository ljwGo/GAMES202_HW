class PRTMaterial extends Material{
  constructor(Kd, vs, fs){
    super({
      'uKd': {type:'3fv', value: Kd},
      // 可以用这种方式给数组赋值
      // 'uPrecomputeL[0]': {type: 'matrix3fv', value: uPrecomputeL[0]},
      // 'uPrecomputeL[1]': {type: 'matrix3fv', value: uPrecomputeL[1]},
      // 'uPrecomputeL[2]': {type: 'matrix3fv', value: uPrecomputeL[2]},
      // 'uPrecomputeLR': {type:'matrix3fv', value: uPrecomputeL[0]},
      // 'uPrecomputeLG': {type:'matrix3fv', value: uPrecomputeL[1]},
      // 'uPrecomputeLB': {type:'matrix3fv', value: uPrecomputeL[2]},
      // 希望能够实时更新(在WebGLRenderer.js中)
      'uPrecomputeLR': {type:'UpdateInRealTime', value: null},
      'uPrecomputeLG': {type:'UpdateInRealTime', value: null},
      'uPrecomputeLB': {type:'UpdateInRealTime', value: null},
      // 让环境光支持旋转
      'uMoveWithCamera' : {type:'UpdateInRealTime', value: null},
      // uPrecomputeLT的赋值在MeshRender中
    }, ['aPrecomputeLT'], vs, fs, null);
  }
  
}

async function buildPRTMaterial(Kd, vertexPath, fragmentPath) {

  let vertexShader = await getShaderString(vertexPath);
  let fragmentShader = await getShaderString(fragmentPath);

  return new PRTMaterial(Kd, vertexShader, fragmentShader);

}