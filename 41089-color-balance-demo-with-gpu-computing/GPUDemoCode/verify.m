% Run the data through the two implementations
% Copyright 2013 The MathWorks, Inc.
tic
adjustedImageCPU = whitebalance(imageData);
tCPU = toc;

tic
adjustedImageGPU = whitebalance_cuda(imageData);
tGPU = toc;

% Display timing measurements and figures
fprintf('The time required for computation on CPU is %f.\n',tCPU);
fprintf('The time required for computation on GPU is %f.\n',tGPU);
figure 
subplot(1,2,1), image(adjustedImageCPU); title('CPU output')
subplot(1,2,2), image(adjustedImageGPU); title('GPU output')
pos = [362, 702, 1261, 396];
set(gcf,'position',pos);

% Hard verification that the results are identical
difference = double(adjustedImageCPU(:) - adjustedImageGPU(:));
msgbox(['The norm of the difference is ',num2str(norm(difference))])