function [ G,gWinLen ] = genGaborKernelF( mu,nu,sigma,scaleXY,imgSz )
% [G GWINLEN] = genGaborKernelF( MU,NU,sigma,scaleXY,imgSz )
%   G = FFT{ genGaborKernel(MU,NU,sigma,scaleXY) }
%	imgSz is the size of the image. In order to avoid loop noise of FFT,
%	size(G{1}) will be 2^nextpow2(max(imgSz)+kernal_size-1)
%	GWINLEN is the radius of the kernel, it's a input of GABORCONV

[g gWinLen] = genGaborKernel(mu,nu,sigma,scaleXY);
realSz = 2^nextpow2(max(imgSz)+gWinLen*2); % nextpow2 can speed up a little
G = cell(size(g));
for p = 1:size(g,1)
	for q = 1:size(g,2)
		G{p,q} = fft2(g{p,q},realSz,realSz);
		G{p,q}(1,1) = 0; % reduce the DC
	end
end