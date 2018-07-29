function loc_3d_sphere_shell(NumOfSamples)

% Create Localized Spherical 3-d data from uniform distribution.
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

In1 = 10.4*(rand(input_dims,1)-.5); % Uniform distribution in [-5.2 5.2]

% Apply Mask to input Data
if ((In1(1,1)-x0)^2 + (In1(2,1)-y0)^2 + (In1(3,1)-z0)^2 >= r1^2) && ((In1(1,1)-x0)^2 + (In1(2,1)-y0)^2 + (In1(3,1)-z0)^2 <= r2^2)
      Data = [Data In1];
end 
end

a = randperm(NumOfSamples);
Data = Data(:,a);

save local_sphere_shell Data;
plot3(Data(1,:),Data(2,:),Data(3,:),'.','MarkerSize',1);
grid on;
clear all;