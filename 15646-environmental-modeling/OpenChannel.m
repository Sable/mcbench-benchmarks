function OpenChannel
% Open Channel Flow - energy height and water depth 
%    using MATLAB ode                   
%
%   $Ekkehard Holzbecher  $Date: 2006/04/27 $
%--------------------------------------------------------------------------
g = 10;       % acceleration due to gravity [m*m/s]
beta = 0.3;   % angle of ground inclination 
q = 1;        % discharge per unit width [m*m/s]
H = 2;        % energy height [m]

h = linspace (H/12,H,100);
plot (h,(h*cos(beta)+(q*q/2/g)*ones(size(h,1))./h./h),h,h*cos(beta));
legend ('Possible states','Asympotic line');
title ('constant discharge');
xlabel ('water level above ground');
ylabel ('energy height'); 