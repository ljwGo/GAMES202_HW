class DirectionalLight {

    constructor(lightIntensity, lightColor, lightPos, focalPoint, lightUp, hasShadowMap, gl) {
        this.mesh = Mesh.cube(setTransform(0, 0, 0, 0.2, 0.2, 0.2, 0));
        this.mat = new EmissiveMaterial(lightIntensity, lightColor);
        // focalPoint is array. 注意focalPoint面相的点，不是朝向向量
        this.lightPos = lightPos;
        this.focalPoint = focalPoint;
        this.lightUp = lightUp

        this.hasShadowMap = hasShadowMap;
        this.fbo = new FBO(gl);
        if (!this.fbo) {
            // console.log("无法设置帧缓冲区对象");
            return;
        }
    }

    CalcLightMVP(translate, scale) {
        //create return unit matrix
        let lightMVP = mat4.create();
        let modelMatrix = mat4.create();
        let viewMatrix = mat4.create();
        let projectionMatrix = mat4.create();

        //vec4 is vector4 class
        // // console.log(vec4);

        //vec4 has cross method and vec3 hasn't cross method
        // // console.log(vec3.cross);

        //model transform
        // // console.log("translate: " + translate);
        // // console.log("scale: " + scale);

        // Model transform
        // 先平移后放缩会改变平移项；先缩放后平移不会改变平移项s
        modelMatrix[12] = translate[0];
        modelMatrix[13] = translate[1];
        modelMatrix[14] = translate[2];
        // console.log("translate: " + modelMatrix);
        modelMatrix[0] = scale[0];
        modelMatrix[5] = scale[1];
        modelMatrix[10] = scale[2];
        modelMatrix[15] = 1;
        // console.log("modelMatrix: " + modelMatrix);
        // View transform
        let lookAt = vec3.create();
        vec3.sub(lookAt, this.focalPoint, this.lightPos);
        vec3.normalize(lookAt, lookAt);
        // console.log("lookAt: " + lookAt);
        let up = this.GetVerticalVector(lookAt);
        // console.log("up: " + up);

        // 现在求出了lookAt向量，还缺一个光的上方向量。这个向量必须垂直lookAt，提供的lightUp向量不满足条件
        viewMatrix[12] = this.lightPos[0];
        viewMatrix[13] = this.lightPos[1];
        viewMatrix[14] = this.lightPos[2];
        viewMatrix[15] = 1;
        viewMatrix[4] = up[0];
        viewMatrix[5] = up[1];
        viewMatrix[6] = up[2];
        viewMatrix[8] = -lookAt[0];
        viewMatrix[9] = -lookAt[1];
        viewMatrix[10] = -lookAt[2];
        //Simulate cross algorithm
        let xAxis = [
            lookAt[1] * up[2] - lookAt[2] * up[1],
            lookAt[2] * up[0] - lookAt[0] * up[2],
            lookAt[0] * up[1] - lookAt[1] * up[0]
        ]
        viewMatrix[0] = xAxis[0];
        viewMatrix[1] = xAxis[1];
        viewMatrix[2] = xAxis[2];
        mat4.invert(viewMatrix, viewMatrix);
        // console.log("viewMatrix: " + viewMatrix);

        // Projection transform(Orth)
        let l = -100;
        let r = 100;
        let n = 0.01;
        let f = 200;
        let t = 100;
        let b = -100;

        projectionMatrix[0] = 2/(r-l)
        projectionMatrix[5] = 2/(t-b)
        projectionMatrix[10] = 2/(f-n)
        projectionMatrix[10] = -projectionMatrix[10]
        projectionMatrix[12] = -(r+l)/(r-l)
        projectionMatrix[13] = -(t+b)/(t-b)
        // projectionMatrix[14] = -(n+f)/(n-f)
        projectionMatrix[14] = -(n+f)/(f-n)
        // console.log("projectionMatrix: " + projectionMatrix);

        // 用第二个操作数(第三参数)右乘第一个操作数(第二参数)
        mat4.multiply(lightMVP, projectionMatrix, viewMatrix);  
        mat4.multiply(lightMVP, lightMVP, modelMatrix);  

        // console.log("lightMVP: " + lightMVP);
        return lightMVP;
    }

    // CalcLightMVP(translate, scale) {  
    //     let lightMVP = mat4.create();  
    //     let modelMatrix = mat4.create();  
    //     let viewMatrix = mat4.create();  
    //     let projectionMatrix = mat4.create();  
    
    //     //Edit Start  
    
    //     // Model transform  
    //     mat4.translate(modelMatrix, modelMatrix, translate)
    //     // console.log("translate: " + modelMatrix);
    //     mat4.scale(modelMatrix, modelMatrix, scale)
    //     // console.log("modelMatrix: " + modelMatrix);
    
    //     // View transform  
    //     mat4.lookAt(viewMatrix, this.lightPos, this.focalPoint, this.lightUp)  
    //     // console.log("viewMatrix: " + viewMatrix);

    //     // Projection transform  
    //     var r = 100;  
    //     var l = -r;  
    //     var t = 100;  
    //     var b = -t;  
    
    //     var n = 0.01;  
    //     var f = 200;  
    
    //     mat4.ortho(projectionMatrix, l, r, b, t, n, f);  
    //     // console.log("projectionMatrix: " + projectionMatrix);

    //     mat4.multiply(lightMVP, projectionMatrix, viewMatrix);  
    //     mat4.multiply(lightMVP, lightMVP, modelMatrix);  
    //     // console.log("lightMVP: " + lightMVP);
    //     return lightMVP;  
    // }

    GetVerticalVector(vector3){
        let assistVec = this.GetRandomVector(vector3);
        let normVec = vec3.create();
        vec3.normalize(normVec, vector3);

        // 辅助向量在原来向量上的投影
        let ratio = vec3.dot(assistVec, normVec);
        let projectionVec = vec3.create();
        vec3.scale(projectionVec, normVec, ratio);

        // 利用直角三角形的集合关系，求出垂直的向量
        let verticalVec = vec3.create()
        vec3.sub(verticalVec, projectionVec, assistVec)  // 垂直向量 = 投影向量 - 辅助向量
        vec3.normalize(verticalVec, verticalVec);
        vec3.scale(verticalVec, verticalVec, -1);
        return verticalVec;
    }

    GetRandomVector(vector3){
        let vec01 = vec3.create();
        let vec02 = vec3.create();
        vec01[0] = 1;
        vec01[1] = 0;
        vec01[2] = 0;

        vec02[0] = 0;
        vec02[1] = 1;
        vec02[2] = 0;

        let normVec = vec3.create();
        // to confirm random vector is not parallel to vector3
        vec3.normalize(normVec, vector3);
        let cos01 = vec3.dot(vec01, normVec);
        if (Math.abs(cos01) < 1) {
            return vec01;
        }

        let cos02 = vec3.dot(vec02, normVec);
        if (Math.abs(cos02) < 1) {
            return vec02;
        }
    }
}
