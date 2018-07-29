function h=lforce2d(n,clr)
% LFORCE2D: Generates a 2D polar plot of n-lines of force of the
%           Gecentric Axial Magnetic Dipole
% Usage:
%      h = LFORCE2D(N, Color)
% Input:
%         N = Number of lines of force.
%     Color = Line color (see PLOT)
%

%       RBG  [Red Blue Green]
% Written by: Dr. A. Abokhodair                           Date: 15/12/2005
% ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

%       RBG  [Red Blue Green]
% Written by: Dr. A. Abokhodair                           Date: 15/12/2005
% ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

d2r = pi/180;
tht = (0:5:360)'*d2r;
A   = 2:n;
r   = sin(tht).^2*A;
nC  = size(r,2);
u   = ones(1,nC);
ct  = cos(tht)*u;
st  = sin(tht)*u;

x   = r.*st;
y   = r.*ct;

figure;
R = max(x(:))/8;
axis equal;
h  = plot(x,y,'r');
[nR,nC] = size(x);

for iR=2:6:floor(nR/2)
    for jC=1:2:nC;
        p1 = [x(iR-1,jC) -y(iR-1,jC)];
        p2 = [x(iR,jC) -y(iR,jC)];
        hv=plotvec(p1,p2,clr);
    end
end

for iR=floor(nR/2)+2:6:nR;
    for jC=1:2:nC;
        p1 = [x(iR-1,jC) y(iR-1,jC)];
        p2 = [x(iR,jC) y(iR,jC)];
        hv=plotvec(p1,p2,clr);
    end
end


hold on;
hc = fcircle(R,[0,0],clr);
hv = plotvec([0 R/2], [0 -R/2],'r');
h=plot([0 0],[R/2, -R/3],'r','LineWidth',3);

title('Magnetic Dipole Field','FontSize',15);
hold off;
grid on;

h=[h;hc];
    
% ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

function hh=fcircle(r,o,s)
% FCIRCLE - draws a filled cirlce
% Usage:
%       h = FCIRCLE(R,O) 
%

% Copyright (c) 2000-05-19 by B. Rasmus Anthin.
% Rev. 2000-10-24

phi=linspace(0,2*pi);
axis equal;
if nargin==2
   h=patch(r*cos(phi)+o(1),r*sin(phi)+o(2),'');
else
   h=patch(r*cos(phi)+o(1),r*sin(phi)+o(2),s);
end
set(h,'edgec',get(h,'facec'));
set(h,'user',{'fcircle',r,o});
if nargout,hh=h;end
% ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

function h=plotvec(p1,p2,linespec)
% PLOTVEC - Draws a vector.
% Usage:
%       PLOTVEC(p1,p2,[LINESPEC]) 
%
% Draws a vector from point P1 to point P2 using linespecification
%       LINESPEC (see PLOT).
%
%   H = PLOTVEC(...) returns handles of the objects.
%
%   See also CIRCLE, FCIRCLE, ELLIPSE, FELLIPSE.

% Copyright (c) 2001-09-28, B. Rasmus Anthin.

if nargin==2,linespec='';end
held=ishold;hold on
x=[p1(1) p2(1)];
y=[p1(2) p2(2)];
dx=diff(x);
dy=diff(y);
hh(1)=plot(x,y,linespec);
ax=axis;
lx=diff(ax(1:2))*15e-3;
ly=diff(ax(3:4))*10e-3;
phi=atan2(dy,dx);
head=rotate2([-lx 0 -lx;ly 0 -ly],[0;0],phi);
col=get(hh(1),'color');
hh(2)=patch(head(1,:)+p2(1),head(2,:)+p2(2),col);
set(hh(2),'edgec',col)
set(hh(1),'user',{'vector',p1,p2,hh(2)})
set(hh(2),'user',{'vector',p1,p2,hh(1)})
if ~held,hold off,end
if nargout,h=hh;end
% ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

function newpoints=rotate2(points,origo,phi)
%ROTATE2  rotate points in 2 dimensions.
%   NEWPOINTS=ROTATE(POINTS,ORIGO,PHI) rotates the
%   points in POINTS PHI radians around the ORIGO
%   point.
%   ROTATE returns NEWPOINTS as the rotated points from POINTS.

% Copyright(c) 2000-05-14 by B. Rasmus Anthin.

A=[cos(phi) -sin(phi);sin(phi) cos(phi)];
newpoints=A*points+origo*ones(1,size(points,2));
% ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

