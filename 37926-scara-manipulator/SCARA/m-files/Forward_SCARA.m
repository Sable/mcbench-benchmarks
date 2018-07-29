function [R O]=Forward_SCARA(theta,d3,d4,a1,a2)
 
 
th1=theta(1,1);
th2=theta(1,2);
th4=theta(1,3);
alpha=th1+th2-th4;
 
R=[cos(alpha),sin(alpha),0;sin(alpha),-cos(alpha),0;0,0,-1];
O=[((a1*cos(th1))+(a2*cos(th1+th2)));((a1*sin(th1))+(a2*sin(th1+th2)));(-d3-d4)];