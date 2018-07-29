%% RUNSCRIPT 
% RUNSCRIPT contains the MATLAB commands for performing the color-balance
% operation in the MATLAB GPU Computing Segment. 
% Copyright 2013 The MathWorks, Inc.

%% Load the image data and visualize it
load imageData.mat
figure(1),image(imageData),title('Original Image')

%% Profile whitebalance.m (running entirely on CPU)

% profile it
profile on
whitebalance(imageData);
profile off

% show the report on whitebalance.m (don't forget to scroll to the bottom)
profview


%% Run and time several invocations of whitebalance.m
% Timing several invocations provides a more accurate idea of the average
% execution time.  The first time alone can take longer because MATLAB
% caches information on the file.
fprintf('Running whitebalance.m ...\n');
tic; whitebalance(imageData); toc
tic; whitebalance(imageData); toc
tic; whitebalance(imageData); toc
tic; whitebalance(imageData); toc
fprintf('\n');



%% Run and time several invocations of whitebalance_gpu.m (which uses the gpuArray function)
fprintf('Running whitebalance_gpu.m ...\n');
tic; whitebalance_gpu(imageData); toc
tic; whitebalance_gpu(imageData); toc
tic; whitebalance_gpu(imageData); toc
tic; whitebalance_gpu(imageData); toc
fprintf('\n');



%% Run and time several invocations of whitebalance_cuda.m (which uses interface to ptx file associated with CUDA kernel)
fprintf('Running whitebalance_cuda.m ...\n');
tic; whitebalance_cuda(imageData); toc
tic; whitebalance_cuda(imageData); toc
tic; whitebalance_cuda(imageData); toc
tic; whitebalance_cuda(imageData); toc
fprintf('\n');


%% Run verify.m
verify




















