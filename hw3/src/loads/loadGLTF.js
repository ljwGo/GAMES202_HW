function loadGLTF(renderer, path, name, materialName) {

	const manager = new THREE.LoadingManager();
	manager.onProgress = function (item, loaded, total) {
		console.log(item, loaded, total);
	};

	function onProgress(xhr) {
		if (xhr.lengthComputable) {
			const percentComplete = xhr.loaded / xhr.total * 100;
			console.log('model ' + Math.round(percentComplete, 2) + '% downloaded');
		}
	}
	function onError() { }

	new THREE.GLTFLoader(manager)
		.setPath(path)
		// gltf是一种包含多种资源的文件。包含纹理，网格等。相当于一个清单文件。
		// 网格顶点数据保存在bin二进制文件中
		.load(name + '.gltf', function (gltf) {
			gltf.scene.traverse(function (child) {

				if (child.isMesh) {
					let geo = child.geometry;
					let mat;
					if (Array.isArray(child.material)) mat = child.material[0];
					else mat = child.material;
					gltfTransform = setTransform(child.position.x, child.position.y, child.position.z,
						child.scale.x, child.scale.y, child.scale.z,
						child.rotation.x, child.rotation.y, child.rotation.z);
					var indices = Array.from({ length: geo.attributes.position.count }, (v, k) => k);
					let mesh = new Mesh({ name: 'aVertexPosition', array: geo.attributes.position.array },
						{ name: 'aNormalPosition', array: geo.attributes.normal.array },
						{ name: 'aTextureCoord', array: geo.attributes.uv.array },
						geo.index.array, gltfTransform);

					let diffuseMap = new Texture();
					if (mat.map != null) {
						diffuseMap.CreateImageTexture(renderer.gl, mat.map.image);
					}
					else {
						diffuseMap.CreateConstantTexture(renderer.gl, mat.color.toArray(), true);
					}
					let specularMap = new Texture();
					specularMap.CreateConstantTexture(renderer.gl, [0,0,0]);
					let normalMap = new Texture();
					if (mat.normalMap != null) {
						normalMap.CreateImageTexture(renderer.gl, mat.normalMap.image);
					}
					else {
						normalMap.CreateConstantTexture(renderer.gl, [0.5, 0.5, 1], false);
					}

					let light = renderer.lights[0].entity;
					switch (materialName) {
						case 'SSRMaterial':
							// test for min-value scene depth minmap
							// material = buildTestSceneDepthMinmap(renderer.camera, "./src/shaders/minValueMinmap/testVertex.glsl", "./src/shaders/minValueMinmap/testFragment.glsl");
							material = buildSSRMaterial(diffuseMap, specularMap, light, renderer.camera, "./src/shaders/ssrShader/ssrVertex.glsl", "./src/shaders/ssrShader/ssrFragment.glsl");
							shadowMaterial = buildShadowMaterial(light, "./src/shaders/shadowShader/shadowVertex.glsl", "./src/shaders/shadowShader/shadowFragment.glsl");
							bufferMaterial = buildGbufferMaterial(diffuseMap, normalMap, light, renderer.camera, "./src/shaders/gbufferShader/gbufferVertex.glsl", "./src/shaders/gbufferShader/gbufferFragment.glsl");
							// Edit start
							minValueMinmapMaterial = buildMinValueMinmapMaterial("./src/shaders/minValueMinmap/minValueVertex.glsl", "./src/shaders/minValueMinmap/minValueFragment.glsl");
							// Edit end
							break;
					}

					// Edit start
					let mask = Mesh.screenMask(setTransform(0, 0, 0, 1, 1, 1));
					// Edit end

					// 添加要渲染的内容
					material.then((data) => {
						// test for min-value scene depth minmap
						// let meshRender = new MeshRender(renderer.gl, mask, data);
						let meshRender = new MeshRender(renderer.gl, mesh, data);
						renderer.addMeshRender(meshRender);
					});
					shadowMaterial.then((data) => {
						let shadowMeshRender = new MeshRender(renderer.gl, mesh, data);
						renderer.addShadowMeshRender(shadowMeshRender);
					});
					bufferMaterial.then((data) => {
						let bufferMeshRender = new MeshRender(renderer.gl, mesh, data);
						renderer.addBufferMeshRender(bufferMeshRender);
					});
					// Edit start
					minValueMinmapMaterial.then((data) => {
						let minValueMinmapMeshRender = new MeshRender(renderer.gl, mask, data);
						renderer.addMinValueMinmapMeshRender(minValueMinmapMeshRender);
					})
					// Edit end
				}

			});
		});
}
