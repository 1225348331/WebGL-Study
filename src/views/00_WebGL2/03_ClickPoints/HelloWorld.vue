<script setup>
import { onMounted } from "vue";
import VSHADER_SOURCE from "./vertexShader.vs";
import FSHADER_SOURCE from "./fragmentShader.fs";
import * as twgl from "twgl.js";

let array = {
  a_Position: {
    numComponents: 2,
    data: [],
  },
};
function click(ev, gl, programInfo) {
  var canvas = document.getElementById("canvas");
  var x = ev.clientX;
  var y = ev.clientY;
  var rect = ev.target.getBoundingClientRect();
  x = (x - rect.left - canvas.height / 2) / (canvas.height / 2);
  y = (canvas.width / 2 - (y - rect.top)) / (canvas.width / 2);
  array.a_Position.data.push(x, y);
  //清除<canvas>
  gl.clear(gl.COLOR_BUFFER_BIT);
  const bufferInfo = twgl.createBufferInfoFromArrays(gl, array);
  twgl.setBuffersAndAttributes(gl, programInfo, bufferInfo);
  twgl.drawBufferInfo(gl, bufferInfo, gl.POINTS);
}

onMounted(() => {
  const gl = document.getElementById("canvas").getContext("webgl2");
  const programInfo = twgl.createProgramInfo(gl, [
    VSHADER_SOURCE,
    FSHADER_SOURCE,
  ]);
  gl.useProgram(programInfo.program);

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
  background-color: aquamarine;
  padding: 10px;
  #canvas {
    border: 1px solid red;
  }
}
</style>
