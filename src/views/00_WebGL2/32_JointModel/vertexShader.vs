attribute vec4 a_Position;
attribute vec4 a_Color;
attribute vec4 a_Normal;// 法向量

uniform mat4 u_ProjMatrix;// 投影矩阵
uniform mat4 u_ViewMatrix;// 视图矩阵
uniform mat4 u_ModelMatrix;// 模型矩阵
uniform mat4 u_NormalMatrix;// 法向量变换矩阵

varying vec4 v_Color;// 片元颜色
varying vec3 v_Normal;// 片元法向量
varying vec3 v_Position;// 片元世界坐标

void main(){
  gl_Position=u_ProjMatrix*u_ViewMatrix*u_ModelMatrix*a_Position;
  v_Position=vec3(u_ModelMatrix*a_Position);
  v_Normal=normalize(vec3(u_NormalMatrix*a_Normal));
  v_Color=a_Color;
}