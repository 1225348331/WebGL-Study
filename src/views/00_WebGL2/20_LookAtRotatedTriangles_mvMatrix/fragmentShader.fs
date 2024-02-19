#ifdef GL_ES
precision mediump float;
#endif
uniform vec4 u_FragColor;
varying vec4 v_Color;

void main(){
    gl_FragColor=v_Color;
    
}