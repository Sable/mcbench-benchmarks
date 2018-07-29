function [THz] = radps2THz(radps)
% Convert frequency from radians per second to terahertz.
% Chad A. Greene 2012
THz = radps/(2*pi)/1000000000000;