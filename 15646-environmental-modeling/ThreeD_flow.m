function ThreeD_flow
% 3D potential flow 
%    using MATLAB analytical solutions                   
%
%   $Ekkehard Holzbecher  $Date: 2006/07/19 $
%--------------------------------------------------------------------------
Q = 1;                            % source/sink-rate [L^3/T]
Qx0 = 0.2;                        % base flow [L^2/T]
i = linspace(1,3,50);
[x,y,z] = meshgrid (i,i,i);
r = sqrt((x-2).^2+(y-2).^2+(z-2).^2);
xslice = [1.3;1.7;2.4];
yslice = [3];
zslice = [1.05;1.9];
phi = -Qx0*x-Q/4/pi/r;
grid off;
slice (x,y,z,phi,xslice,yslice,zslice); hold on;
[u,v,w] = gradient (-phi);
h = streamline (x,y,z,u,v,w,ones(1,50),i,i);  
set (h,'Color','y')
% coneplot (x,y,z,u,v,w,)
