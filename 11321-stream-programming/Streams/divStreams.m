function so = divStreams(s1,s2)
% DIVSTREAMS  Divide streams
so = streamCompose({s1,s2},@divVals);

function ris = divVals(v1,v2)
ris = v1/v2;
