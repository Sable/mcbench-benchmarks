function [binEdges,N]=decayHistogram(decayTimes,varargin)
% decayHistogram : histogram of decay times

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $

binEdges = 0:0.5:60;
[N,X] = histc(decayTimes,binEdges);

% Ignore the last bin, this contains all events that match binEdges(end)
% Also, reshape into colmun vectors
N = reshape(N(1:end-1),[],1);
binEdges = reshape(binEdges(1:end-1),[],1);
