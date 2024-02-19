attribute vec4 a_Position;
attribute float a_PointSize;
attribute vec4 a_Color;
varying vec4 v_Color;
uniform mat4 u_ProjMatrix;
void main(){
  gl_Position=u_ProjMatrix*a_Position;
  v_Color=a_Color;
}