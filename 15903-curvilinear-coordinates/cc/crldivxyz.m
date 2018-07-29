function [vdiv,vcurl]=crldivxyz(vx,vy,vz)
% [vdiv,vcurl]=crldivxyz(vx,vy,vz)
% computes the divergence and curl of a
% vector expressed in x,y,z coordinates
syms x y z real
if ischar(vx), vx=sym(vx); end
if ischar(vy), vy=sym(vy); end
if ischar(vz), vz=sym(vz); end
vdiv=diff(vx,x)+diff(vy,y)+diff(vz,z);
cx=diff(vz,y)-diff(vy,z); 
cy=diff(vx,z)-diff(vz,x); 
cz=diff(vy,x)-diff(vx,y); 
vcurl=[cx;cy;cz];