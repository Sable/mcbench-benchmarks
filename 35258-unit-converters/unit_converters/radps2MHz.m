function [MHz] = radps2MHz(radps)
% Convert frequency from radians per second to megahertz.
% Chad A. Greene 2012
MHz = radps/(2*pi)/1000000;