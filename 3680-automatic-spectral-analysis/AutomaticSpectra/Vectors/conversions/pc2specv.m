function [h, fs] = pc2specv(pc,R0,fn,T)

%function [h, fs] = pc2specv(pc,R0,fn,T)
% Transforms partial correlations pc into the cross power spectrum h.
%
% If only a specific cross-or autospectrum is needed, PC2XSPECV is faster.

%S. de Waele, March 2003.

%Input checking and analysis
if ~isstatv(pc), error('Partial correlations non-stationairy!'), end
if ~exist('T'), T = 1; end
if ~exist('fn'), fn = 200; end

s = kingsize(pc);
order = s(3)-1;
dim = s(1); I = eye(dim);


%Forming the vector of frequencies
if length(fn)~=1,
   fs = fn/2; %input fs between 0-1: true frequencies between 0:.5
end
if length(fn) == 1,
   fs = (0:fn-1)/fn/2;
end
nspec = length(fs);


%Calculation of the power spectrum
[par, parb, Pf, Pb] = pc2parv(pc,R0);
Peps = Pf(:,:,end);

h = zeros(dim,dim,nspec);
fs = fs/T;
for t = 1:nspec,
	f = fs(t);
	Af = I;
	e = exp(-i*2*pi*T*f);
	for k = 1:order
		Af = Af+e^k*par(:,:,k+1);
	end
   Afi = inv(Af);
	h(:,:,t) = T*Afi*Peps*Afi';
end