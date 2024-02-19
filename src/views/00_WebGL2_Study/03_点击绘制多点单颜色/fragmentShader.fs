#version 300 es
precision highp float;

out vec4 outColor;
uniform vec3 u_Color;

void main() {
  outColor = vec4(u_Color, 1.0);
}