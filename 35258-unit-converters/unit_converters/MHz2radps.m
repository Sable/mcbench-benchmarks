function [radps] = MHz2radps(MHz)
% Convert frequency from megahertz to radians per second.
% Chad A. Greene 2012
radps = MHz*(2*pi)*1e+6;