function loc_2d_shapes(NumOfSamples)
% Create Localized 2-d data from uniform distribution.
% Data are bount to the rectangle between points A(0,6) and B(4,10),
% a circle with center at C(7.5,2.5) and radius R = 2,
% and an isosceles triangle defined by the intesection points
% of the lines y=6, y=2x-5 and y=-2x+25.
% Every local set has the same number of samples (NumOfSamples/4).

clc;
input_dims = 2;

% Initialize Sample counters.
k1 = 0; k2 = 1; k3 = 0; k4 = 0;

% Initialize Data
Data = [7.5; 2.5;];

while size(Data,2)<NumOfSamples

In1 = 10*rand(input_dims,1);

% Apply Mask to input Data
if (In1(1,1)<4)&&(In1(1,1)>0)&&(In1(2,1)<10)&&(In1(2,1)>6)&&(k1<=NumOfSamples/4)
    Data = [Data In1];
    k1 = k1 + 1;
elseif norm(In1-[7.5; 2.5;])<=2&&(k2<=NumOfSamples/4)
    Data = [Data In1];
    k2 = k2 + 1;
elseif (In1(2,1)>6)&&(In1(2,1)<2*In1(1,1)-5)&&(In1(2,1)<-2*In1(1,1)+25)&&(k3<=NumOfSamples/4)
    Data = [Data In1];
    k3 = k3 + 1;
elseif (abs(In1(2,1)-In1(1,1))<.1)&&(In1(2,1)<5)&&(In1(2,1)>.5)&&(In1(1,1)<5)&&(In1(1,1)>.5)&&(k4<=NumOfSamples/4)
    Data = [Data In1];
    k4 = k4 + 1;
end 
end

a = randperm(NumOfSamples);
Data = Data(:,a);

save local_uniform_2d Data;
plot(Data(1,:),Data(2,:),'.','MarkerSize',1);
grid on;
clear;