function [EB] = bit2EB(bit)
% Convert computery things from bits to exabytes.
% Chad A. Greene 2012
EB = bit*2^-63;