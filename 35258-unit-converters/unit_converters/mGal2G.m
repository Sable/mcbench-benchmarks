function [G] = mGal2G(mGal)
% Convert acceleration from milligals to average Earth gravities.
% Chad A. Greene 2012
G = mGal*1.0197162e-6; 
end