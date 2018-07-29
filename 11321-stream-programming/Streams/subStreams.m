function so = subStreams(s1,s2)
% SUBSTREAMS  Subtract streams
so = streamCompose({s1,s2},@subVals);

function ris = subVals(v1,v2)
ris = v1-v2;