function [rpm] = radps2rpm(radps)
% Convert frequency from radians per second to revolutions per minute.
% Chad A. Greene 2012
rpm = radps/(2*pi)*60;