function [xp,yp,t,d]=calculate_distance(b,X,Y)
% Calculate distance between bezier curve and a point
%  [xp,yp,t,d]=calculate_distance(b,X,Y)


if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end

[x0,ax,bx,cx,y0,ay,by,cy]=deal(b.x0,b.ax,b.bx,b.cx,b.y0,b.ay,b.by,b.cy);

jj=[ay^2+ax^2,2*(by*ay+bx*ax),2*cy*ay+by^2+2*cx*ax+bx^2,...
	2*(-X+x0)*ax+2*cx*bx+2*(-Y+y0)*ay+2*cy*by,...
	2*(-Y+y0)*by+cy^2+2*(-X+x0)*bx+cx^2,...
	2*(-Y*cy+y0*cy-X*cx+x0*cx),(-Y+y0)^2+(-X+x0)^2];
dj=polyder(jj);

r=roots(dj);
i=find(imag(r)==0 & r>=0 & r<=1);
pt=[0,1];
if ~isempty(i)
  pt=[pt,r(i)'];
end

v=polyval(jj,pt);
[m,i]=min(v);
t=pt(i);
xp=polyval([ax bx cx x0],t);
yp=polyval([ay by cy y0],t);
d=norm([xp yp]-[X Y]);