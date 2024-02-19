<script setup>
import { onMounted } from "vue";
import VSHADER_SOURCE from "./vertexShader.vs";
import FSHADER_SOURCE from "./fragmentShader.fs";
import * as twgl from "twgl.js";
import { Pane } from "tweakpane";
import { mat4 } from "gl-matrix";

// 参数面板
let pane = new Pane();
let params = {
  x: 0,
  y: 0,
  theta: 0,
  scaleX: 1,
  scaleY: 1,
};
pane.addBinding(params, "x", {
  min: -0.5,
  max: 0.5,
  step: 0.01,
  label: "x轴平移",
});
pane.addBinding(params, "y", {
  min: -0.5,
  max: 0.5,
  step: 0.01,
  label: "y轴平移",
});
pane.addBinding(params, "theta", {
  min: -180,
  max: 180,
  step: 1,
  label: "旋转角度",
});
pane.addBinding(params, "scaleX", {
  min: 0.5,
  max: 2,
  step: 0.1,
  label: "X轴缩放",
});
pane.addBinding(params, "scaleY", {
  min: 0.5,
  max: 2,
  step: 0.1,
  label: "Y轴缩放",
});

let arrays = {
  a_Position: {
    numComponents: 2,
    data: [],
  },
  a_Color: {
    numComponents: 2,
    data: [],
  },
};

// 模型矩阵
const modelMatrix = twgl.m4.create();
console.log(modelMatrix);
// 模型变换矩阵
const modelMatrix1 = mat4.create();
console.log(modelMatrix1);
let uniform = {
  u_ModelMatrix: modelMatrix,
};

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
  arrays.a_Position.data.push(-0.5, -0.5, 0.5, -0.5, 0.5, 0.5, -0.5, 0.5);
  arrays.a_Color.data.push(0.5, 0.5, 0.2, 0.3, 1.0, 1.0, 0.2, 0.8);

  const bufferInfo = twgl.createBufferInfoFromArrays(gl, arrays);
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  twgl.drawBufferInfo(gl, bufferInfo, gl.TRIANGLE_FAN);
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
