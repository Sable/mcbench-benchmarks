%%gaussdis(mean, var, x): return the gaussian(mean, var) sampled at
%%locations x.
function p = gaussdis(mean,var,x);
% return the gauss distribution with parameters mean, var.
% p = gaussdis(mean, var, x);

if nargin<3, 
   error('Requires three input arguments.'); 
end

p = 1/sqrt(2*pi*var)*exp(-((x-mean).^2)/(2*var));
