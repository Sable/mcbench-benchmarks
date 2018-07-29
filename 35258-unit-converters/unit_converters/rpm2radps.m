function [radps] = rpm2radps(rpm)
% Convert frequency from revolutions per minute to radians per second.
% Chad A. Greene 2012
radps = rpm*(2*pi)/60;