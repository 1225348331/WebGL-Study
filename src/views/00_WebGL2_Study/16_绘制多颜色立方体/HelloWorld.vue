<script setup>
import { onMounted } from "vue";
import VSHADER_SOURCE from "./vertexShader.vs";
import FSHADER_SOURCE from "./fragmentShader.fs";
import * as twgl from "twgl.js";
import { Pane } from "tweakpane";
import { mat3, mat4, vec3 } from "gl-matrix";

// 参数面板
let pane = new Pane();
let params = {
  x: 0,
  y: 0,
  theta: 0,
  scaleX: 1,
  scaleY: 1,
  near: 1.0,
  far: 20.0,
  eye: {
    x: 1.3,
    y: 1.6,
    z: 5,
  },
};
pane.addBinding(params, "x", {
  min: -1.0,
  max: 1.0,
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
    min: -100,
    max: 100,
    step: 0.1,
  },
  y: {
    min: -100,
    max: 100,
    step: 0.1,
  },
  z: {
    min: -100,
    max: 100,
    step: 0.1,
  },
  label: "视点",
});
pane.addBinding(params, "near", {
  min: 1.0,
  max: 10.0,
  step: 1.0,
  label: "近裁剪面",
});
pane.addBinding(params, "far", {
  min: 20.0,
  max: 30.0,
  step: 1.0,
  label: "远裁剪面",
});

let arrays = {
  a_Position: {
    numComponents: 3,
    data: [
      1,
      1,
      -1,
      1,
      1,
      1,
      1,
      -1,
      1,
      1,
      -1,
      -1, // v0-v1-v2-v3
      -1,
      1,
      1,
      -1,
      1,
      -1,
      -1,
      -1,
      -1,
      -1,
      -1,
      1, // v0-v1-v2-v3
      -1,
      1,
      1,
      1,
      1,
      1,
      1,
      1,
      -1,
      -1,
      1,
      -1, // v0-v1-v2-v3
      -1,
      -1,
      -1,
      1,
      -1,
      -1,
      1,
      -1,
      1,
      -1,
      -1,
      1, // v0-v1-v2-v3
      1,
      1,
      1,
      -1,
      1,
      1,
      -1,
      -1,
      1,
      1,
      -1,
      1, // v0-v1-v2-v3
      -1,
      1,
      -1,
      1,
      1,
      -1,
      1,
      -1,
      -1,
      -1,
      -1,
      -1,
    ],
  },
  indices: [
    0, 1, 2, 0, 2, 3, 4, 5, 6, 4, 6, 7, 8, 9, 10, 8, 10, 11, 12, 13, 14, 12, 14,
    15, 16, 17, 18, 16, 18, 19, 20, 21, 22, 20, 22, 23,
  ],
  a_Color: {
    numComponents: 3,
    data: [
      0.4,
      0.4,
      1.0,
      0.4,
      0.4,
      1.0,
      0.4,
      0.4,
      1.0,
      0.4,
      0.4,
      1.0, // v0-v1-v2-v3 front(blue)
      0.4,
      1.0,
      0.4,
      0.4,
      1.0,
      0.4,
      0.4,
      1.0,
      0.4,
      0.4,
      1.0,
      0.4, // v0-v3-v4-v5 right(green)
      1.0,
      0.4,
      0.4,
      1.0,
      0.4,
      0.4,
      1.0,
      0.4,
      0.4,
      1.0,
      0.4,
      0.4, // v0-v5-v6-v1 up(red)
      1.0,
      1.0,
      0.4,
      1.0,
      1.0,
      0.4,
      1.0,
      1.0,
      0.4,
      1.0,
      1.0,
      0.4, // v1-v6-v7-v2 left
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0,
      1.0, // v7-v4-v3-v2 down
      0.4,
      1.0,
      1.0,
      0.4,
      1.0,
      1.0,
      0.4,
      1.0,
      1.0,
      0.4,
      1.0,
      1.0, // v4-v7-v6-v5 back
    ],
  },
};

// 模型变换矩阵
const modelMatrix = mat4.create();
const viewMatrix = mat4.create();
const projMatrix = mat4.create();

let uniform = {
  u_ModelMatrix: modelMatrix,
  u_ProjMatrix: projMatrix,
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
  // 设置attribute
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  var eye = vec3.fromValues(params.eye.x, params.eye.y, params.eye.z);
  var center = vec3.fromValues(0, 0, 0);
  var up = vec3.fromValues(0, 1, 0);
  // 视图矩阵
  mat4.lookAt(viewMatrix, eye, center, up);
  // 透视投影
  mat4.perspective(
    projMatrix,
    (60 * Math.PI) / 180,
    1,
    params.near,
    params.far
  );
  // 设置uniform
  twgl.setUniforms(programInfo, uniform);
  // 开启隐藏面消除
  gl.enable(gl.DEPTH_TEST);
  // 清空颜色缓冲区
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  // 绘制图形
  // twgl.drawBufferInfo(gl, bufferInfo, gl.TRIANGLES);
  gl.drawElements(gl.TRIANGLES, bufferInfo.numElements, gl.UNSIGNED_SHORT, 0);

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
    mat4.perspective(
      projMatrix,
      (60 * Math.PI) / 180,
      1,
      params.near,
      params.far
    );
    twgl.setUniforms(programInfo, uniform);
    gl.enable(gl.DEPTH_TEST);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    // twgl.drawBufferInfo(gl, bufferInfo, gl.TRIANGLES);
    gl.drawElements(gl.TRIANGLES, bufferInfo.numElements, gl.UNSIGNED_SHORT, 0);
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
