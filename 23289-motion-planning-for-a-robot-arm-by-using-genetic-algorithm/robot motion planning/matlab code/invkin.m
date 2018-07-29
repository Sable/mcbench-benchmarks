function a=invkin(x,y)

l1=1;l2=1;
k=(x^2+y^2-l1^2-l2^2)/(2*l1*l2);
q2=acos(k);
d=l1^2+l2^2+2*l1*l2*cos(q2);
cc=(x*(l1+l2*cos(q2))+y*l2*sin(q2))/d;
ss=(-x*l2*sin(q2)+y*(l1+l2*cos(q2)))/d;
q1=atan2(ss,cc);
a=[q1,q2];
