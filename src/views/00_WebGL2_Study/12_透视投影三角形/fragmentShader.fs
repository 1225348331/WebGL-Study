#version 300 es
precision highp float;

out vec4 outColor;
in vec4 v_Color;

void main() {
  outColor = v_Color;
}