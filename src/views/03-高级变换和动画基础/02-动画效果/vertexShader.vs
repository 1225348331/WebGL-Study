#version 300 es

in vec4 a_Position;
in vec4 a_CenterPosition;
uniform mat4 u_ModelMatrix;

void main() {
  // 使坐标平移到原点
  vec4 translatePosition = a_Position - a_CenterPosition;
  // 使坐标绕着旋转中心旋转
  vec4 rotatedPosition = u_ModelMatrix * translatePosition;
  // 使坐标平移到原来的坐标
  vec4 finalPosition = rotatedPosition + a_CenterPosition;

  gl_Position = finalPosition;
}