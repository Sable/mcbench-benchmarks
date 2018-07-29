function [dynpcm2] = mmHg2dynpcm2(mmHg)
% Convert pressure from millimeters of mercury at 0 degrees C to dynes per
% square centimeter
% Chad Greene 2012
dynpcm2 = mmHg*1333.22;