function [inH2O] = mmHg2inH2O(mmHg)
% Convert pressure from millimeters of mercury at 0 degrees C to inches of
% water at 4 degrees C
% Chad Greene 2012
inH2O = mmHg*0.535240;