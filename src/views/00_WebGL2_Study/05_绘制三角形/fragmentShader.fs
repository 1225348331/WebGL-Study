#version 300 es
precision highp float;

out vec4 outColor;
in vec2 v_Color;

void main() {
  outColor = vec4(v_Color, 0.0, 1.0);
}