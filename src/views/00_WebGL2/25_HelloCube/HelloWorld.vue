<!--
 * @Description: 
 * @Date: 2023-08-09 17:37:42
 * @LastEditTime: 2023-08-28 16:52:39
-->
<script setup>
import { onMounted } from 'vue';
import { Pane } from 'tweakpane'
import { mat4, vec3 } from 'gl-matrix'
import VSHADER_SOURCE from './vertexShader.vs'
import FSHADER_SOURCE from './fragmentShader.fs'

function initVertexBuffers(gl) {
  var vertices = new Float32Array([
    // 顶点坐标和颜色
    1.0, 1.0, 1.0, 1.0, 1.0, 1.0,  // v0 White
    -1.0, 1.0, 1.0, 1.0, 0.0, 1.0,  // v1 Magenta
    -1.0, -1.0, 1.0, 1.0, 0.0, 0.0,  // v2 Red
    1.0, -1.0, 1.0, 1.0, 1.0, 0.0,  // v3 Yellow
    1.0, -1.0, -1.0, 0.0, 1.0, 0.0,  // v4 Green
    1.0, 1.0, -1.0, 0.0, 1.0, 1.0,  // v5 Cyan
    -1.0, 1.0, -1.0, 0.0, 0.0, 1.0,  // v6 Blue
    -1.0, -1.0, -1.0, 0.0, 0.0, 0.0   // v7 Black
  ]);

  // Indices of the vertices
  var indices = new Uint8Array([
    0, 1, 2, 0, 2, 3,    // front
    0, 3, 4, 0, 4, 5,    // right
    0, 5, 6, 0, 6, 1,    // up
    1, 6, 7, 1, 7, 2,    // left
    7, 4, 3, 7, 3, 2,    // down
    4, 7, 6, 4, 6, 5     // back
  ]);

  // 创建顶点缓冲区对象
  var vertexBuffer = gl.createBuffer();
  // 创建索引缓冲区对象
  var indexBuffer = gl.createBuffer();
  if (!vertexBuffer) {
    console.log("Failed to create thie buffer object");
    return -1;
  }
  var FSIZE = vertices.BYTES_PER_ELEMENT

  //将缓冲区对象保存到目标上
  gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
  //向缓存对象写入数据
  gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);
  var a_Position = gl.getAttribLocation(gl.program, 'a_Position');
  if (a_Position < 0) {
    console.log("Failed to get the storage location of a_Position");
    return -1;
  }
  //将缓冲区对象分配给a_Postion变量
  gl.vertexAttribPointer(a_Position, 3, gl.FLOAT, false, FSIZE * 6, 0);
  //连接a_Postion变量与分配给它的缓冲区对象
  gl.enableVertexAttribArray(a_Position);

  var a_Color = gl.getAttribLocation(gl.program, 'a_Color')
  gl.vertexAttribPointer(a_Color, 3, gl.FLOAT, false, FSIZE * 6, FSIZE * 3)
  //连接a_Postion变量与分配给它的缓冲区对象
  gl.enableVertexAttribArray(a_Color);

  // 将顶点索引写入缓冲区对象
  gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer)
  gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW)
  return indices.length

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


  mat4.fromTranslation(modelMatrix, [0, 0, 0])
  mat4.lookAt(viewMatrix, [3, 3, 7], [0, 0, 0], [0, 1, 0])
  mat4.perspective(projMatrix, 30 * Math.PI / 180, canvas.width / canvas.height, 1, 100)


  // 模型矩阵变量地址
  var u_ModelMatrix = gl.getUniformLocation(gl.program, 'u_ModelMatrix')
  // 视图矩阵变量地址
  var u_ViewMatrix = gl.getUniformLocation(gl.program, 'u_ViewMatrix')
  // 投影矩阵变量地址
  var u_ProjMatrix = gl.getUniformLocation(gl.program, 'u_ProjMatrix')


  // 将模型矩阵传入顶点着色器
  gl.uniformMatrix4fv(u_ModelMatrix, false, modelMatrix)
  // 将视图矩阵传入顶点着色器
  gl.uniformMatrix4fv(u_ViewMatrix, false, viewMatrix)
  // 将投影矩阵传入顶点着色器
  gl.uniformMatrix4fv(u_ProjMatrix, false, projMatrix)

  gl.clearColor(0.0, 0.0, 0.0, 1.0)
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT)
  // 绘制三角形
  gl.drawElements(gl.TRIANGLES, n, gl.UNSIGNED_BYTE, 0);

  // // Enable the polygon offset function
  // gl.enable(gl.POLYGON_OFFSET_FILL);
  // // Draw the triangles
  // gl.drawArrays(gl.TRIANGLES, 0, n / 2);   // The green triangle
  // gl.polygonOffset(1.0, 1.0);          // Set the polygon offset
  // gl.drawArrays(gl.TRIANGLES, n / 2, n / 2); // The yellow triangle






  // 重新绘制
  function draw(gl, projMatrix) {
    gl.uniformMatrix4fv(u_ProjMatrix, false, projMatrix)
    gl.clear(gl.COLOR_BUFFER_BIT)
    gl.drawArrays(gl.TRIANGLES, 0, n)
  }




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
