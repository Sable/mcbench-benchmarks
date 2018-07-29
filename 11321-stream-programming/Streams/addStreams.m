function so = addStreams(varargin)
% ADDSTREAMS  Add a set of streams (only for numerics, uses sum)
so = streamCompose(varargin,@sumVals);

function ris = sumVals(varargin)
ris = sum(cell2mat(varargin));
