#version 300 es
precision highp float;

out vec4 outColor;
in vec2 v_Texcoord;

uniform sampler2D u_Texture;
uniform sampler2D u_Texture1;

void main() {
  vec4 color1 = texture(u_Texture, v_Texcoord);
  vec4 color2 = texture(u_Texture1, v_Texcoord);
  outColor = mix(color1, color2, 0.7);
}