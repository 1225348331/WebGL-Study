<script setup>
import { onMounted } from "vue";
import VSHADER_SOURCE from "./vertexShader.vs";
import FSHADER_SOURCE from "./fragmentShader.fs";
import * as twgl from "twgl.js";
import { Pane } from "tweakpane";
import { mat4 } from "gl-matrix";

import * as _ from "lodash";

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

onMounted(() => {
  // 模型变换矩阵
  const modelMatrix = mat4.create();
  const gl = document.getElementById("canvas").getContext("webgl2");
  const programInfo = twgl.createProgramInfo(gl, [
    VSHADER_SOURCE,
    FSHADER_SOURCE,
  ]);
  gl.useProgram(programInfo.program);
  let arrays = {
    // 绘制坐标
    a_Position: {
      numComponents: 2,
      data: [0.5, -0.5, 0.5, 0.5, -0.5, 0.5, -0.5, -0.5],
    },
    // 纹理坐标
    a_Texcoord: {
      numComponents: 2,
      data: [1.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 0.0],
    },
  };
  let bufferInfo = twgl.createBufferInfoFromArrays(gl, arrays);
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  let uniform = {
    u_ModelMatrix: modelMatrix,
    u_texture1: "",
    u_texture2: "",
  };
  const texture = twgl.createTextures(
    gl,
    {
      tex1: {
        src: "http://localhost:5173/src/assets/img/square.png",
        flipY: 1,
      },
      tex2: {
        src: "http://localhost:5173/src/assets/img/square1.png",
        flipY: 1,
      },
    },
    function (err, tex, img) {
      (uniform.u_texture1 = tex.tex1),
        (uniform.u_texture2 = tex.tex2),
        twgl.setUniforms(programInfo, uniform);
      twgl.drawBufferInfo(gl, bufferInfo, gl.TRIANGLE_FAN);
    }
  );

  // 模型变换
  pane.on("change", (e) => {
    mat4.translate(modelMatrix, mat4.create(), [params.x, 0, 0]);
    mat4.translate(modelMatrix, modelMatrix, [0, params.y, 0]);
    mat4.rotateZ(modelMatrix, modelMatrix, (params.theta * Math.PI) / 180.0);
    mat4.scale(modelMatrix, modelMatrix, [params.scaleX, 1, 1]);
    mat4.scale(modelMatrix, modelMatrix, [1, params.scaleY, 1]);
    uniform.u_ModelMatrix = modelMatrix;
    twgl.setUniforms(programInfo, uniform);
    gl.clearColor(0.0, 0.0, 0.0, 0.0);
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
  background-color: aquamarine;
  padding: 10px;
  #canvas {
    border: 1px solid red;
  }
}
</style>
