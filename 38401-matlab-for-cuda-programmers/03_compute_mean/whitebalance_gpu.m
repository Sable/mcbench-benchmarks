function adjustedImage = whitebalance_gpu(imageData)
	% WHITEBALANCE forces the average image colour to be gray.
    % Copyright 2013 The MathWorks, Inc.	
    
	% Move the data to the GPU
	imageDataGPU = gpuArray(imageData);
	
	%**************************************
	% Find the average values for each channel.
	avg_rgb = computeMeanMEX(imageDataGPU);
	
	%***********************************************************
	% Compute the factors from the mean.
	computeFactorsKernel = parallel.gpu.CUDAKernel( ...
		'computeScaleFactors.ptxw64', 'computeScaleFactors.cu' );
	computeFactorsKernel.SharedMemorySize = 3*8; %3 doubles of shared memory
	computeFactorsKernel.ThreadBlockSize = [3 1 1];		
	factors = feval( computeFactorsKernel, avg_rgb, 3 );	
	
	%***********************************************************
	% Apply the scaling factors		
	applyFactorsKernel = parallel.gpu.CUDAKernel(...
		'applyScaleFactors.ptxw64', ...
		'applyScaleFactors.cu' );			
	
	% Set up the threads
	[nRows, nCols, ~] = size(imageDataGPU);
	blockSize = 256;
	applyFactorsKernel.ThreadBlockSize = [blockSize, 1, 3];
	applyFactorsKernel.GridSize = [ceil(nRows/blockSize), nCols];
		
	% Allocate and initialize return data, directly on the GPU
	adjustedImageGPU = gpuArray.zeros( size(imageDataGPU), 'uint8');
	
	% Apply the kernel to scale the color values
	adjustedImageGPU = feval( applyFactorsKernel, adjustedImageGPU, ...
        imageDataGPU, factors, nRows, nCols );
	
	% Copy data from the GPU back to main memory.
	adjustedImage = gather( adjustedImageGPU );	
end
