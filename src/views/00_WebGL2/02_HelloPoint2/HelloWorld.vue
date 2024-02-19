<script setup>
import { onMounted } from "vue";
import VSHADER_SOURCE from "./vertexShader.vs";
import FSHADER_SOURCE from "./fragmentShader.fs";
import * as twgl from "twgl.js";


onMounted(() => {
  const gl = document.getElementById("canvas").getContext("webgl2");
  const programInfo = twgl.createProgramInfo(gl, [
    VSHADER_SOURCE,
    FSHADER_SOURCE,
  ]);
  gl.useProgram(programInfo.program);
  const arrays = {
    a_Position: { numComponents: 2, data: [0.5, -0.5, 0, 0.5, -0.5, -0.5] },
    a_PointSize: { numComponents: 1, data: [5, 10, 15] },
  };
  const bufferInfo = twgl.createBufferInfoFromArrays(gl, arrays);
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  twgl.drawBufferInfo(gl, bufferInfo, gl.POINTS);
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
}
</style>
