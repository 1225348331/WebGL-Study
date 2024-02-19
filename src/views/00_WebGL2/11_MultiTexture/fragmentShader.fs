#version 300 es
precision highp float;

out vec4 outColor;
in vec2 v_Texcoord;
uniform sampler2D u_texture1;
uniform sampler2D u_texture2;
void main() {
  vec4 color1 = texture(u_texture1, v_Texcoord);
  vec4 color2 = texture(u_texture2, v_Texcoord);
  vec4 color = mix(color1, color2, 0.5);
  outColor = color;
}