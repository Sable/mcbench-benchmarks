function [xd,yd]=transform2d(x,y,tx,ty,phi,xr,yr,sx,sy)
xd=sx*x.*cos(phi)-sy*y.*sin(phi)+xr.*(1-sx*cos(phi))+sy*yr.*sin(phi)+tx;
yd=sx*x.*sin(phi)+sy*y.*cos(phi)+yr.*(1-sy*cos(phi))-sx*xr.*sin(phi)+ty;