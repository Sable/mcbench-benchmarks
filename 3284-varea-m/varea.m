function area=varea(C)
%VAREA compute the "sign-area" of a closed curve.
% NOTE: Sign-area equals to the area of the closed curve when it is in anti-clockwise and equals to the negative area when it is in clockwise.
%	Negative area means equal to area in magnitude but is negtive in sign.We can see that this script may also be used to judge the direction of a closed curve.
% C provides the coordinats of the nodes of the curve in the following way:
%  C=[x1 x2 ...
%     y1 y2 ...]
% AREA=VAREA(C)
%  AREA returns the area of the curve(>0) when it is in anti-clockwise
%  AREA returns the negtive area of the curve(<0) when it is in clockwise
%
% writen by Kang Zhao(kangzhao@student.dlut.edu.cn) at DLUT,Dalian,China. $Date: 2002/04/17

num=size(C,2); %number of nodes
% select the first point in C as the starting point
%% P0->P1=(x1-x0)+i(y1-y0)=a+bi
%% P0->P2=(x2-x0)+i(y2-y0)=c+di
x0=C(1,1);
y0=C(2,1);
area=0;
c=C(1,2)-x0;
d=C(2,2)-y0;
for i=2:num-1
    a=c;
    b=d;
    c=C(1,i+1)-x0;
    d=C(2,i+1)-y0;
    area=area+a*d-c*b;
end
area=0.5*area;