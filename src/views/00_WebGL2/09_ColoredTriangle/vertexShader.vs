#version 300 es

in vec4 a_Position;
in vec3 a_Color;
out vec3 v_Color;
uniform mat4 u_ModelMatrix;

void main() {
  gl_Position = u_ModelMatrix * a_Position;
  v_Color = a_Color;
}