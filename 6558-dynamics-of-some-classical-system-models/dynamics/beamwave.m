function [t,x,y,r]=beamwave
% See Article 9.6
% [t,x,y,r]=beamwave
% This program illustrates the periodic motion
% in a simply supported beam with a triangular
% initial deflection pattern. Even though the 
% motion is periodic, high frequency waves 
% travel much faster than low frequency waves
% so a very different response pattern results
% than what occurs in a string fixed at both 
% ends and having the same initial deflection 
% as the beam. The response of the beam during 
% one period of the motion is depicted here.

% fprintf(...
% '\nVIBRATION OF A SIMPLY SUPPORTED BEAM\n\n')

a=1; len=1; n=101; % Use 101 terms

% Triangular initial deflection data
xd=[0,.3,.5,.7,1]; yd=[0,0,-1,0,0];

% Slightly shift any points involving 
% vertical discontinuities
nd=length(xd); delx=(max(xd)-min(xd))/1e6;
k=find(xd(1:nd-1)==xd(2:nd));
if length(k)>0; xd(k+1)=xd(k+1)+delx; end

% Create grid for solution evaluation
nx=61; nt=fix(16384/nx);
x=linspace(0,len,nx); period=2*len^2/(pi*a);
t=linspace(0,period,nt);
y=beamvibs(a,len,xd,yd,t,x,n);
r=[min(x),max(x),2*min(y(:)),2*max(y(:))];

while 0   

% Plot y as a function of x and t
close; surf(x,t,y)
xlabel('position'), ylabel('time')
title(['DEFLECTION SURFACE DURING ',...
       'FUNDAMENTAL PERIOD'])
zlabel('deflection'), disp(...
'Press return for motion animation')
view([-10,30]), figure(gcf), shg
dumy=input(' ','s');

end

% Animate the motion
for j=1:size(y,1);
  plot(x,y(j,:),0,0,'ob',len,0,'ob')
  axis(r), axis off
  title('WAVES IN A SIMPLY SUPPORTED BEAM') 
  figure(gcf), drawnow, pause(.05)
  if j==1, pause(1); end
end

%============================================

function y=beamvibs(a,len,xd,yd,t,x,n)
% y=beamvibs(a,len,xd,yd,t,x,n)
% This function uses a Fourier series expansion
% to solve the simply-supported vibrating beam 
% problem defined by the following conditions:
% differential equation
% a^2*Diff(y(x,t),x,x,x,x)=-Diff(y(x,t),t,t)
% boundary conditions
% y(0,t)=0, Diff(y(x,t),x,x,{x=0,t})=0
% y(len,t)=0, Diff(y(x,t),x,x,{x=len,t})=0
% initial conditions
% y(x,0)=p(x); Diff(y(x,t),t,{t=0})=0
%
% The problem is solved by the following series
% y(x,t)=sum(A(n)*sin(n*pi*x/len)*...
%            cos((n*pi/len)^2*a*t), n=0..inf)
% with A(n) being the Fourier sine series 
% coefficients of the initial deflection p(x).
% The motion is cylical with 
% period=2*len^2/(pi*a);
% 
% a     - velocity of wave propogation 
% len   - beam length 
% xd,yd - data values defining the initial
%         deflection as a piecewise linear
%         function. Vector xd must contain 
%         non-decreasing values between zero
%         and len.
% t     - time vector for evaluating the
%         solution
% x     - position vector for evaluating 
%         the solution
% n     - number of Fourier coefficients used
%         in the series expansion of the 
%         initial conditions 

if nargin==0 % Triangular initial deflection
  a=1; len=1; n=80; xd=[0,.3,.5,.7,1];
  yd=[0,0,-1,0,0]; x=linspace(0,len,61); t=2*x;
end
nt=length(t); t=t(:); nx=length(x); x=x(:)';

% Compute Fourier coefficients for piecewise
% linear initial deflection
nft=1024; xft=2*len/nft*(0:nft-1);
yft=zeros(1,nft);
klft=find(xft<=len); krht=find(xft>len);
yft(klft)=interp1(xd,yd,xft(klft));
yft(krht)=-interp1(xd,yd,2*len-xft(krht));
c=fft(yft); A=-2/nft*imag(c(2:n+1));

% Sum the Fourier series
N=pi/len*(1:length(A)); 
y=(A(ones(nt,1),:).*cos(a*t*N.^2))*sin(N'*x);

% Surface plot for the default data case
if nargin==0
  surf(x,t,y), xlabel('position')
  ylabel('time')
  title(...
  'DEFLECTION SURFACE FOR A VIBRATING BEAM')
  zlabel('deflection'),shg
end