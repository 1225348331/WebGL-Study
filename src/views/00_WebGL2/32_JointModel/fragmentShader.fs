#ifdef GL_ES
precision mediump float;
#endif

uniform vec3 u_LightColor;// 入射光颜色
uniform vec3 u_LightPosition;// 入射光位置
uniform vec3 u_AmbientLight;// 环境光颜色

varying vec4 v_Color;// 片元颜色
varying vec3 v_Normal;// 片元法向量
varying vec3 v_Position;// 片元世界坐标

void main(){
    vec3 normal=normalize(v_Normal);
    // 计算光线方向并归一化
    vec3 lightDirection=normalize(u_LightPosition-v_Position);
    // 计算光线方向和法向量的点积
    float nDotL=max(dot(normal,lightDirection),0.);
    // 计算漫反射光的颜色
    vec3 diffuse=u_LightColor*vec3(v_Color)*nDotL;
    // 计算环境光的颜色
    vec3 ambient=u_AmbientLight*v_Color.rgb;
    gl_FragColor=vec4(diffuse+ambient,v_Color.a);
    
}