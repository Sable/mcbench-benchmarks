%% Run the data through the two implementations
adjustedImageCPU = whitebalance(imageData);
adjustedImageGPU = gather(whitebalanceMEX(gpuArray(imageData)));

%% Visualize the results and their difference
subplot(1,2,1); imshow(adjustedImageCPU); title('CPU Output');
subplot(1,2,2); imshow(adjustedImageGPU); title('GPU Output');

difference = double(adjustedImageCPU(:) - adjustedImageGPU(:));
msgbox(['The norm of the difference is: ' num2str(norm(difference))]);
