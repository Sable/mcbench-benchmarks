function z=vp(x,y)

% z=vp(x,y); z = 3d cross product of x and y
% vp(x) is the 3d cross product matrix : vp(x)*y=vp(x,y).
%
% by Giampiero Campa.  

z=[  0    -x(3)   x(2);
    x(3)    0    -x(1);
   -x(2)   x(1)    0   ];

if nargin>1, z=z*y; end
