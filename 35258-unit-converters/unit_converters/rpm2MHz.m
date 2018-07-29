function [MHz] = rpm2MHz(rpm)
% Convert frequency from revolutions per minute to Megahertz.
% Chad A. Greene 2012
MHz = rpm/60/1000000;