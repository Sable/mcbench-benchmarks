function pendulumDataSimulated(x0, pendulumLength, noiseFactor, outFileName)
% Generate simulated pendulum data and write this to an Excel spreadsheet.

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

if nargin<4
    outFileName = 'pendulumData.xls';
end

% Define the acceleration due to gravity.
g = 9.81; % m/s

% Determine the natural frequency of the pendulum (this is only accurate in
% the small angle regime, as we will see later).  
% This is used here as a scaling factor for the noise added to the measured 
% angular velocity of the pendulum.
omega0 = sqrt(g/pendulumLength);

% Simulate the pendulum motion
res = pendulumSimulation(x0,g,pendulumLength);

% Add noise to position and velocity
positionNoise = randn(size(res.Position))*noiseFactor*x0;
velocityNoise = randn(size(res.Position))*noiseFactor*x0*omega0;

% Include this noise into the position and velocity
res.Position = res.Position + positionNoise;
res.Velocity = res.Velocity + velocityNoise;

% Format the data for writing to the Excel spreadsheet.
colHeadings = {'Time', 'Position', 'Velocity'};
dataArray = [res.Time res.Position res.Velocity];

% Create the cell array to write to the Excel file by combining the column
% headings and the numeric simulation results.  To do this we need to
% convert the array of numeric data to a cell array using num2cell.  Use
% cell2mat to convert a cell array of numbers back to a matrix.
dataArray = [colHeadings; num2cell(dataArray)];
% Save the data
xlswrite(outFileName,dataArray);
