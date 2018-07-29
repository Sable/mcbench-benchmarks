function [PB] = bit2PB(bit)
% Convert computery things from bits to petabytes.
% Chad A. Greene 2012
PB = bit*2^-53;