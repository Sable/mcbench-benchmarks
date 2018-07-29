function loc_3d_torus(NumOfSamples)

% Create Localized 3-d data from uniform distribution.
% Data are bount to the neighborhood near a torus surface.
% Torus surface equation:
%
%         (c - sqrt(x^2+y^2))^2 + z^2 = a^2
%
% This torus is created by revoloution around z axis of a circle centered
% at (c,0) with radious a. 

clc;
input_dims = 3;

a = 1;
a1 = .9;
c = 5;
% Initialize Data
Data = [];

while size(Data,2)<NumOfSamples

In1 = 20*(rand(input_dims,1)-.5);

% Apply Mask to input Data
if abs(In1(3,1))<= sqrt(a^2 - (c-sqrt(In1(1,1)^2 + In1(2,1)^2))^2) && ...
                                                                       abs(In1(3,1))>=sqrt(a1^2 - (c-sqrt(In1(1,1)^2 + In1(2,1)^2))^2)
    Data = [Data In1];
end 
end

a = randperm(NumOfSamples);
Data = Data(:,a);

save local_torus Data;
plot3(Data(1,:),Data(2,:),Data(3,:),'.','MarkerSize',1);
grid on;
clear all;