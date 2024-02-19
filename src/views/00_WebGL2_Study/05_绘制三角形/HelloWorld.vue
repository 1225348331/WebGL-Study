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
  a_Color: {
    numComponents: 2,
    data: [],
  },
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
  arrays.a_Position.data.push(0.5, -0.5, 0.0, 0.5, -0.5, -0.5);
  arrays.a_Color.data.push(0.5, 0.5, 0.2, 0.3, 1.0, 1.0);
  const bufferInfo = twgl.createBufferInfoFromArrays(gl, arrays);
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  twgl.drawBufferInfo(gl, bufferInfo, gl.TRIANGLES);
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
