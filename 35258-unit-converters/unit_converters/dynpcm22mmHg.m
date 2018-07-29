function [mmHg] = dynpcm22mmHg(dynpcm2)
% Convert pressure from dynes per square centimeter to millimeters of
% mercury at 0 degrees C
% Chad Greene 2012
mmHg = dynpcm2*0.000750062;