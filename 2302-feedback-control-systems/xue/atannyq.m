function [x,y,w]=atannyq(G,w)
if nargin==1, 
   [x0,y0,w]=nyquist(G);
elseif nargin==2, 
   [x0,y0]=nyquist(G,w); 
end
pause
x0=[x0(:,:);x0(:,:)]'; y0=[y0(:,:);-y0(:,:)]';  
pp=atan2(y0,x0); H=2/pi*atan(x0.^2+y0.^2);
x0=H.*cos(pp); y0=H.*sin(pp);
if nargout==0, 
   plot(x0,y0); max(x0),max(y0)
   xlabel('Real Axis'); 
   ylabel('Imaginary Axis')
else, x=x0; y=y0; end
