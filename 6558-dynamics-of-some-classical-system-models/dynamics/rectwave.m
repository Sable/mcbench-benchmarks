function rectwave(a,b,alp,tmax,w,x0,y0) 
% rectwave(a,b,alp,tmax,w,x0,y0) from Article 9.5
% This program illustrates wave motion in a 
% rectangular membrane subjected to a concentrated
% oscillatory force applied at an arbitrary 
% interior point. The membrane has fixed edges 
% and is initially at rest in an undeflected 
% position. The resulting response u(x,y,t)is
% computed and a plot of the motion is  shown.
% a,b    -  side dimensions of the rectangle
% alp    -  wave propagation velocity in the
%           membrane
% w      -  frequency of the applied force. This
%           can be zero if the force is constant.
% x0,y0  -  coordinates of the point where
%           the force acts
% x,y,t  -  vectors of position and time values
%           for evaluation of the solution
% N,M    -  summation limits for the double 
%           Fourier series solution
% noplot -  parameter included if no animated 
%           plot is to be made
% u      -  an array of size [length(x),...
%                          length(y),length(t)]
%           in which u(i,j,k) contains the
%           normalized displacement at 
%           x(i),y(j),t(k). The displacement is
%           is normalized by dividing by 
%           max(abs(u(:)))
%
% The solution is a double Fourier series 
% having the form 
%
% u(x,y,t)=Sum(A(n,m,x,y,t), n=1..N, m=1..M)
% where
% A(n,m,x,y,t)=sin(n*pi*x0/a)*sin(n*pi*x/a)*...
%              sin(m*pi*y0/b)*sin(m*pi*y/b)*...
%              (cos(w*t)-cos(W(n,m)*t))/...
%              ( w^2-W(n,m)^2)
% and the membrane natural frequencies are
% W(n,m)=pi*alp*sqrt((n/a)^2+(m/b)^2)

%disp(' ')
%disp('  WAVE MOTION IN A MEMBRANE LOADED')
%disp('  BY A PERIODIC CONCENTRATED FORCE')

if nargin > 0 % Data passed through the call list
   % must specify: a,b,alp,tmax,w,x0,y0
   % Typical values are
   % a=2; b=1; alp=1; tmax=5; w=18.4; x0=1; y0=0.5;
   
   if a<b
      %nx=21; ny=round(b/a*21); ny=ny+rem(ny+1,2);
      nx=32; ny=round(b/a*21); ny=ny+rem(ny+1,2);
   else
      %ny=21; nx=round(a/b*21); nx=nx+rem(nx+1,2);
      ny=32; nx=round(a/b*21); nx=nx+rem(nx+1,2);
   end
   x=linspace(0,a,nx); y=linspace(0,b,ny);

   N=40; M=40; pan=pi/a*(1:N)'; pbm=pi/b*(1:M);
   W=alp*sqrt(repmat(pan.^2,1,M)+repmat(pbm.^2,N,1));
   wsort=sort(W(:)); wsort=reshape(wsort(1:30),5,6)';
   dt=min(a,b)/40/alp;  t=0:dt:tmax; Nt=length(t);

else         % Data is input interactively
   vec=input(...
   '\nGive the membrane dimensions: a,b ? ','s');
   vec=eval(['[',vec,']']); a=vec(1); b=vec(2);
   vec=input(...
   '\nGive the wave speed and maximum time ? ','s');
   vec=eval(['[',vec,']']); alp=vec(1); tmax=vec(2);
   dt=min(a,b)/40/alp;  t=0:dt:tmax; Nt=length(t);

   if a<b
      %nx=21; ny=round(b/a*21); ny=ny+rem(ny+1,2);
      nx=32; ny=round(b/a*21); ny=ny+rem(ny+1,2);
   else
      %ny=21; nx=round(a/b*21); nx=nx+rem(nx+1,2);
      ny=32; nx=round(a/b*21); nx=nx+rem(nx+1,2);
   end
   x=linspace(0,a,nx); y=linspace(0,b,ny);

   N=40; M=40; pan=pi/a*(1:N)'; pbm=pi/b*(1:M);
   W=alp*sqrt(repmat(pan.^2,1,M)+repmat(pbm.^2,N,1));
   wsort=sort(W(:)); wsort=reshape(wsort(1:30),5,6)';
   disp(' '), 
   disp('The first thirty natural frequencies are:')
   disp(wsort)
   w=input(...
   '\nInput the frequency of the forcing function ? ');
   vec=input(['\nGive coordinates x0,y0 where ',...
           'the force acts ? '],'s');
   vec=eval(['[',vec,']']); x0=vec(1); y0=vec(2);
end
  
% Evaluate fixed terms in the series solution  
mat=sin(x0*pan)*sin(y0*pbm)./(w^2-W.^2);
sxn=sin(x(:)*pan'); smy=sin(pbm'*y(:)');

% Determine the range on displacement values
umax=-realmax; umin=realmax;
for j=1:Nt
  A=mat.*(cos(w*t(j))-cos(W*t(j)));
  uj=sxn*(A*smy); uj=uj(:);
  umax=max([uj;umax]); umin=min([uj;umin]);
end

% Compute the plot range
d=max(a,b); xmin=(a-d)/2; xmax=(a+d)/2;
ymin=(b-d)/2; ymax=(b+d)/2; 
range=[xmin,xmax,ymin,ymax,1.5*umin,1.5*umax];

%disp(' ')
%disp('Press return to see the wave motion')
%dumy=input(' ','s'); close;

% Sum the series and plot for successive times
for j=1:Nt
  A=mat.*(cos(w*t(j))-cos(W*t(j)));
  MAT=sxn*(A*smy); clf
  surf(x,y,MAT'), axis(range)
  xlabel('x axis'), ylabel('y axis')
  zlabel('u axis')
  titl=sprintf(...
  'MEMBRANE POSITION AT T=%5.2f',t(j));
  title(titl), colormap([127/255 1 212/255])
  drawnow, shg, pause(.1)
end