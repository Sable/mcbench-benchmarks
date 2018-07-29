function [G] = Gal2G(Gal)
% Convert acceleration from galileos to acceration from Earths gravity.
% Chad A. Greene 2012
G = Gal*0.0010197162; 