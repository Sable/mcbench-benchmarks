function Xout = selectCc(Xin, conn, varargin)
% SELECTCC  Select object(s) in binary N-D array. Replaces Matlab's "bwselect"
% (minus the interactive mode) which is limited to 2D matrices.
%
% Inputs:
% -------
%   Xin - input N-D array. Required.
%   conn - connectivity definition, can be either a scalar or connectivity
%       array, with same number of dimensions as the input array. If empty
%       or omitted , conn will be set to scalar 3^ndims(Xin)-1.
%   I or I1, I2, ... - selected indices (single linear index or series of 
%       subscripts for each dimension of the input array.
%
% Outputs:
% --------
%   Xout - Output N-D array (same size as Xin), with only the connected-components
%       objects which overlap the indices set.
%
% Comments and questions to: rans8a@gmail.com.

% Error checking
if ~islogical(Xin), error('%s: error - works only for logical input', mfilename); end

% Connectivity
if (~exist('conn', 'var') || isempty(conn)), conn = conndef(ndims(Xin), 'maximal'); end

% Getting linear indices
if (length(varargin) == 1)
    ind = varargin{1};
elseif (length(varargin) ~= ndims(Xin))
    error('%s: error - wrong number of subscript indices', mfilename);
else
    ind = sub2ind(size(Xin), varargin{:});
end

% connected-components
cc = bwconncomp(Xin,conn);
% Label matrix
L = labelmatrix(cc);
% Getting the labels of the selected connected-components
l = unique(L(ind));
% Removing the background pixels (if any)
l(l==0) = [];

% For each label (connected-components object intersected with the selected
% indices), set it in the output array.
Xout = false(size(Xin));
for i=1:length(l)
    ind = cc.PixelIdxList{l(i)};
    Xout(ind) = true;
end
