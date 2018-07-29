function [ex,ey,ez] = quat2xyz(q)
%QUAT2XYZ  Convert quaternion to XYZ Euler angles
%   [EX,EY,EZ] = QUAT2XYZ(Q) converts the quaternion Q to its
%   corresponding Euler angle representation.
%
% © Copyright Phil Tresadern, University of Oxford, 2006

X = q(1); Y = q(2); Z = q(3); W = q(4);
 
xx	= X * X;
xy	= X * Y;
xz	= X * Z;
xw	= X * W;

yy	= Y * Y;
yz	= Y * Z;
yw	= Y * W;

zz	= Z * Z;
zw	= Z * W;
	
twopi = 2*pi;

ex	= mod(atan2(2*(yz+xw), W^2 - xx - yy + zz), twopi);
ey	= mod(asin(2*(yw-xz)), twopi);
ez	= mod(atan2(2*(xy+zw), W^2 + xx - yy - zz), twopi);
	

