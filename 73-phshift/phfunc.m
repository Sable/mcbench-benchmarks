function phase = ph(params,freq)
% This function computes the phase of an analog allpass network with 2 legs and N sections.
% The phase is evalutated at the set of frequencies given in the vector: freq.
% function phase = ph(params,freq)
%
% Inputs:
% params (Nx2)	Matrix of parameters (1/RC for 2 legs and N sections)
% freq	(1xM)	frequency vector (in Hz)
% 
% Output:
% phase	(2xM)	output phase vector in deg.

[N,L] = size(params);
[dummy,M] = size(freq);

temp = zeros(N,2*M);		% set array size
%temp(:) = 180 - (360/pi)*atan(2*pi*(1./(10.^params(:)))*freq);	% compute phase matrix
temp(:) = (360/pi)*atan(2*pi*(1./(10.^params(:)))*freq);	% compute phase matrix (ignor the fact that each stage inverts signal)
phase = zeros(2,M);			% set array size
phase(:) = sum(temp,1);		% sum up the phase over N cascaded sections
return

