function [ output_args ] = CudaConvolution( input_args )
% CUDACONVOLUTION Download description
% Please download the  
%
% <a href="matlab: web('http://www.tytec.de/trial/cuda/Matlab/Cuda_4.2_FFT_Convolution_Filter_64Bit.zip')">64 Bit CUDA 4.2 MEX files here.</a>
%
% and download the
%
% <a href="matlab: web('http://www.tytec.de/trial/cuda/Matlab/Cuda_4.2_FFT_Convolution_Filter_32Bit.zip')">32 Bit CUDA 4.2 MEX files here.</a>
%
% and download the 
%
% <a href="matlab: web('http://www.nvidia.com/Download/index.aspx?lang=en-us')">NVIDIA driver version 190.38 for your OS from here.</a>
%
realKernel = double(1:5);
imagKernel = double(1:5);
realKernel(:)= 0.127;
imagKernel(:)= 0;

% Construct the filter kernel
Filter_Kernel = complex(realKernel,imagKernel);

imagSignal = double(1:2^15);

time = 0:(1/2^15):(1-1/2^15);
idealSignal = sin(2*pi*5*time);

realSignal = idealSignal + randn(size(time))/2;
imagSignal(:) = 0;

% Construct the signal
Signal_1D_Complex = complex(realSignal,imagSignal);

% Convolution of kernel and signal on the CUDA device
filteredSignal = cuFilter(Signal_1D_Complex,Filter_Kernel);

plot(realSignal,'b');hold;
plot(real(filteredSignal),'m');
plot(idealSignal,'g');