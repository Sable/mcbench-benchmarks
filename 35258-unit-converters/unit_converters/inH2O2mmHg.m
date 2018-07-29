function [mmHg] = inH2O2mmHg(inH2O)
% Convert pressure from inches of water column at 4 degrees to millimeters
% of mercury at 0 degrees C
% Chad Greene 2012
mmHg = inH2O*1.86832;