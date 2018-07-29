function runconsec
% runconsec illustrates the four curve types resulting
% when a plane intersects a right circlar cone to 
% produce either a circe, an ellipse, a parabola, or
% a hyperbola. Let alpha be the angle a cone generator
% makes with the cone axis, and let theta be the angle
% between the cone axis and the normal to the plane.
% The four cases are:
% 1) theta = 0                   gives a circle 
% 2) 0 < theta < pi/2 - alpha    gives an ellipse
% 3) theta = pi/2 - alpha        gives a parabola
% 4) pi/2-alpha < theta <= pi/2  gives a hyperbola.
% The intersecting surfaces produced by the program
% show these ideas.

%    by Howard Wilson, August, 2007

describe; angl=pi/6; h=2; x0=0.25; 
n1=15; n2=15; n=[n1 n2];
d=h*[.9, 2*tan(angl)]; p=[.8,.5];
N=[cos(angl),0,sin(angl)];
r0=h*[1/6, 0, .6]; p=[.6 .5];
[x,y,z]=plane(N,r0,d,p,n); 
ang=pi/2-angl; N=[0, -cos(ang), sin(ang)];
p=[.3 .5]; r0=h*[0 , 0, -1/2];
[xx,yy,zz]=plane(N,r0,d,p,n);
[xr,yr,zr]=plane([0,0,1],[0,0,-.65],[1.5, 1.5],...
                 [0.5,0.5],[11,11]); 
[xc,yc,zc]=cones([-h,h],angl,[31,31]);
hold off, close all
subplot(1,2,1)
surf(xc,yc,zc,'facecolor',[1 1 0]); hold on
surf(xx,yy,zz,'facecolor',[1 0 0]);
surf(x,y,z,'facecolor',[0,1,0])
surf(xr,yr,zr,'facecolor',[0,0,1])
xlabel('x axis'), ylabel('y axis'), zlabel('z axis')
title('PARABOLA, CIRCLE, AND ELLIPSE')
axis equal, view([57 16]), hold off 
subplot(1,2,2)
n1=31; n2=31; d1=2*h*tan(angl); d2=2*h;
r0=[x0,0,0]; N1=31; N2=21;
[x,y,z]=plane([1,0,0],r0,[d2,d1],[.5,.5],[N1,N2]);
[xc,yc,zc]=cones(h,angl,n1);
surf(xc,yc,zc,'facecolor',[1 1 0]); hold on
surf(x,y,z,'facecolor',[0,1,0])
xlabel('x axis'), ylabel('y axis'), zlabel('z axis')
title('HYPERBOLA'), view([66 18]); axis equal
shg, subplot, hold off
disp(' Press return to finish')

%================================================

function [x,y,z]=plane(N,r0,d,p,n)
% [x,y,z]=plane(N,r0,d,p,n)

% This function creates a rectangular plane surface
% through an arbitrary point in space with an 
% arbitrary surface normal direction. 
% N     - a vector for the surface normal direction
% r0    - a vector specifying a point in space 
%         through which the plane element passes
% d     - a vector giving the rectangle side lengths
%         of d(1) and d(2). The rectangle can be
%         envisioned as lying initially in the xy
%         plane with side d(1) along the x axis and
%         side d(2) along the y axis.         
% p     - a vector specifying a point in the rectangle
%         which is moved to r0. The point has coord-
%         inates of d(1)*p(1) along the first side and
%         d(2)*p(2) along the second side. p=[.5 .5]
%         specifies the center of the rectangle.
% n     - a vector giving the number grid points in 
%         the d(1) and d(2) directions. If one or both
%         components of n are negative, the plane is
%         plotted along with a unit sphere for reference.
% x,y,z - arrays of dimension n(1) by n(2) containing
%         coordinate points on the plane

% a typical execution is
% [x,y,z]=plane([1,0,1],[0 0 1],[2 2],[0,.5],[-21,21]);

if nargin<5, n=[21,21]; end
if nargin<4, p=[.5,.5]; end
if nargin<3, d=[1 1]; end
if nargin<2, r0=[.5,0,0]; end
if nargin==0, N=[1,0,0]; end
doplot=any(n<0); 
e3=N(:)/norm(N); 
if norm(e3-[0;0;1])==0 | norm(e3+[0;0;1])==0     
  e1=[1;0;0]; e2=[0;1;0];
else
  e2=cross([0;0;1],e3);  
  e2=e2/norm(e2); e1=cross(e2,e3);  
end
u1=linspace(0,d(1),abs(n(1)))-d(1)*p(1); 
u2=linspace(0,d(2),abs(n(2)))-d(2)*p(2); 
[u,v]=meshgrid(u1,u2); x=r0(1)+e1(1)*u+e2(1)*v;
y=r0(2)+e1(2)*u+e2(2)*v; z=r0(3)+e1(3)*u+e2(3)*v; 
if ~doplot, return, end
[xs,ys,zs]=sphere(31);
subplot(1,2,1)
surf(xs,ys,zs,'facecolor',[1 1 0]); hold on
surf(x,y,z,'facecolor',[0,1,0])
xlabel('x axis'), ylabel('y axis'), zlabel('z axis')
title('PLANE TEST')
view([53 24]); axis equal, %rotate3d on
shg, hold off

%================================================

function [x,y,z]=cones(h,angl,n)
% [x,y,z]=cones(h,angl,n) generates points
%         on the surface of a cone
% h     - [height_min, height_max]
% angl  - cone angle from axis of symmetry
% n     - [num_radial, num_circumferential]
% x,y,z - coordinate arrays for points on
%         the cone
if length(h)<2, h=[-h,h]; end
if nargin<3, n=[21,21]; end
if length(n)<2, n=[n,n]; end
rm=h/cos(angl); r=linspace(rm(1),rm(2),n(1)); 
p=linspace(0,2*pi,n(2)); [r,p]=meshgrid(r,p);
t=angl; x=r.*sin(t).*cos(p); y=r.*sin(t).*sin(p);
z=r.*cos(t); 

%================================================

function describe
w=strvcat('                                            ',...
'          THE GEOMETRY OF CONIC SECTIONS              ',...
' This program shows the four curve types resulting    ',...
' from the intersection of a plane and a right circlar ',...
' cone. The curve will be either a circe, an ellipse,  ',...
' a parabola, or a hyperbola. Let alpha be the angle   ',...
' a cone generator makes with the cone axis, and let   ',...
' theta be the angle between the cone axis and the     ',...
' normal to the plane. The four cases are:             ',...
' 1) theta = 0          gives a circle                 ',...
' 2) 0 < theta < alpha  gives an ellipse               ',...
' 3) theta = alpha      gives a parabola               ',...
' 4) theta = pi/2       gives a hyperbola.             ',...
'                                                      ',...
' Press return to see the surfaces                     ',...
'                                                      ');
disp(w), pause