function plotStream(sx,sy,samplesNum,startFrom)
% PLOTSTREAM  Plots a pair of streams (x,y) for a certain number of samples
if nargin<4 startFrom=1; end
plot(cell2mat(streamRange(sx,startFrom,samplesNum)), ...
     cell2mat(streamRange(sy,startFrom,samplesNum)));
