function loc_2d_4rings(NumOfSamples)
% Create Localized 2-d data from uniform distribution.
% Data are bount to the circular domains
% r1<data<r2 < r3<data<r4 < r5<data<r6 < r7<data<r8
% Every local set has the same number of samples (NumOfSamples/4).
colordef black;
clc;
input_dims = 2;
r1 = 1; r2 = 2;
r3 = 4; r4 = 5;
r5 = 7; r6 = 8;
r7 = 10; r8 = 11;

% Initialize Sample counters.
k1 = 1; k2 = 0; k3 = 0; k4 = 0;

% Initialize Data
Data = [1.5; 0.5;];

while size(Data,2)<NumOfSamples

In1 = 30*(rand(input_dims,1)-.5); % Uniform distribution in [-15,15]

% Apply Mask to input Data
if (r1<=norm(In1)) && (norm(In1)<=r2) && (k1<=NumOfSamples/4)
    Data = [Data In1];
    k1 = k1 + 1;
elseif (r3<=norm(In1)) && (norm(In1)<=r4) && (k2<=NumOfSamples/4)
    Data = [Data In1];
    k2 = k2 + 1;
elseif (r5<=norm(In1)) && (norm(In1)<=r6) && (k3<=NumOfSamples/4)
    Data = [Data In1];
    k3 = k3 + 1;
elseif (r7<=norm(In1)) && (norm(In1)<=r8) && (k4<=NumOfSamples/4)
    Data = [Data In1];
    k4 = k4 + 1;
end 
end

a = randperm(NumOfSamples);
Data = Data(:,a);

save local_circular_2d1 Data;
plot(Data(1,:),Data(2,:),'.','MarkerSize',1);
grid on;
clear;