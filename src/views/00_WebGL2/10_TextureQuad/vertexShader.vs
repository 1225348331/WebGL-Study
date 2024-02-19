#version 300 es

in vec4 a_Position;
uniform mat4 u_ModelMatrix;

in vec2 a_Texcoord;
out vec2 v_Texcoord;

void main() {
  v_Texcoord = a_Texcoord;
  gl_Position = u_ModelMatrix * a_Position;
}