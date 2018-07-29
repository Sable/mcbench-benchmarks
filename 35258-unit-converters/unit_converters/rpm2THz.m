function [THz] = rpm2THz(rpm)
% Convert frequency from revolutions per minute to terahertz.
% Chad A. Greene 2012
THz = rpm/60/1000000000000;