% ranked = nrank(data,dim,mode)
%
% NRANK ranks an n-dimensional array DATA along a given dimension DIM.
% This removes amplitude information.
%
% data: data to be ranked
%  dim: dimension along which data is to be ranked
% mode: direction of the sort, 'ascend' or 'descend', default is 'ascend'
%
% See also SORT

% Created by Bill Winter December 2005
function in = nrank(in,dim,varargin)
siz = size(in);
if ~exist('dim','var'), dim = find(siz > 1,1); end
if dim ~= 1,
    per = 1:length(siz);
    per([1 dim]) = [dim 1];
    siz([1 dim]) = siz([dim 1]);
    in = builtin('permute',in,per);
end
[in in] = builtin('sort',in,1,varargin{:});
for k = 1:prod(siz(2:end)), in(in(:,k),k) = 1:siz(1); end;
if dim ~= 1, in = builtin('permute',in,per); end;