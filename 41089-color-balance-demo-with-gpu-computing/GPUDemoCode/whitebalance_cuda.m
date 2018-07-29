function adjustedImage = whitebalance_cuda(imageData)
% WHITEBALANCE forces the average image color to be gray
% Copyright 2013 The MathWorks, Inc.

% Find the average values for each channel
pageSize = size(imageData,1) * size(imageData,2);
avg_rgb = mean( reshape(imageData, [pageSize,3]) );
	
% Find the average gray value and compute the scaling factor
avg_all = mean(avg_rgb);
factor = max(avg_all, 128)./avg_rgb;
factor = reshape(factor,1,1,3);

% Load the kernel and set up threads
kernel = parallel.gpu.CUDAKernel('whitebalanceKernel.ptxw64','whitebalanceKernel.cu' );
[nRows, nCols,~] = size(imageData);
blockSize = 256;
kernel.ThreadBlockSize = [blockSize, 1, 3];
kernel.GridSize = [ceil(nRows/blockSize), nCols];

% Copy image data to the GPU and allocate and initialize return data
imageDataGPU = gpuArray(imageData);
adjustedImage = gpuArray.zeros( size(imageData), 'uint8');

% Adjust the image to the new gray value
adjustedImage = feval( kernel, adjustedImage, imageDataGPU, factor, nRows, nCols );	
end
