function [kHz] = radps2kHz(radps)
% Convert frequency from radians per second to kilohertz.
% Chad A. Greene 2012
kHz = radps/(2*pi)/1000;