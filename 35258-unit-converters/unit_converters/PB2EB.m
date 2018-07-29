function [EB] = PB2EB(PB)
% Convert computery things from petabytes to exabytes.
% Chad A. Greene 2012
EB = PB*2^-10 ;