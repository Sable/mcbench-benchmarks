% Copyright 2009 - 2010 The MathWorks, Inc.
% Figure setup
clear all;
load position.mat
Idx=[ 1 10;   % Size 10
     11 30;      % Size 20
     31 70;      % Size 40
     71 100;     % Size 30
    101 200;    % Size 100
    201 250     % Size 50
    251 300];   % Size 50

figure;hold;grid;
% Kalman filter loop
for i = 1:size(Idx,1)
    % Get the input data
    z = position(1:2,Idx(i,1):Idx(i,2));

    % Use Kalman filter to estimate the location
    y = kalman03(z);
    
    % Plot the results
    for n=1:size(z,2)
    plot_trajectory(z(:,n),y(:,n));
    end
end
hold;
