% Demo on fitting data in 3D via TLS method
clear all; close all;
if ~(exist('fit_3D_data', 'file') == 2)
    P = requireFEXpackage(12395);  
    % fminsearchbnd is part of 12395 at MathWorks.com
end 
load switzerland.giu
x=switzerland(:,2); 
y=switzerland(:,3);
z=switzerland(:,4);
[Err, N, P]=fit_3D_data(x,y,z,'plane','on','on');
xlabel('GDP');
ylabel('Inflation');
zlabel('Unemployment');
title('Swiss economy for years 1980-2008')