function runtop
% See Article 8.6
a=.01; h=4; b=2; n=6; m=3; k=20;  
psi=45; theta=-45; phi=0;
for j=1:2:720
   
   psi=180+j; theta=-45+5*sin(.15*psi); phi=1.5*j;
   topdraw(a,h,b,8,m,18,psi,theta,phi);
      
   % topdraw(a,h,b,8,m,18,j,-45,1.5*j);
end
pause(1),%  close

%================================================

function [x,y, z]=topdraw(a,h,b,n,m,k,psi,theta,phi)
% [x,y, z]=topdraw(a,h,b,n,m,k,psi,theta,phi)

% [X,Y,Z]=topsurf(n,m,k,a,h,b)
if nargin==0
  a=.01; h=4; b=2; n=6; m=3; k=20;  
  psi=45; theta=-45; phi=0;
end
%s=sqrt(h^2+(a-b)^2); uax=cumsum([0,a,s,b]);
%u=cornrpts(uax/uax(4),nax+1); 
%v=linspace(0,1,ncrc+1); 

[dx,dy,dz]=topsurf(n,m,k,a,h,b);

x=dz; y=dx; z=dy;

m=eulerang(psi,theta,phi);
p=size(x); v=[x(:),y(:),z(:)]*m;
x=reshape(v(:,1),p); y=reshape(v(:,2),p);
z=reshape(v(:,3),p);
w=[-1 1 -1 1 -1 1]*sqrt(h^2+b^2);

%rotate3d on;
clf; surf(x,y,z),  view([-45,30])
axis equal; axis(w); axis on
xlabel('x axis'), ylabel('y axis')
zlabel('z axis')
title('NUTATING TOP PRECESSION')
colormap([127/255 1 212/255]); drawnow, shg

%============================================

function m=eulerang(psi,theta,phi)
% m=eulerang(psi,theta,phi)
a=pi/180*[psi,theta,phi]; c=cos(a); s=sin(a);
m=[c(1)*c(2), s(1)*c(2), -s(2); -s(1)*c(3)+...
   c(1)*s(2)*s(3), c(1)*c(3)+s(1)*s(2)*s(3),...
   c(2)*s(3); s(1)*s(3)+c(1)*s(2)*c(3),...
  -c(1)*s(3)+s(1)*s(2)*c(3), c(2)*c(3)];

%============================================

function [X,Y,Z]=topsurf(n,m,k,a,h,b)
% [X,Y,Z]=topsurf(n,m,k,a,h,b)
if nargin==0
n=8; m=4; k=20; a=.2; h=4; b=1;
end
tol=100*eps*(a+h+b);
a=a+(a==0)*tol; b=b+(b==0)*tol;

D=2*pi/n; u=cos(D/2); v=sin(D/2); 
z=u+i*linspace(-v,v,m+1)'; z(m+1)=[];
z=z*exp(i*D*(0:n-1)); z=[z(:);u-i*v];
x=real(z); y=imag(z); N=length(x);
% plot(x,y,x,y,'.'), axis equal, shg, pause

qd=cumsum([0;a;sqrt(h^2+(a-b)^2);b]);
qd=qd/max(qd); q=cornrpts(qd,k); 
K=length(q);
Z=interp1(qd,[0;0;h;h],q(:))*ones(1,N);
r=interp1(qd,[0;a;b;0],q); r=r(:);
X=r*x(:)'; Y=r*y(:)';

%============================================

function v=cornrpts(u,N)
% v=cornrpts(u,N)
% This function generates a set of approximately 
% N points between min(u) and max(u) including 
% all points in u plus additional points evenly
% spaced in each successive interval.
% u   -  vector of points
% N   -  approximate number of output points
%        between min(u(:)) and max(u(:))
% v   -  vector of points in increasing order 
u=sort(u(:))'; np=length(u); d=u(np)-u(1); v=u(1);
for j=1:np-1
  dj=u(j+1)-u(j); nj=max(1,fix(N*dj/d)); 
  v=[v,[u(j)+dj/nj*(1:nj)]];
end