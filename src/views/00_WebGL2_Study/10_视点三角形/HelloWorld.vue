<script setup>
import { onMounted } from "vue";
import VSHADER_SOURCE from "./vertexShader.vs";
import FSHADER_SOURCE from "./fragmentShader.fs";
import * as twgl from "twgl.js";
import { Pane } from "tweakpane";
import { mat4, vec3 } from "gl-matrix";

// 参数面板
let pane = new Pane();
let params = {
  x: 0,
  y: 0,
  theta: 0,
  scaleX: 1,
  scaleY: 1,
  eye: {
    x: 0,
    y: 0,
    z: 0.25,
  },
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
pane.addBinding(params, "eye", {
  x: {
    min: -1,
    max: 1,
    step: 0.1,
  },
  y: {
    min: -1,
    max: 1,
    step: 0.1,
  },
  z: {
    min: -1,
    max: 1,
    step: 0.1,
  },
  label: "视点",
});

let arrays = {
  a_Position: {
    numComponents: 2,
    data: [-0.5, -0.5, 0.5, -0.5, 0.5, 0.5],
  },
};
// 模型变换矩阵
const modelMatrix = mat4.create();
const viewMatrix = mat4.create();
let uniform = {
  u_ModelMatrix: modelMatrix,
  u_ViewMatrix: viewMatrix,
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
  // 创建缓冲区信息
  const bufferInfo = twgl.createBufferInfoFromArrays(gl, arrays);
  // 设置视点
  var eye = vec3.fromValues(0, 0, 0.25);
  // 目标点
  var center = vec3.fromValues(0, 0, 0);
  // 上方向
  var up = vec3.fromValues(0, 1, 0);
  // 视图矩阵
  mat4.lookAt(viewMatrix, eye, center, up);
  uniform.u_ViewMatrix = viewMatrix;
  // 设置attribute
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  // 设置uniform
  twgl.setUniforms(programInfo, uniform);
  // 清空颜色缓冲区
  gl.clear(gl.COLOR_BUFFER_BIT);
  // 绘制图形
  twgl.drawBufferInfo(gl, bufferInfo, gl.TRIANGLES);

  // 监听面板变化
  pane.on("change", () => {
    mat4.translate(modelMatrix, mat4.create(), [params.x, params.y, 0]);
    mat4.rotateZ(modelMatrix, modelMatrix, (params.theta * Math.PI) / 180);
    mat4.scale(modelMatrix, modelMatrix, [params.scaleX, params.scaleY, 1]);
    mat4.lookAt(
      viewMatrix,
      vec3.fromValues(params.eye.x, params.eye.y, params.eye.z),
      center,
      up
    );
    uniform.u_ModelMatrix = modelMatrix;
    twgl.setUniforms(programInfo, uniform);
    gl.clear(gl.COLOR_BUFFER_BIT);
    twgl.drawBufferInfo(gl, bufferInfo, gl.TRIANGLE_FAN);
  });
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
