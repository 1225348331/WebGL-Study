import * as twgl from "twgl.js";
import { onUnmounted } from "vue";

/**
 * @description: 初始化canvas,返回gl
 * @param {string} vs 顶点着色器
 * @param {string} fs 片元着色器
 */
const initWebGL = (vs: string, fs: string, isFullScreen: boolean = false) => {
  const { gl, canvas } = getContext(isFullScreen);
  // 创建program
  const programInfo = twgl.createProgramInfo(gl, [vs, fs]);
  // 使用program
  gl.useProgram(programInfo.program);

  // 设置清除颜色
  gl.clearColor(0, 0, 0, 0.0);
  gl.enable(gl.DEPTH_TEST);
  gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

  // 清除GL,并设置清除颜色
  const clearGL = () => {
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  };

  // 在组件销毁时，动态销毁WebGL context对象
  onUnmounted(() => {
    gl.getExtension("WEBGL_lose_context")?.loseContext();
  });

  return { gl, programInfo, clearGL, width: canvas.width, height: canvas.height, canvas };
};

// 获取canvas context 默认webgl2
const getContext = (isFullScreen: Boolean = false) => {
  const container = document.querySelector(".ant-layout-content") as HTMLElement;
  const canvas = document.querySelector("canvas") as HTMLCanvasElement;
  const { height, width } = container.getBoundingClientRect();
  isFullScreen ? (canvas.width = width - 48) : (canvas.width = height - 48);
  canvas.height = height - 48;
  canvas.style.borderRadius = "6px";
  const gl = twgl.getContext(canvas) as WebGL2RenderingContext;
  twgl.resizeCanvasToDisplaySize(canvas);
  return { gl, canvas };
};

export { initWebGL, getContext };
