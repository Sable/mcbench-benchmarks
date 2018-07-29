% Copyright 2009 - 2010 The MathWorks, Inc.
function ObjTrack02(position)
%#eml
eml.extrinsic('figure','hold','grid');
% Figure setup
numPts = 300;
figure;hold;grid;

% Kalman filter loop
for idx = 1: numPts
    % Get the input data
    z = position(:,idx);

    % Use Kalman filter to estimate the location
    y = kalman01(z);
    
    % Plot the results
    plot_trajectory(z,y);
end
hold;
end