%% Compare the two implementations
% Copyright 2013 The MathWorks, Inc.

%% Run the data through the two implementations
adjustedImageCPU = whitebalance(imageData);
adjustedImageGPU = whitebalance_gpu(imageData);

%% Visualize the results and their difference
subplot(1,2,1); imshow(adjustedImageCPU); title('CUDA Implementation');
subplot(1,2,2); imshow(adjustedImageGPU); title('MATLAB Implementation');

difference = double(adjustedImageCPU(:) - adjustedImageGPU(:));
msgbox(['The norm of the difference is: ' num2str(norm(difference))]);
