function [radps] = GHz2radps(GHz)
% Convert frequency from gigahertz to radians per second.
% Chad A. Greene 2012
radps = GHz*(2*pi)*1e+9;