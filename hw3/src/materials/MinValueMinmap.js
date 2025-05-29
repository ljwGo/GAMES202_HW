class MinValueMinmap extends Material {
  constructor(vertexShader, fragmentShader) {
      super({
          'uLevel' : {type: '1f', value: null},
          'uWidth' : {type: '1f', value: null},
          'uHeight' : {type: '1f', value: null},
          'uSceneDepthMinmap': {type: 'texture', value: null},
      }, [], vertexShader, fragmentShader, null);
  }
}

async function buildMinValueMinmapMaterial (vertexPath, fragmentPath) {
  let vertexShader = await getShaderString(vertexPath);
  let fragmentShader = await getShaderString(fragmentPath);

  return new MinValueMinmap(vertexShader, fragmentShader);
}