function [xp,yp,zp,ip,coef] = func_excludeoutlier_ellipsoid3d(xi,yi,zi,theta);
%======================================================================
%
% Version 1.01
%
% This program excludes the points outside of ellipsoid in two-
% dimensional domain
%
% Input
%   xi : input x data
%   yi : input y data
%   zi : input z data
%   theta  : angle between xi and zi
%
% Output
%   xp : excluded x data
%   yp : excluded y data
%   zp : excluded y data
%   ip : excluded array element number in xi and yi
%   coef : coefficients for ellipsoid
%
% Example: 
%   [xp,yp,zp,ip,coef] = func_excludeoutlier_ellipsoid3d(f,f_t,f_tt,theta);
%
%
%======================================================================
% Terms:
%
%       Distributed under the terms of the terms of the BSD License
%
% Copyright: 
%
%       Nobuhito Mori, Kyoto University
%
%========================================================================
%
% Update:
%       1.01    2009/06/09 Nobuhito Mori
%       1.00    2005/01/12 Nobuhito Mori
%
%========================================================================

%
% --- initial setup
%

n = max(size(xi));
lambda = sqrt(2*log(n));

xp = [];
yp = [];
zp = [];
ip = [];

%
% --- rotate data
%

%theta = atan2( sum(xi.*zi), sum(xi.^2) );

if theta == 0
  X = xi;
  Y = yi;
  Z = zi;
else
  R = [ cos(theta) 0  sin(theta); 0 1 0 ; -sin(theta) 0 cos(theta)];
  X = xi*R(1,1) + yi*R(1,2) + zi*R(1,3);
  Y = xi*R(2,1) + yi*R(2,2) + zi*R(2,3);
  Z = xi*R(3,1) + yi*R(3,2) + zi*R(3,3);
end

%test
%plot3(xi,yi,zi,'b*')
%hold on
%  plot3(X,Y,Z,'r*')
%hold off
%pause

%
% --- preprocess
%

a = lambda*nanstd(X);
b = lambda*nanstd(Y);
c = lambda*nanstd(Z);

%
% --- main
%

m = 0;
for i=1:n
  x1 = X(i);
  y1 = Y(i);
  z1 = Z(i);
  % point on the ellipsoid
  x2 = a*b*c*x1/sqrt((a*c*y1)^2+b^2*(c^2*x1^2+a^2*z1^2));
  y2 = a*b*c*y1/sqrt((a*c*y1)^2+b^2*(c^2*x1^2+a^2*z1^2));
  zt = c^2* ( 1 - (x2/a)^2 - (y2/b)^2 );
  if z1 < 0
    z2 = -sqrt(zt);
  elseif z1 > 0
    z2 = sqrt(zt);
  else
    z2 = 0;
  end

  % check outlier from ellipsoid
  dis = (x2^2+y2^2+z2^2) - (x1^2+y1^2+z1^2);
  if dis < 0 
    m = m + 1;
    ip(m) = i;
    xp(m) = xi(i);
    yp(m) = yi(i);
    zp(m) = zi(i);
  end
end

coef(1) = a;
coef(2) = b;
coef(3) = c;
