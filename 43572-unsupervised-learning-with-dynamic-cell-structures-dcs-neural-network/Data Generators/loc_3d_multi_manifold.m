function loc_3d_multi_manifold(NumOfSamples)

% Create Localized 3-d manifold data from uniform distribution.
% Data are bount to the neighborhood near a cuboid connected in series
% with a thin plate, a slim line segment (cylinder) and a spherical shell
% with pole caps removed.

clc; clear;
input_dims = 3;

% Define major scale parameter.
r = 1;

% Sphere Shell Characteristics.
x0 = r;
y0 = 6*r;
z0 = r/2;

r1 = r;
r2 = r+r/50;
% Initialize Data
Data = [];  k1 = 0; k2 = 0; k3 = 0; k4 = 0;

while size(Data,2)<NumOfSamples

x = 2*rand;
y = 7*rand;
z = rand;

In1 = [x; y; z;];

% Apply Mask to input Data
        % The first branch generates NumOfSamples/4 uniformly distributed data points in
        % the cuboid defined by the corners (A,B,C,D,E,F,G,H) = [(0,0,0),(0,1,0),(0,1,1),(0,0,1),(2,0,1),(2,0,0),(2,1,0),(2,1,1)];
    if  (x<=2*r && x>0) && (y<=r && y>0) && (z<=r && z>0) && (k1<=NumOfSamples/4)
        Data = [Data In1];
        k1 = k1 + 1;
        % The next branch generates NumOfSamples/4 uniformly distributed data points in
        % the horizontal plate defined by the corners (A,B,C,D) = [(0,1,1/2),(0,3,1/2),(2,3,1/2),(2,1,1/2)]
        % and thickness = r/30;
    elseif  (x<=2*r && x>0) && (y<=3*r && y>r) && (z<=r/2+r/60 && z>r/2-r/60) && (k2<=NumOfSamples/4)
        Data = [Data In1];
        k2 = k2 + 1;
        % The next branch generates NumOfSamples/4 uniformly distributed data points in
        % the horizontal cylinder defined starting from  (1,3,1/2) and ending at (1,5,1/2)
        % and thickness = r/30;
    elseif  (x<=r+r/60 && x>r-r/60) && (y<=5*r && y>3*r) && (z<=r/2+r/60 && z>r/2-r/60) && (k3<=NumOfSamples/4)
        Data = [Data In1];
        k3 = k3 + 1;
        % The last branch generates NumOfSamples/4 uniformly distributed data points in
        % the spherical shell with center (1,6,1/2), radious r = 1 and thickness = 1/50; 
        % The pole caps of the sphere are removed for z>1 or z<0 on purpose for better visual results.
    elseif ((x-x0)^2 + (y-y0)^2 + (z-z0)^2 >= r1^2) && ((x-x0)^2 + (y-y0)^2 + (z-z0)^2 <= r2^2) && (k4<=NumOfSamples/4)
        Data = [Data In1];
        k4 = k4 + 1;
    end 
    
end

a = randperm(NumOfSamples);
Data = Data(:,a);

save multi_manifold_3d Data;
plot3(Data(1,:),Data(2,:),Data(3,:),'.','MarkerSize',1);
grid on;
clear all;