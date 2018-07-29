function [radps] = kHz2radps(kHz)
% Convert frequency from kilohertz to radians per second.
% Chad A. Greene 2012
radps = kHz*(2*pi)*1000;