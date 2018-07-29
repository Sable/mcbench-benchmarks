function [res,ires]=dydt1(t,y,yp)

res(1)=yp(1)+4*y(1);
res(2)=yp(2)+6*y(2);
res(3)=y(3)-y(1)-2.0;
ires=0;

