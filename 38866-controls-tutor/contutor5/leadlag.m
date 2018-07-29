function [lead_cplx,z,p]=leadlag(phi,wd,w,T)
%
% Utility function: LEADLAG
%
% The purpose of this function is to compute the pole and zero needed to
% achieve the desired phase change with a lead/lag element.

% Author: Craig Borghesani
% Date: 9/6/93
% Revised:
% Copyright (c) 1999, Prentice-Hall

narg_vals = nargin;
if narg_vals==4,
 if ~length(T),
  narg_vals=3;
 end
end

if narg_vals==3,
 alpha=(1-sin(abs(phi*pi/180)))/(1+sin(abs(phi*pi/180)));
 a=wd*sqrt(alpha);
 b=wd/sqrt(alpha);
 if nargout==1,
  ca=realpole(a,w,sign(phi)); cb=realpole(b,w,-sign(phi));
  lead_cplx=ca.*cb;
 else
  if sign(phi)<0,
   z=sprintf('%0.4f',b);
   p=sprintf('%0.4f',a);
  else
   z=sprintf('%0.4f',a);
   p=sprintf('%0.4f',b);
  end
 end
else
 x=cos(wd*T)+sin(phi*pi/180);
 y=sin(phi*pi/180)*cos(wd*T)+1;
 a=-(-y+sqrt(y^2-x^2))/x;
 b=-((sin(phi*pi/180)-a)/(-a*sin(phi*pi/180)+1));
 ac=-log(a)/T; bc=-log(b)/T;
 if nargout==1,
  ca=realpole(ac,w,[1 T]); cb=realpole(bc,w,[-1 T]);
  lead_cplx=ca.*cb;
 else
  z=sprintf('%0.8f',a);
  p=sprintf('%0.8f',b);
 end
end