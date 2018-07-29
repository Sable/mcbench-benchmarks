function so = streamFilter(si,filter,varargin)
% STREAMFILTER  Filtered stream
while ~builtin('feval',filter,head(si),varargin{:})
    si = tail(si);
end
so = {head(si),delayEval(@streamFilter,{tail(si),filter,varargin{:}})};
