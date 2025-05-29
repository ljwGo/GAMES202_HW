class WebGLRenderer {
    meshes = [];
    shadowMeshes = [];
    lights = [];

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

    // 旋转环境光的球谐系数(固定2阶)
    rotateSHCoef(originSHCoef, r3x3, r5x5){
        let rSHCoef = Array(9);
        rSHCoef[0] = originSHCoef[0];

        let shCoef1Degree = originSHCoef.slice(1, 5);
        shCoef1Degree[3] = 0;
        let shCoef1DegreeR = math.multiply(shCoef1Degree, r3x3);

        let shCoef2Degree = originSHCoef.slice(4, 9);
        let shCoef2DegreeR = math.multiply(shCoef2Degree, r5x5);

        for (let i = 1; i < 4; ++i){
            rSHCoef[i] = shCoef1DegreeR.get([i - 1]);
        }

        for (let i = 4; i < 9; ++i){
            rSHCoef[i] = shCoef2DegreeR.get([i - 4]);
        }

        return rSHCoef;
    }

    calcSHRotate3x3(r){
        // 求1阶上的3个球谐函数
        let n1 = [1, 0, 0, 0];
        let n2 = [0, 1, 0, 0];
        let n3 = [0, 0, 1, 0];

        // 原本函数投影到球谐函数上来求得系数是要通过积分的.
        // 但如果假设投影函数在n1方向有值,并假设值为1,其它方向值都为0.
        // 那么就不需要积分,系数c = f(n1)B(n1) = B(n1)
        let p1 = SHEval(n1[0], n1[1], n1[2], 3).slice(1, 5);
        let p2 = SHEval(n2[0], n2[1], n2[2], 3).slice(1, 5);
        let p3 = SHEval(n3[0], n3[1], n3[2], 3).slice(1, 5);
        p1[3] = 0; p2[3] = 0; p3[3] = 0;

        // 未旋转前的sh系数(行向量)
        let a = math.matrix([p1, p2, p3, [0, 0, 0, 1]]);
    
        // 取逆
        a = math.inv(a);
        
        // 旋转上面3个方向向量
        let n1_r = math.multiply(n1, r);
        let n2_r = math.multiply(n2, r);
        let n3_r = math.multiply(n3, r);
        
        // 旋转后的系数, 注意这里返回的是矩阵, 需要使用get获取数据
        let p1_r = SHEval(n1_r.get([0]), n1_r.get([1]), n1_r.get([2]), 3).slice(1, 5);
        let p2_r = SHEval(n2_r.get([0]), n2_r.get([1]), n2_r.get([2]), 3).slice(1, 5);
        let p3_r = SHEval(n3_r.get([0]), n3_r.get([1]), n3_r.get([2]), 3).slice(1, 5);
        p1_r[3] = 0; p2_r[3] = 0; p3_r[3] = 0;

        let a_r = math.matrix([p1_r, p2_r, p3_r, [0, 0, 0, 1]]);

        let rm_1Degree = math.multiply(a, a_r);

        return rm_1Degree;
    }

    calcSHRotate5x5(r){
        let coef = 1.0 / math.sqrt(2.0);
        let n1 = [1, 0, 0, 0];
        let n2 = [0, 1, 0, 0];
        let n3 = [0, coef, coef, 0];
        let n4 = [coef, 0, coef, 0];
        let n5 = [coef, coef, 0, 0];

        let p1 = SHEval(n1[0], n1[1], n1[2], 3).slice(4, 9);
        let p2 = SHEval(n2[0], n2[1], n2[2], 3).slice(4, 9);
        let p3 = SHEval(n3[0], n3[1], n3[2], 3).slice(4, 9);
        let p4 = SHEval(n4[0], n4[1], n4[2], 3).slice(4, 9);
        let p5 = SHEval(n5[0], n5[1], n5[2], 3).slice(4, 9);

        let a = math.matrix([p1, p2, p3, p4, p5]);

        a = math.inv(a);

        let n1_r = math.multiply(n1, r);
        let n2_r = math.multiply(n2, r);
        let n3_r = math.multiply(n3, r);
        let n4_r = math.multiply(n4, r);
        let n5_r = math.multiply(n5, r);

        let p1_r = SHEval(n1_r.get([0]), n1_r.get([1]), n1_r.get([2]), 3).slice(4, 9);
        let p2_r = SHEval(n2_r.get([0]), n2_r.get([1]), n2_r.get([2]), 3).slice(4, 9);
        let p3_r = SHEval(n3_r.get([0]), n3_r.get([1]), n3_r.get([2]), 3).slice(4, 9);
        let p4_r = SHEval(n4_r.get([0]), n4_r.get([1]), n4_r.get([2]), 3).slice(4, 9);
        let p5_r = SHEval(n5_r.get([0]), n5_r.get([1]), n5_r.get([2]), 3).slice(4, 9);

        let a_r = math.matrix([p1_r, p2_r, p3_r, p4_r, p5_r]);

        let rm_2Degree = math.multiply(a, a_r);

        return rm_2Degree;
    }

    render() {
        const gl = this.gl;

        gl.clearColor(0.0, 0.0, 0.0, 1.0); // Clear to black, fully opaque
        gl.clearDepth(1.0); // Clear everything
        gl.enable(gl.DEPTH_TEST); // Enable depth testing
        gl.depthFunc(gl.LEQUAL); // Near things obscure far things

        console.assert(this.lights.length != 0, "No light");
        console.assert(this.lights.length == 1, "Multiple lights");

        const timer = Date.now() * 0.0001;

        for (let l = 0; l < this.lights.length; l++) {
            // Draw light
            this.lights[l].meshRender.mesh.transform.translate = this.lights[l].entity.lightPos;
            this.lights[l].meshRender.draw(this.camera);

            // Shadow pass
            if (this.lights[l].entity.hasShadowMap == true) {
                for (let i = 0; i < this.shadowMeshes.length; i++) {
                    this.shadowMeshes[i].draw(this.camera);
                }
            }

            // Camera pass
            for (let i = 0; i < this.meshes.length; i++) {
                this.gl.useProgram(this.meshes[i].shader.program.glShaderProgram);
                this.gl.uniform3fv(this.meshes[i].shader.program.uniforms.uLightPos, this.lights[l].entity.lightPos);

                for (let k in this.meshes[i].material.uniforms) {

                    // Bonus - Fast Spherical Harmonic Rotation
                    //let precomputeL_RGBMat3 = getRotationPrecomputeL(precomputeL[guiParams.envmapId], cameraModelMatrix);
                    
                    // math.config({
                    //     matrix: 'Array'
                    // });
                    let cameraModelMatrix = mat4.create();
                    mat4.fromRotation(cameraModelMatrix, timer, [0, 1, 0]);

                    // 注意, 球谐旋转使用的矩阵是模型自身旋转的矩阵; 而不是环境光旋转矩阵
                    mat4.transpose(cameraModelMatrix, cameraModelMatrix);
                    // console.log("mat4: " + rotateMatrix);
                    // 稍微修改了mat4Matrix2mathMatrix的代码, 使得mat4到math矩阵的转换不会进行转置
                    let r = mat4Matrix2mathMatrix(cameraModelMatrix);
                    // console.log("math: " + r);

                    // 进行转置, 使得旋转矩阵旋转的是行向量(原本是列向量)
                    // 这时候应该是右乘旋转矩阵M
                    r = math.transpose(r);
                    let r3x3 = this.calcSHRotate3x3(r);
                    let r5x5 = this.calcSHRotate5x5(r);

                    let precomputeLR = precomputeL[guiParams.envmapId][0];
                    let precomputeLG = precomputeL[guiParams.envmapId][1];
                    let precomputeLB = precomputeL[guiParams.envmapId][2];

                    precomputeLR = this.rotateSHCoef(precomputeLR, r3x3, r5x5);
                    precomputeLG = this.rotateSHCoef(precomputeLG, r3x3, r5x5);
                    precomputeLB = this.rotateSHCoef(precomputeLB, r3x3, r5x5);
                    
                    // math.config({
                    //     matrix: 'Matrix'
                    // });
                    if (k == 'uMoveWithCamera') { // The rotation of the skybox
                        gl.uniformMatrix4fv(
                            this.meshes[i].shader.program.uniforms[k],
                            false,
                            cameraModelMatrix);
                    }

                    if (k == 'uPrecomputeLR'){
                        gl.uniformMatrix3fv(
                            this.meshes[i].shader.program.uniforms[k],
                            false,
                            precomputeLR,
                        );
                    }

                    if (k == 'uPrecomputeLG'){
                        gl.uniformMatrix3fv(
                            this.meshes[i].shader.program.uniforms[k],
                            false,
                            precomputeLG
                        );
                    }

                    if (k == 'uPrecomputeLB'){
                        gl.uniformMatrix3fv(
                            this.meshes[i].shader.program.uniforms[k],
                            false,
                            precomputeLB
                        );
                    }
                    
                }

                this.meshes[i].draw(this.camera);
            }
        }

    }
}