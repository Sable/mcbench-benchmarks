function [z isrise]=find_zeros(s)
% z=find_zeros(s)
% find zeros as points where signal change signs
% s - signal sampes
% z - indexes where cros zero with sign changed
% isrise(i)=true if i-zeros in case of come - then +

cs=xor((s(1:end-1)>=0),(s(2:end)>=0));


z=find(cs);
isrise=s(z)<0;

