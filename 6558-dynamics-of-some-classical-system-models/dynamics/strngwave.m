function [Y,T,X]=strnwave(t,x,xd,yd,len,a)
% [Y,T,X]=strnwave(t,x,xd,yd,len,a)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% See Article 2.7
% This function computes the dynamic response 
% of a vibrating string released from rest with 
% a given initial deflection defined by 
% piecewise linear interpolation. The analysis
% employs the translating wave solution for 
% arbitrary initial deflection.
%
% xd,yd - data values defining the initial 
%         deflection.  Values in xd must be 
%         increasing and must lie between 0 
%         and len.
% t     - a vector of time values at which the 
%         solution is to be computed
% x     - a vector of x values at which the 
%         solution is to be computed
% len   - the length of the string
% a     - the velocity of wave propagation in 
%         the string
%
% Y     - matrix of transverse deflection 
%         values such that Y(i,j) is the 
%         deflection at time T(i,1) and 
%         position X(1,j)
% T     - matrix of time values at which the 
%         solution is computed. This matrix is 
%         output from function meshgrid and has 
%         all rows identical.
% X     - matrix of position values at which
%         the solution is computed. This matrix 
%         is output from function meshgrid and 
%         has all columns identical. 
%
% User m functions required: 
%    lintrp, smotion, genprint
%----------------------------------------------

if nargin < 6, a=1; end; 
if nargin < 5, len=1; end;

% Generate a triangle wave when no input
if nargin==0
  xd=[0;.33; .5; .67; 1];  
  yd=[0;  0; -1;   0; 0]; 
  x=linspace(0,len,61); 
  t=linspace(0,2*len/a,61);
end

% Compute the solution as 
%    Y=[F(X+a*T)+F(X-a*T)]/2 
% where
%    F(-X)=F(X) and F(X+2*len)=F(X). 
% Thus, F(X) is an odd valued function of 2*len. 
% The initial condition Y(X,0)=F(X) is initially
% defined for 0 <= X < =len, so values of ABS(X) 
% must be reduced modulo 2*len and the values 
% ABS(X)>len can then be evaluated as
%    -sign(X)*F(2*len-ABS(X)) 

xd=[xd(:);flipud(2*len-xd(:))];
yd=[yd(:);-flipud(yd(:))]; [T,X]=meshgrid(t,x);
[n1,n2]=size(X); xp=X(:)+a*T(:); xm=X(:)-a*T(:);

Y=(lintrp(xd,yd,rem(xp,2*len))+...
   lintrp(xd,yd,rem(abs(xm),2*len)).*sign(xm))/2;
%Y=(interp1(xd,yd,rem(xp,2*len))+...
%   interp1(xd,yd,rem(abs(xm),2*len)).*sign(xm))/2;

Y=reshape(Y,n1,n2);

if nargin ==0  % Plot surface for default data
   while 0
   % surf(X,T,Y); 
   colormap default
   mesh(X,T,Y)
   %surfl(X,T,Y), shading interp
  title(['Deflection Surface for a ', ...
         'Vibrating String']);
   colormap([0,0,1])
   axis('off'); figure(gcf); 
   disp(' '); %genprint('deflsurf');
   dumy=input(...
     'Press [Enter] for animated motion','s');
  end
  titl='WAVES IN A STRING WITH FIXED ENDS';
  smotion(X(:,1),Y',titl);
end

%==============================================

function smotion(x,y,titl)
%
% smotion(x,y,titl)
% ~~~~~~~~~~~~~~~~~
% This function animates the string motion.
%
% x    - a vector of position values along the
%        string
% y    - a matrix of transverse deflection 
%        values where successive rows give
%        deflections at successive times
% titl - a title shown on the plot (optional)
%
% User m functions required: none
%----------------------------------------------

if nargin < 3, titl=' '; end
xmin=min(x); xmax=max(x);
ymin=min(y(:)); ymax=max(y(:));
[nt,nx]=size(y); clf reset; 
for k=1:2
  for j=1:nt
    plot(x,y(j,:),'b',0,0,'ob',xmax,0,'ob');
    axis([xmin,xmax,2*ymin,2*ymax]);
    axis('off'); title(titl);
    drawnow; figure(gcf); pause(.05)
  end
end

%==============================================

function y=lintrp(xd,yd,x)
%
% y=lintrp(xd,yd,x)
% ~~~~~~~~~~~~~~~~~
% This function performs piecewise linear 
% interpolation through data values stored in 
% xd, yd, where xd values are arranged in 
% nondecreasing order. The function can handle 
% discontinuous functions specified when two
% successive values in xd are equal. Then the 
% repeated xd values are shifted by a tiny 
% amount to remove the discontinuities. 
% Interpolation for any points outside the range 
% of xd is also performed by continuing the line 
% segments through the outermost data pairs.
%
% xd,yd - data vectors defining the 
%         interpolation
% x     - matrix of values where interpolated 
%         values are required
%
% y     - matrix of interpolated values
%
% NOTE:  This routine is dependent on MATLAB
%        Version 5.x function interp1q.  A
%        Version 4.x solution can be created
%        by renaming routine lntrp.m to
%        lintrp.

xd=xd(:); yd=yd(:); [nx,mx]=size(x); x=x(:);
xsml=min(x); xbig=max(x);
if xsml<xd(1)
 ydif=(yd(2)-yd(1))*(xsml-xd(1))/(xd(2)-xd(1));
 xd=[xsml;xd]; yd=[yd(1)+ydif;yd];
end
n=length(xd); n1=n-1;
if xbig>xd(n)
  ydif=(yd(n)-yd(n1))*(xbig-xd(n))/ ...
       (xd(n)-xd(n1));
  xd=[xd;xbig]; yd=[yd;yd(n)+ydif];
end
k=find(diff(xd)==0);
if length(k)~=0
  n=length(xd);
  xd(k+1)=xd(k+1)+(xd(n)-xd(1))*1e3*eps;
end
y=reshape(interp1q(xd,yd,x),nx,mx);