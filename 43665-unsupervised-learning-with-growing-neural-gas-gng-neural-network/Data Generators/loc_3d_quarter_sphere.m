function loc_3d_quarter_sphere(NumOfSamples)

% Create Localized Semi - Spherical 3-d data from uniform distribution.
% Data are bount to the neighborhood near a sphere surface.
% Sphere surface equation:
%
%         (x-x0)^2 + (y-y0)^2 + (z-z0)^2 = r^2
%
% The created data are bound in a spherical shell r1<=Data<=r2

clc;
input_dims = 3;
x0 = 0;
y0 = 0;
z0 = 0;
r1 = 5;
r2 = 5.1;
% Initialize Data
Data = [];

while size(Data,2)<NumOfSamples

In1 = 20*(rand(input_dims,1)-.5); % Uniform distribution in [-10,10]

% Apply Mask to input Data
if (abs(In1(1,1)-x0)^2 + (In1(2,1)-y0)^2 + (In1(3,1)-z0)^2 >= r1^2)...
   && (abs(In1(1,1)-x0)^2 + (In1(2,1)-y0)^2 + (In1(3,1)-z0)^2 <= r2^2)...
   && (In1(1,1)>=0) && (In1(2,1)>=0)     % x,y coordinates required to be positive.
    Data = [Data In1];
end 
end

a = randperm(NumOfSamples);
Data = Data(:,a);

save local_quartersphere Data;
plot3(Data(1,:),Data(2,:),Data(3,:),'.','MarkerSize',1);
caxis([-10 10]);
grid on;
clear all;