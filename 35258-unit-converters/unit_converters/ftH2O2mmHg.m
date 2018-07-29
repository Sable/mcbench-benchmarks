function [mmHg] = ftH2O2mmHg(ftH2O)
% Convert pressure from feet of water column at 4 degrees to millimeters of
% mercury at 0 degrees C
% Chad Greene 2012
mmHg = ftH2O*22.4198;