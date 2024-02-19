<!--
 * @Description: 
 * @Date: 2023-08-09 17:37:42
 * @LastEditTime: 2023-08-28 16:52:54
-->
<script setup>
import { onMounted } from 'vue';
import { Pane } from 'tweakpane'
import { mat4, vec3 } from 'gl-matrix'
import VSHADER_SOURCE from './vertexShader.vs'
import FSHADER_SOURCE from './fragmentShader.fs'



function initVertexBuffers(gl) {
  // Create a cube
  //    v6----- v5
  //   /|      /|
  //  v1------v0|
  //  | |     | |
  //  | |v7---|-|v4
  //  |/      |/
  //  v2------v3

  var vertices = new Float32Array([   // Vertex coordinates
    1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, 1.0,  // v0-v1-v2-v3 front
    1.0, 1.0, 1.0, 1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0,  // v0-v3-v4-v5 right
    1.0, 1.0, 1.0, 1.0, 1.0, -1.0, -1.0, 1.0, -1.0, -1.0, 1.0, 1.0,  // v0-v5-v6-v1 up
    -1.0, 1.0, 1.0, -1.0, 1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, 1.0,  // v1-v6-v7-v2 left
    -1.0, -1.0, -1.0, 1.0, -1.0, -1.0, 1.0, -1.0, 1.0, -1.0, -1.0, 1.0,  // v7-v4-v3-v2 down
    1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0   // v4-v7-v6-v5 back
  ]);

  var colors = new Float32Array([    // Colors
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,     // v0-v1-v2-v3 front
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,     // v0-v3-v4-v5 right
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,     // v0-v5-v6-v1 up
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,     // v1-v6-v7-v2 left
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0,     // v7-v4-v3-v2 down
    1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0　    // v4-v7-v6-v5 back
  ]);

  var indices = new Uint8Array([       // Indices of the vertices
    0, 1, 2, 0, 2, 3,    // front
    4, 5, 6, 4, 6, 7,    // right
    8, 9, 10, 8, 10, 11,    // up
    12, 13, 14, 12, 14, 15,    // left
    16, 17, 18, 16, 18, 19,    // down
    20, 21, 22, 20, 22, 23     // back
  ]);

  var normals = new Float32Array([    // Normal
    0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0,  // v0-v1-v2-v3 front
    1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0,  // v0-v3-v4-v5 right
    0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0,  // v0-v5-v6-v1 up
    -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0,  // v1-v6-v7-v2 left
    0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0,  // v7-v4-v3-v2 down
    0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0, 0.0, 0.0, -1.0   // v4-v7-v6-v5 back
  ]);

  initArrayBuffer(gl, vertices, 3, gl.FLOAT, 'a_Position')
  initArrayBuffer(gl, colors, 3, gl.FLOAT, 'a_Color')
  initArrayBuffer(gl, normals, 3, gl.FLOAT, 'a_Normal')

  // 创建索引缓冲区对象
  var indexBuffer = gl.createBuffer();
  // 将顶点索引写入缓冲区对象
  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer)
  gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW)
  return indices.length

}

function initArrayBuffer(gl, data, num, type, attribute) {
  var buffer = gl.createBuffer()
  gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
  gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW)
  var a_attribute = gl.getAttribLocation(gl.program, attribute)
  gl.vertexAttribPointer(a_attribute, num, type, false, 0, 0)
  // 开启顶点attribute
  gl.enableVertexAttribArray(a_attribute)
}


onMounted(() => {
  /** @type {HTMLCanvasElement} */
  var canvas = document.querySelector('#canvas')
  var gl = canvas.getContext("webgl")
  gl.enable(gl.DEPTH_TEST)
  // 初始化shaders
  initShaders(gl, VSHADER_SOURCE, FSHADER_SOURCE)
  // 初始化顶点缓冲区
  var n = initVertexBuffers(gl)

  // 创建模型矩阵
  var modelMatrix = mat4.create()
  // 创建视图矩阵
  var viewMatrix = mat4.create()
  // 创建投影矩阵
  var projMatrix = mat4.create()
  // 创建法向量变化矩阵
  var normalMatrix = mat4.create()
  // 创建入射光颜色
  var lightColor = vec3.fromValues(1.0, 1.0, 1.0)
  // 创建入射光位置
  var lightPosition = vec3.fromValues(0, 3.0, 4.0)
  // 创建环境光颜色
  var ambientColor = vec3.fromValues(0.2, 0.2, 0.4)


  mat4.fromTranslation(modelMatrix, [0, 0, 0])
  mat4.lookAt(viewMatrix, [3, 3, 7], [0, 0, 0], [0, 1, 0])
  mat4.perspective(projMatrix, 30 * Math.PI / 180, canvas.width / canvas.height, 1, 100)
  mat4.invert(normalMatrix, modelMatrix)
  mat4.transpose(normalMatrix, normalMatrix)

  // 模型矩阵变量地址
  var u_ModelMatrix = gl.getUniformLocation(gl.program, 'u_ModelMatrix')
  // 视图矩阵变量地址
  var u_ViewMatrix = gl.getUniformLocation(gl.program, 'u_ViewMatrix')
  // 投影矩阵变量地址
  var u_ProjMatrix = gl.getUniformLocation(gl.program, 'u_ProjMatrix')
  // 法向量变化矩阵变量地址
  var u_NormalMatrix = gl.getUniformLocation(gl.program, 'u_NormalMatrix')
  // 入射光颜色变量地址
  var u_LightColor = gl.getUniformLocation(gl.program, 'u_LightColor')
  // 入射光方向变量地址
  var u_LightPosition = gl.getUniformLocation(gl.program, 'u_LightPosition')
  // 环境光方向变量地址
  var u_AmbientLight = gl.getUniformLocation(gl.program, 'u_AmbientLight')


  // 将模型矩阵传入顶点着色器
  gl.uniformMatrix4fv(u_ModelMatrix, false, modelMatrix)
  // 将视图矩阵传入顶点着色器
  gl.uniformMatrix4fv(u_ViewMatrix, false, viewMatrix)
  // 将投影矩阵传入顶点着色器
  gl.uniformMatrix4fv(u_ProjMatrix, false, projMatrix)
  // 将法向量变换矩阵传入顶点着色器
  gl.uniformMatrix4fv(u_NormalMatrix, false, normalMatrix)
  // 将入射光颜色传入顶点着色器
  gl.uniform3fv(u_LightColor, lightColor)
  // 将入射光方向传入顶点着色器
  gl.uniform3fv(u_LightPosition, lightPosition)
  // 将环境光颜色传入顶点着色器
  gl.uniform3fv(u_AmbientLight, ambientColor)

  gl.clearColor(0.0, 0.0, 0.0, 1.0)
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
  // 绘制三角形
  gl.drawElements(gl.TRIANGLES, n, gl.UNSIGNED_BYTE, 0);

  var tick = function () {
    mat4.rotateY(modelMatrix, modelMatrix, Math.PI / 180 / 10)
    gl.uniformMatrix4fv(u_ModelMatrix, false, modelMatrix)

    mat4.invert(normalMatrix, modelMatrix)
    mat4.transpose(normalMatrix, normalMatrix)
    gl.uniformMatrix4fv(u_NormalMatrix, false, normalMatrix)

    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
    // 绘制三角形
    gl.drawElements(gl.TRIANGLES, n, gl.UNSIGNED_BYTE, 0);
    requestAnimationFrame(tick)
  }

  tick()






})

</script>

<template>
  <div id="hello">
    <canvas id="canvas" width="800" height="800"></canvas>
  </div>
</template>

<style scoped>
.read-the-docs {
  color: #888;
}
</style>
