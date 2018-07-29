function [KB] = bit2KB(bit)
% Convert computery things from bits to kilobytes.
% Chad A. Greene 2012
KB = bit*2^-13;