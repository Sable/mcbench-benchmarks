function cost = phcost(params,freq,phdesired,pnorm)
% This function evaluates the p-norm cost of the phase shift network.
% params (Nx2)	matrix of parameters
% freq	 (1xM)	frequency vector (in Hz)
% phdesired desired phase lag of second output referenced to first output (in deg.)

[dummy,M] = size(freq);

%params = abs(params);		% take absolute values of params in case negatives poped up
phase = phfunc(params,freq);	% compute the phase at all freqs for both legs (2xM).
phaseerr = phase(2,:) - phase(1,:) - phdesired;	% compute phase error vector (1xM)
cost = (sum(abs(phaseerr(:)).^pnorm)^(1/pnorm))/(2*M);		% compute normalized cost measure (p-norm)
return

