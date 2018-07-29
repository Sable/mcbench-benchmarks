function [t,X] = smdplot(t,X)  
% See Article 2.6
% [t,X]=smdplot(t,X)
% This function plots the response and animates the
% motion of a damped linear harmonic oscillator
% characterized by the differential equation
% m*x''+c*x'+k*x=f1*cos(w*t)+f2*sin(w*t)
% with initial conditions x(0)=x0, x'(0)=v0.
% The animation depicts forced motion of a block
% attached to a wall by a spring. The block
% slides on a horizontal plane which provides 
% viscous damping.

% Default data case used when no input arguments
% are given
if nargin==0
  m=1; c=.3; k=1; f1=1.5; f2=0; w=2; x0=0; v0=2; 
  %tmax=30; nt=250; t=linspace(0,tmax,nt);
  tmax=25; nt=200; t=linspace(0,tmax,nt);
  X=smdsolve(m,c,k,f1,f2,w,x0,v0,t);
end

% Plot the displacement versus time 
plot(t,X), xlabel('time'), ylabel('displacement')
title(...
'FORCED RESPONSE OF A DAMPED HARMONIC OSCILLATOR')
grid on, shg, pause(3) 

% Add a block and a spring to the displacement
xmx=max(abs(X)); X=X/1.1/xmx;
xb=[0,0,1,1,0,0]/2; yb=[0,-1,-1,1,1,0]/2;

% Make an arrow tip   
d=.08; h=.05;
xtip=[0,-d,-d,0]; ytip=[0,0,0,h,-h,0];

% Add a spring and a block to the response
[xs,ys]=spring; nm=length(X); ns=length(xs);
nb=length(xb); x=zeros(nm,ns+nb);y=[ys,yb];
for j=1:nm, x(j,:)=[-1+(1+X(j))*xs,X(j)+xb];end 
r=[min(x(:)),max(x(:))+1,-2,2];
rx=r([1 1 2]); ry=[.5,-.5,-.5]; close;

% Plot the motion
for j=1:nm
   % Compute and scale the applied force
   f=f1*cos(w*t(j))+f2*sin(w*t(j));
   f=.3*f; fa=abs(f); sf=sign(f);
   xj=x(j,:); xmaxj=max(xj);
   if sf>0
      xforc=xmaxj+[0,fa,fa+xtip];
   else
      xforc=xmaxj+[fa,0,-xtip];
   end
   
   % Plot the spring, block, and force
   plot(xj,y,rx,ry,'k',xforc,ytip,'r')
   title('FORCED MOTION WITH DAMPING')
   axis(r), axis('off'), drawnow
   figure(gcf), pause(.05) 
end 
 
%====================================

function [x,y] = spring(len,ht)
% This function generates a set of points
% defining a spring

if nargin==0, len=1; ht=.125; end
x=[0,.5,linspace(1,11,10),11.5,12];
y=[ones(1,5);-ones(1,5)];
y=[0;0;y(:);0;0]'; y=ht/2/max(y)*y;
x=len/max(x)*x;
 
%====================================

function [x,v]=smdsolve(m,c,k,f1,f2,w,x0,v0,t)
% [x,v]=smdsolve(m,c,k,f1,f2,w,x0,v0,t)
% This function solves the differential equation
% m*x''(t)+c*x'(t)+k*x(t)=f1*cos(w*t)+f2*sin(w*t)
% with x(0)=x0 and x'(0)=v0
%
% m,c,k  - mass, damping and stiffness coefficients
% f1,f2  - magnitudes of cosine and sine terms in
%          the forcing function
% w      - frequency of the forcing function
% t      - vector of times to evaluate the solution
% x,v    - computed position and velocity vectors

ccrit=2*sqrt(m*k); wn=sqrt(k/m);

% If the system is undamped and resonance will 
% occur, add a little damping
if c==0 & w==wn; c=ccrit/1e6; end;

% If damping is critical, modify the damping
% very slightly to avoid repeated roots
zeta=c/ccrit; if zeta==1, zeta=zeta+1e-6; end 

% Forced response solution
a=(f1-i*f2)/(k-m*w^2+i*c*w);
X0=real(a); V0=real(i*w*a);
X=real(a*exp(i*w*t)); V=real(i*w*a*exp(i*w*t));

% Homogeneous solution
r=sqrt(zeta^2-1); s1=wn*(-zeta+r); s2=wn*(-zeta-r);
p=[1,1;s1,s2]\[x0-X0;v0-V0];

% Total solution satisfying the initial conditions 
x=X+real(p(1)*exp(s1*t)+p(2)*exp(s2*t));
v=V+real(p(1)*s1*exp(s1*t)+p(2)*s2*exp(s2*t));