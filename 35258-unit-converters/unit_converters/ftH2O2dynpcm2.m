function [dynpcm2] = ftH2O2dynpcm2(ftH2O)
% Convert pressure from feet of water column at 4 degrees to dyne per sq-cm
% Chad Greene 2012
dynpcm2 = ftH2O*29890.7;