
% Clear Matlab command window.
clc;

% Example #1: Basic usage.
% Note: Filters are computed for each run.
disp('Example #1: Basic Usage');
theta = [0:15:360];
for i = [1:length(theta)]
   [J,H] = steerGauss([],theta(i),3,true);
   filters{i} = H;
   pause(0.1);
end
disp('   Press any key to continue.'); pause;

% Load "mandrill" test image.
I = imread('mandrill.jpg');

% Example #2: Using pre-computed filters.
disp('Example #2: Using pre-computed filters.');
for i = [1:length(filters)]
   [J,H] = steerGauss(I,filters{i},true);
   pause(0.1);
end