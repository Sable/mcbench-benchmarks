function [kHz] = rpm2kHz(rpm)
% Convert frequency from revolutions per minute to kilohertz.
% Chad A. Greene 2012
kHz = rpm/60/1000;