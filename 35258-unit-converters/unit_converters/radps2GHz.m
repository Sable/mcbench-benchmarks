function [GHz] = radps2GHz(radps)
% Convert frequency from radians per second to gigahertz.
% Chad A. Greene 2012
GHz = radps/(2*pi)/1000000000;