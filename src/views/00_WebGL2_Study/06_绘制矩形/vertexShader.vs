#version 300 es

in vec4 a_Position;
in vec2 a_Color;
out vec2 v_Color;
void main() {
  gl_Position = a_Position;
  v_Color = a_Color;
}