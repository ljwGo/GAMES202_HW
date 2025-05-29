class SSRMaterial extends Material {
    constructor(diffuseMap, specularMap, light, camera, vertexShader, fragmentShader) {
        let lightIntensity = light.mat.GetIntensity();
        let lightVP = light.CalcLightVP();
        let lightDir = light.CalcShadingDirection();

        super({
            'uMaxMinmapLevel': { type: '1f', value: camera.minValueMinmapFBOs.length },
            'uWidth[0]' : {type: '1f', value: window.screen.width},
            'uWidth[1]' : {type: '1f', value: camera.minValueMinmapFBOs[0].width},
            'uWidth[2]' : {type: '1f', value: camera.minValueMinmapFBOs[1].width},
            'uWidth[3]' : {type: '1f', value: camera.minValueMinmapFBOs[2].width},
            'uWidth[4]' : {type: '1f', value: camera.minValueMinmapFBOs[3].width},
            'uWidth[5]' : {type: '1f', value: camera.minValueMinmapFBOs[4].width},
            'uWidth[6]' : {type: '1f', value: camera.minValueMinmapFBOs[5].width},
            'uWidth[7]' : {type: '1f', value: camera.minValueMinmapFBOs[6].width},
            'uWidth[8]' : {type: '1f', value: camera.minValueMinmapFBOs[7].width},
            'uWidth[9]' : {type: '1f', value: camera.minValueMinmapFBOs[8].width},
            'uHeight[0]' : {type: '1f', value: window.screen.height},
            'uHeight[1]' : {type: '1f', value: camera.minValueMinmapFBOs[0].height},
            'uHeight[2]' : {type: '1f', value: camera.minValueMinmapFBOs[1].height},
            'uHeight[3]' : {type: '1f', value: camera.minValueMinmapFBOs[2].height},
            'uHeight[4]' : {type: '1f', value: camera.minValueMinmapFBOs[3].height},
            'uHeight[5]' : {type: '1f', value: camera.minValueMinmapFBOs[4].height},
            'uHeight[6]' : {type: '1f', value: camera.minValueMinmapFBOs[5].height},
            'uHeight[7]' : {type: '1f', value: camera.minValueMinmapFBOs[6].height},
            'uHeight[8]' : {type: '1f', value: camera.minValueMinmapFBOs[7].height},
            'uHeight[9]' : {type: '1f', value: camera.minValueMinmapFBOs[8].height},
            'uLightRadiance': { type: '3fv', value: lightIntensity },
            'uLightDir': { type: '3fv', value: lightDir },

            'uGDiffuse': { type: 'texture', value: camera.fbo.textures[0] },
            'uGDepth': { type: 'texture', value: camera.fbo.textures[1] },
            'uGNormalWorld': { type: 'texture', value: camera.fbo.textures[2] },
            'uGShadow': { type: 'texture', value: camera.fbo.textures[3] },
            'uGPosWorld': { type: 'texture', value: camera.fbo.textures[4] },
            'uGDirectLight' : { type: 'texture', value: camera.fbo.textures[5]},
            // 'uGLightDepth' : {type: 'texture', value: light.fbo.textures[0]},
            'uSceneDepthMinmap[0]' : {type: 'texture', value: camera.minValueMinmapFBOs[0].textures[0]},
            'uSceneDepthMinmap[1]' : {type: 'texture', value: camera.minValueMinmapFBOs[1].textures[0]},
            'uSceneDepthMinmap[2]' : {type: 'texture', value: camera.minValueMinmapFBOs[2].textures[0]},
            'uSceneDepthMinmap[3]' : {type: 'texture', value: camera.minValueMinmapFBOs[3].textures[0]},
            'uSceneDepthMinmap[4]' : {type: 'texture', value: camera.minValueMinmapFBOs[4].textures[0]},
            'uSceneDepthMinmap[5]' : {type: 'texture', value: camera.minValueMinmapFBOs[5].textures[0]},
            'uSceneDepthMinmap[6]' : {type: 'texture', value: camera.minValueMinmapFBOs[6].textures[0]},
            'uSceneDepthMinmap[7]' : {type: 'texture', value: camera.minValueMinmapFBOs[7].textures[0]},
            'uSceneDepthMinmap[8]' : {type: 'texture', value: camera.minValueMinmapFBOs[8].textures[0]},
            
            'uLastMinmapUVMap[0]' : {type: '2fv', value: camera.minValueMinmapFBOs[0].lastMinmapUVMap},
            'uLastMinmapUVMap[1]' : {type: '2fv', value: camera.minValueMinmapFBOs[1].lastMinmapUVMap},
            'uLastMinmapUVMap[2]' : {type: '2fv', value: camera.minValueMinmapFBOs[2].lastMinmapUVMap},
            'uLastMinmapUVMap[3]' : {type: '2fv', value: camera.minValueMinmapFBOs[3].lastMinmapUVMap},
            'uLastMinmapUVMap[4]' : {type: '2fv', value: camera.minValueMinmapFBOs[4].lastMinmapUVMap},
            'uLastMinmapUVMap[5]' : {type: '2fv', value: camera.minValueMinmapFBOs[5].lastMinmapUVMap},
            'uLastMinmapUVMap[6]' : {type: '2fv', value: camera.minValueMinmapFBOs[6].lastMinmapUVMap},
            'uLastMinmapUVMap[7]' : {type: '2fv', value: camera.minValueMinmapFBOs[7].lastMinmapUVMap},
            'uLastMinmapUVMap[8]' : {type: '2fv', value: camera.minValueMinmapFBOs[8].lastMinmapUVMap},
        }, [], vertexShader, fragmentShader);
    }
}

async function buildSSRMaterial(diffuseMap, specularMap, light, camera,  vertexPath, fragmentPath) {
    let vertexShader = await getShaderString(vertexPath);
    let fragmentShader = await getShaderString(fragmentPath);

    return new SSRMaterial(diffuseMap, specularMap, light, camera, vertexShader, fragmentShader);
}