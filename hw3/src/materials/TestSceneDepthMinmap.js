class TestSceneDepthMinmap extends Material{
  constructor(camera, vertexShader, fragmentShader) {
    super({
      'uGDepth': { type: 'texture', value: camera.fbo.textures[1] },
      'uSceneDepthMinmap01' : {type: 'texture', value: camera.minValueMinmapFBOs[0].textures[0]},
      'uSceneDepthMinmap02' : {type: 'texture', value: camera.minValueMinmapFBOs[1].textures[0]},
      'uSceneDepthMinmap03' : {type: 'texture', value: camera.minValueMinmapFBOs[2].textures[0]},
      'uSceneDepthMinmap04' : {type: 'texture', value: camera.minValueMinmapFBOs[3].textures[0]},
      'uSceneDepthMinmap05' : {type: 'texture', value: camera.minValueMinmapFBOs[4].textures[0]},
      'uSceneDepthMinmap06' : {type: 'texture', value: camera.minValueMinmapFBOs[5].textures[0]},
      'uSceneDepthMinmap07' : {type: 'texture', value: camera.minValueMinmapFBOs[6].textures[0]},
      'uSceneDepthMinmap08' : {type: 'texture', value: camera.minValueMinmapFBOs[7].textures[0]},
      'uSceneDepthMinmap09' : {type: 'texture', value: camera.minValueMinmapFBOs[8].textures[0]},
    }, [], vertexShader, fragmentShader, null);
  }
}

async function buildTestSceneDepthMinmap(camera, vertexPath, fragmentPath) {
  let vertexShader = await getShaderString(vertexPath);
  let fragmentShader = await getShaderString(fragmentPath);

  return new TestSceneDepthMinmap(camera, vertexShader, fragmentShader);
}