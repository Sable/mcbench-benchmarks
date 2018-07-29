function [x,y]=getNodeCoordinates(nv)
%Adapted from circle.m by Zhenhai Wang <zhenhai@ieee.org>. For more details
%see under  MATLAB Central >  File Exchange > Graphics > Specialized
%Plot and Graph Types > Draw a circle.

center=[0,0];
theta=linspace(0,2*pi,nv+1);
rho=ones(1,nv+1);%fit radius and nv
[X,Y] = pol2cart(theta',rho');
X=X+center(1);
Y=Y+center(2);
x=X(1:end-1)*10;
y=Y(1:end-1)*10;
