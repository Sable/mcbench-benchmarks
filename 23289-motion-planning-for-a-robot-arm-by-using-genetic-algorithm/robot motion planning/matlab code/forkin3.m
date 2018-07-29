function f = forkin3(t1,t2,t3)
global l1 l2 l3
% a1=1;a2=1;a3=0.5;
x=l1*cos(t1)+l2*cos(t1+t2)+l3*cos(t1+t2+t3);
y=l1*sin(t1)+l2*sin(t1+t2)+l3*sin(t1+t2+t3);
phi=t1+t2+t3;
f=[x; y ;phi];