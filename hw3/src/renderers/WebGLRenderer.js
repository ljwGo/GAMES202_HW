class WebGLRenderer {
    meshes = [];
    shadowMeshes = [];
    bufferMeshes = [];
    lights = [];
    minValueMinmapMeshes = [];

    constructor(gl, camera) {
        this.gl = gl;
        this.camera = camera;
    }

    addLight(light) {
        this.lights.push({
            entity: light,
            meshRender: new MeshRender(this.gl, light.mesh, light.mat)
        });
    }
    addMeshRender(mesh) { this.meshes.push(mesh); }
    addShadowMeshRender(mesh) { this.shadowMeshes.push(mesh); }
    addBufferMeshRender(mesh) { this.bufferMeshes.push(mesh); }
    addMinValueMinmapMeshRender(mesh) { this.minValueMinmapMeshes.push(mesh); }

    render() {
        console.assert(this.lights.length != 0, "No light");
        console.assert(this.lights.length == 1, "Multiple lights");
        var light = this.lights[0];

        const gl = this.gl;
        // bug02: 为了适应自己的min value minmap算法, 背景色必须是黑色
        // gl.clearColor(0.1, 0.2, 0.1, 1.0);
        gl.clearColor(0., 0., 0., 1.0);
        gl.clearDepth(1.0);
        gl.enable(gl.DEPTH_TEST);
        gl.depthFunc(gl.LEQUAL);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

        // Update parameters
        let lightVP = light.entity.CalcLightVP();
        let lightDir = light.entity.CalcShadingDirection();
        let updatedParamters = {
            "uLightVP": lightVP,
            "uLightDir": lightDir,
        };

        // Draw light
        light.meshRender.mesh.transform.translate = light.entity.lightPos;
        light.meshRender.draw(this.camera, null, updatedParamters);

        // Shadow pass(将shadow map绘制到light.entity.fbo上)
        gl.bindFramebuffer(gl.FRAMEBUFFER, light.entity.fbo);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
        for (let i = 0; i < this.shadowMeshes.length; i++) {
            this.shadowMeshes[i].draw(this.camera, light.entity.fbo, updatedParamters);
            // this.shadowMeshes[i].draw(this.camera);
        }
        // return;

        // Buffer pass
        gl.bindFramebuffer(gl.FRAMEBUFFER, this.camera.fbo);
        gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
        for (let i = 0; i < this.bufferMeshes.length; i++) {
            this.bufferMeshes[i].draw(this.camera, this.camera.fbo, updatedParamters);
            // this.bufferMeshes[i].draw(this.camera);
        }
        // return

        // Edit start
        let updateParams2 = {
            'uLevel' : null,
            'uWidth' : null,
            'uHeight' : null,
            'uSceneDepthMinmap' : null,
        }
        // Scene depth min-value min-map pass
        for (let i = 0; i < this.minValueMinmapMeshes.length; i++) {
            // j是生成的目标minmap的层级号
            for (let j = 1; j <= this.camera.minValueMinmapFBOs.length; j++) {
                gl.bindFramebuffer(gl.FRAMEBUFFER, this.camera.minValueMinmapFBOs[j - 1]);
                // bug01: 这里不能够加gl.COLOR_BUFFER_BIT, 因为这会导致正方体变成半透明
                gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);  
                // gl.clear(gl.DEPTH_BUFFER_BIT);
                updateParams2['uLevel'] = j;
                if (j == 1){
                    // camera.fbo.textures[1]是最初的场景深度贴图
                    updateParams2['uSceneDepthMinmap'] = this.camera.fbo.textures[1];
                }
                else{
                    updateParams2['uSceneDepthMinmap'] = this.camera.minValueMinmapFBOs[j - 2].textures[0];
                }
                updateParams2['uWidth'] = this.camera.minValueMinmapFBOs[j - 1].width;
                updateParams2['uHeight'] = this.camera.minValueMinmapFBOs[j - 1].height;

                this.minValueMinmapMeshes[i].draw(this.camera, this.camera.minValueMinmapFBOs[j - 1], updateParams2);
            }
        }
        // Edit end

        // Camera pass
        for (let i = 0; i < this.meshes.length; i++) {
            this.meshes[i].draw(this.camera, null, updatedParamters);
        }
    }
}