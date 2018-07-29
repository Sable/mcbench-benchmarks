function [GHz] = rpm2GHz(rpm)
% Convert frequency from revolutions per minute to gigahertz.
% Chad A. Greene 2012
GHz = rpm/60/1000000000;