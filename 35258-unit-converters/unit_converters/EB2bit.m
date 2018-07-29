function [bit] = EB2bit(EB)
% Convert computery things from exabytes to bits.
% Chad A. Greene 2012
bit = EB*9223372036855000000;