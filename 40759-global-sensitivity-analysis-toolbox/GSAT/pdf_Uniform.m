%% pdf_Uniform: Uniform Probability Density Function
%
% Usage:
%   x = pdf_Uniform(N, range, seed)
%
% Inputs:
%     N                scalar, number of samples
%     range            vector [min max] range of the random variable
%     seed             optional, seed for the random number generator
%
% Output:
%     x                vector with the sampled data
%                      if N==0 -> x = range 
%
% ------------------------------------------------------------------------
% See also 
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 28-01-2011
%
% History:
% 1.0  28-01-2011  First release.
%%

function x = pdf_Uniform(N, range, seed)

if nargin>2
    rand('twister',seed);
else
    rand('twister', round(cputime*1000 + 100000*rand));
end

if N==0
    x = range(:)';
else
    x = rand(N,1)*diff(range) + range(1);
end
    
