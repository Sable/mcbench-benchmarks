function adjustedImage = whitebalance_gpu(imageData)
	% WHITEBALANCE_GPU forces the average image color to be gray.
    % Copyright 2013 The MathWorks, Inc.
	
	% Find the average values for each channel.
	avg_rgb = mean(mean(imageData));
	
	% Find the average gray value and compute the scaling factor.
	factors = max(mean(avg_rgb), 128)./avg_rgb;
	
	% Load the kernel
	kernel = parallel.gpu.CUDAKernel('applyScaleFactors.ptxw64', ...
		'applyScaleFactors.cu' );
	
	% Set up the threads
	[nRows, nCols, ~] = size(imageData);
	blockSize = 256;
	kernel.ThreadBlockSize = [blockSize, 1, 3];
	kernel.GridSize = [ceil(nRows/blockSize), nCols];
	
	% Copy our image data to the GPU
	imageDataGPU = gpuArray( imageData );
	
	% Allocate and initialize return data, directly on the GPU
	adjustedImageGPU = gpuArray.zeros( size(imageDataGPU), 'uint8');
	
	% Apply the kernel to scale the color values
	adjustedImageGPU = feval( kernel, adjustedImageGPU, imageDataGPU, ...
		factors, nRows, nCols );
	
	% Copy data from the GPU back to main memory.
	adjustedImage = gather( adjustedImageGPU );	
end
