<script setup>
import { onMounted } from "vue";
import VSHADER_SOURCE from "./vertexShader.vs";
import FSHADER_SOURCE from "./fragmentShader.fs";
import * as twgl from "twgl.js";

let arrays = {
  a_Position: {
    numComponents: 2,
    data: [],
  },
};
let uniform = {
  u_Color: [],
};

function click(ev, gl, programInfo) {
  const canvas = document.getElementById("canvas");
  var x = ev.clientX; //鼠标点击处的X坐标
  var y = ev.clientY; //鼠标点击处的Y坐标
  var rect = ev.target.getBoundingClientRect();
  x = (x - rect.left - canvas.height / 2) / (canvas.height / 2);
  y = (canvas.width / 2 - (y - rect.top)) / (canvas.width / 2);
  arrays.a_Position.data.push(x, y); // 加入点坐标数组
  uniform.u_Color.length = 0;
  uniform.u_Color.push(Math.abs(x), Math.abs(y), 1.0);
  const bufferInfo = twgl.createBufferInfoFromArrays(gl, arrays);
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  twgl.setUniforms(programInfo, uniform);
  gl.clear(gl.COLOR_BUFFER_BIT);
  twgl.drawBufferInfo(gl, bufferInfo, gl.POINTS);
}

onMounted(() => {
  const gl = document.getElementById("canvas").getContext("webgl2");
  const programInfo = twgl.createProgramInfo(gl, [
    VSHADER_SOURCE,
    FSHADER_SOURCE,
  ]);
  twgl.resizeCanvasToDisplaySize(gl.canvas);
  gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
  gl.useProgram(programInfo.program);
  gl.clearColor(1.0, 0.0, 0.0, 0.3);
  gl.clear(gl.COLOR_BUFFER_BIT);
  document.getElementById("canvas").onclick = function (e) {
    click(e, gl, programInfo);
  };
});
</script>
<template>
  <div id="content">
    <canvas id="canvas" width="800" height="800"></canvas>
  </div>
</template>
<style lang="scss" scoped>
#content {
  box-sizing: border-box;
  width: 100vw;
  height: 100vh;
  display: flex;
  align-items: center;
  background-color: transparent;
  padding: 10px;
  #canvas {
    border: 1px solid green;
  }
}
</style>
