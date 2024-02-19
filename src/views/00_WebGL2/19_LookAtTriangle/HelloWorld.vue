<!--
 * @Description: 
 * @Date: 2023-08-09 17:37:42
 * @LastEditTime: 2023-12-15 10:53:45
-->
<script setup>
import { onMounted } from 'vue';
import { Pane } from 'tweakpane'
import { mat4, vec3 } from 'gl-matrix'
import VSHADER_SOURCE from './vertexShader.vs'
import FSHADER_SOURCE from './fragmentShader.fs'

function initVertexBuffers(gl) {
  var vertices = new Float32Array([
    // 顶点坐标和颜色rgb
    0.0, 0.5, -0.4, 0.4, 1.0, 0.4, // The back green one
    -0.5, -0.5, -0.4, 0.4, 1.0, 0.4,
    0.5, -0.5, -0.4, 1.0, 0.4, 0.4,

    0.5, 0.4, -0.2, 1.0, 0.4, 0.4, // The middle yellow one
    -0.5, 0.4, -0.2, 1.0, 1.0, 0.4,
    0.0, -0.6, -0.2, 1.0, 1.0, 0.4,

    0.0, 0.5, 0.0, 0.4, 0.4, 1.0,  // The front blue one 
    -0.5, -0.5, 0.0, 0.4, 0.4, 1.0,
    0.5, -0.5, 0.0, 1.0, 0.4, 0.4,
  ]);
  var n = 9; //点的个数

  //创建缓冲区对象
  var vertexBuffer = gl.createBuffer();
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

  return n;
}


onMounted(() => {
  /** @type {HTMLCanvasElement} */
  var canvas = document.querySelector('#canvas')
  var gl = canvas.getContext("webgl")
  // 初始化shaders
  initShaders(gl, VSHADER_SOURCE, FSHADER_SOURCE)

  // 创建视图
  var viewMatrix = mat4.create()
  var eye = vec3.fromValues(0.2, 0.25, 0.25)
  var center = vec3.fromValues(0, 0, 0)
  var up = vec3.fromValues(0, 1, 0)
  mat4.lookAt(viewMatrix, eye, center, up)

  // 视图矩阵变量地址
  var u_ViewMatrix = gl.getUniformLocation(gl.program, 'u_ViewMatrix')
  gl.uniformMatrix4fv(u_ViewMatrix, false, viewMatrix)

  var n = initVertexBuffers(gl)
  gl.clearColor(0.0, 0.0, 0.0, 1.0)
  gl.clear(gl.COLOR_BUFFER_BIT)
  gl.drawArrays(gl.TRIANGLES, 0, n)


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
