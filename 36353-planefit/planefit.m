function C = planefit(x,y,z)
%% A function to fit x,y,z, data to a plane in 3D space.
%
% z = x * C(1) + y*C(2) + C(3);
%
% Example:
% --------
% x = -10:10;
% y = -10:10;
% [xx yy] = meshgrid(x,y);
% zz = C(1)*xx+C(2)*yy + C(3) + 2*randn(size(xx));
% plot3(xx(:),yy(:),zz(:),'.')
% C = planefit(xx(:),yy(:),zz(:));
% zzft = C(1)*xx+C(2)*yy + C(3);
% hold on;
% surf(xx,yy,zzft,'edgecolor','none')
% grid on
%
% Val Schmidt
% Center for Coastal and Ocean Mapping
% University of New Hampshire
% copywrite 2012

xx = x(:);
yy = y(:);
zz = z(:);
N = length(xx);
O = ones(N,1);

C = [xx yy O]\zz;

