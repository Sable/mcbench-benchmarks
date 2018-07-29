function [KB] = B2KB(B)
% Convert computery things from bytes to kilobytes.
% The K in the abbreviation of kilobyte, here, is not capitalized.  That's
% because it's pseudo-SI, it's a multiple of 1024 instead of 1000.  So we
% make the K big to make it clear that this is different from real SI.
% Then we keep the big G, M, T, etc from SI for all the other prefixes.
% As far as melon scratchers go, that's a real honeydoodler. 
% Chad A. Greene 2012
KB = B*2^-10 ;