function [k,a]=invkini(x,y,phi)
global   l1 l2 l3
 l1=1;l2=1;l3=0.5;
xx=x-l3*cos(phi);
yy=y-l3*sin(phi);
k=(xx^2+yy^2-l1^2-l2^2)/(2*l1*l2);
if k > 1
    a=[];
    return
end
t2=acos(k);
d=l1^2+l2^2+2*l1*l2*cos(t2);
cc=(xx*(l1+l2*cos(t2))+yy*l2*sin(t2))/d;
ss=(-xx*l2*sin(t2)+yy*(l1+l2*cos(t2)))/d;
t1=atan2(ss,cc);
t3=phi-t1-t2;
a=[ t1 t2 t3];