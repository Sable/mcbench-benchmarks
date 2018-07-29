function S = sparsenc(varargin)
% function S = sparsenc(...)
%
% Non-cumulative sparse creation
% Same as SPARSE(), but only an unique value is assigned in case many
% subindexes occupie the same position. By default is the last value is
% assigned.
% Use S = sparsenc(... 'first') to assign the first value in competition.
%
% Author Bruno Luong <brunoluong@yahoo.com>
% Last update: 11/April/2009

if nargin<3
    S = sparse(varargin{:});
    return
end

[i j v]=deal(varargin{1:3});
opt=varargin(4:end);
pos='last';
if ~isempty(opt)
    lastopt=opt{end};
    if ischar(lastopt) && any(strcmpi(lastopt,{'first' 'last'}))
        pos=lastopt;
        opt(end)=[];
    end
end

if strcmpi(pos,'first')
    v=v(:);
end

S = sparse([],[],[],opt{:});
S = feval(class(v), S);
S = setspvalmex(S, i(:), j(:), v(:));

