function [hab, fs] = pc2xspecv(pc,R0,a,b,fn,T)

%function [hab, fs] = pc2xspecv(pc,R0,a,b,fn,T)
% Transforms partial correlations pc into the cross power spectrum hab.
%
% Hab is the spectrum of the covariance between the scalar signals
% a[n] = a*x[n] and
% b[n] = b*x[n].
%
% EXAMPLE:
% The cross-spectrum between the x-component and the y-component is obtained
% by setting
% a = [ 1 0];
% and
% b = [ 0 1].
%
% rest as in PC2SPECV.

%S. de Waele, March 2003.

%Input checking and analysis
a = a(:)'; b = b(:)'; %Making sure a and b are horizontal
if ~isstatv(pc), error('Partial correlations non-stationairy!'), end
if ~exist('T'), T = 1; end
if ~exist('fn'), fn = 200; end
%if ~exist('R0'), R0 = I; end
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


%Calculation of the cross-spectrum
[par, parb, Pf, Pb] = pc2parv(pc,R0);
Peps = Pf(:,:,end);

hab = zeros(nspec,1);
fs = fs/T;
for t = 1:nspec,
	f = fs(t);
	Af = I;
	e = exp(-i*2*pi*T*f);
	for k = 1:order
		Af = Af+e^k*par(:,:,k+1);
	end
	hab(t) = T*dot(Af'\a',Peps*(Af'\b'));
end	
