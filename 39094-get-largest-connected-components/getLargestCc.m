function [Xout rp] = getLargestCc(Xin, conn, n)
% GETLARGESTCC  Returns n largest connected-components in the input N-D array.
%
% Inputs:
% -------
%   Xin - input N-D array. Required.
%   conn - connectivity definition, can be either a scalar or connectivity
%       array, with same number of dimensions as the input array. If empty
%       or omitted , conn will be set to scalar 3^ndims(Xin)-1.
%   n - Number of returned largest connected-components. If omitted, n will
%       be set to 1. If n is greater than N, the actual number of connected-components
%       in the array, N will be used instead.
%
% Outputs:
% --------
%   Xout - Output N-D array (same size as Xin), with only the n largest
%       connected-components indices set.
%   rp - 1-n array of structures containing information about the size of
%       the connected-components and their indices, arranged in descending
%       order.
%
% Comments and questions to: ran.shadmi@gmail.com.

% Error checking
if ~islogical(Xin), error('%s: error - works only for logical input', mfilename); end

% Connectivity
if (~exist('conn', 'var') || isempty(conn)), conn = conndef(ndims(Xin), 'maximal'); end

% Number of largest connected-components to return
if ~exist('n', 'var'), n = 1; end
if (n < 1), error('%s: error - n can''t be less than 1', mfilename); end

% Getting connected-components structure, aborting if empty
cc = bwconncomp(Xin,conn);
if (cc.NumObjects == 0), error('%s: error - input array is empty', mfilename); end
% Getting more information about the connected-components
rp = regionprops(cc, 'Area', 'PixelIdxList');
% Sorting by size, largest first
[~, ind] = sort([rp.Area], 'descend');
% Keeping only the n largest connected-components
rp = rp(ind);

% Setting relevant indices in the output array
Xout = false(size(Xin));
n = min(n,length(rp));
for i=1:n, Xout(rp(i).PixelIdxList) = true; end

% Keeping only the statistics of the n largest connected-components
rp = rp(1:n);
