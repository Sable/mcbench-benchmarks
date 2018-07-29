function [radps] = THz2radps(THz)
% Convert frequency from terahertz to radians per second.
% Chad A. Greene 2012
radps = THz*(2*pi)*1e+12;