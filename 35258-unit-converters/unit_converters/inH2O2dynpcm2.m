function [dynpcm2] = inH2O2dynpcm2(inH2O)
% Convert pressure from inches of water column at 4 degrees to dyne/cm2
% Chad Greene 2012
dynpcm2 = inH2O*2490.89;