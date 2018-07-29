function [i, nnbins] = bin(x, dx, x0, x1);
%
% [i, nbins] = bin(x, dx, x0, x1);
%
% Returns the vector of indices, starting from 1, 
% corresponding to the chosen bin size, dx, 
% start x0 and end x1. If x1 is omitted, x1 = max(x) - dx/2. 
% If x0 is omitted, x0 = min(x) + dx/2. If dx is omitted, the data 
% are divided into 10 classes. Note that outliers are not removed.
%
% Tested under MatLab 4.2, 5.0, and 5.1.
%

% 17.1.97, Oyvind.Breivik@gfi.uib.no.
%
% Oyvind Breivik
% Department of Geophysics
% University of Bergen
% NORWAY

N = 10; % Default is 10 classes

if nargin < 2
 dx = (max(x) - min(x))/N;
end
if nargin < 3
 x0 = min(x) + dx/2;
end
if nargin < 4
 x1 = max(x) - dx/2;
end
nbins = round((x1 - x0)/dx) + 1;
i = round((x - x0)/dx) + 1;
%in = (i >= 1) & (i <= nbins); % Indices are within range [1, nbins]. 
%i = i(in);

if nargout > 1
 nnbins = nbins;
end
