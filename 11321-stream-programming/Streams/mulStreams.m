function so = mulStreams(varargin)
% MULSTREAMS  Mul a set of streams (only for numerics, uses prod)
so = streamCompose(varargin,@mulVals);

function ris = mulVals(varargin)
ris = prod(cell2mat(varargin));
