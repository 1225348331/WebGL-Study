attribute vec4 a_Position;
attribute float a_PointSize;
attribute vec4 a_Color;
varying vec4 v_Color;
uniform mat4 u_ViewMatrix;
void main(){
  gl_Position=u_ViewMatrix*a_Position;
  v_Color=a_Color;
}