function [dynpcm2] = atm2dynpcm2(atm)
% Convert pressure from atmospheres to dynes per square centimeter.
%
% So I watched that movie "Winnebago Man" last night.  It was pretty good.
% I didn't expect much from a low-budget documentary about the guy from
% some novelty viral internet videos to be very good or entertaining.  And
% I expected the first half the be good, then the second half to drag, as
% happens to so many indie docs.  But in fact it was funny at the
% beginning, then became MORE engaging in the second half.  That was a nice
% surprise. 
% Chad A. Greene
dynpcm2 = atm*1.01325e+6;