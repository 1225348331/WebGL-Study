attribute vec4 a_Position;
attribute vec4 a_Color;
attribute vec4 a_Normal;// 法向量
varying vec4 v_Color;
uniform mat4 u_ProjMatrix;// 投影矩阵
uniform mat4 u_ViewMatrix;// 视图矩阵
uniform mat4 u_ModelMatrix;// 模型矩阵
uniform vec3 u_LightColor;// 入射光颜色
uniform vec3 u_LightDirection;// 入射光方向
uniform vec3 u_LightPosition;// 入射光位置
uniform vec3 u_AmbientLight;// 环境光颜色
uniform mat4 u_NormalMatrix;// 法向量变换矩阵

void main(){
  gl_Position=u_ProjMatrix*u_ViewMatrix*u_ModelMatrix*a_Position;
  // 归一化法线向量
  vec3 normal=normalize(vec3(u_NormalMatrix*a_Normal));
  // 计算顶点的世界坐标
  vec4 vertexPosition=u_ModelMatrix*a_Position;
  // 计算光线方向并归一化
  vec3 lightDirection=normalize(u_LightPosition-vec3(vertexPosition));
  // 计算光线方向和法向量的点积
  float nDotL=max(dot(normal,lightDirection),0.);
  // 计算漫反射光的颜色
  vec3 diffuse=u_LightColor*vec3(a_Color)*nDotL;
  // 计算环境光的颜色
  vec3 ambient=u_AmbientLight*a_Color.rgb;
  v_Color=vec4(diffuse+ambient,a_Color.a);
}