function [atm] = mmHg2atm(mmHg)
% Convert pressure from millimeters of mercury at 0 degrees C to
% atmospheres
% Chad Greene 2012
atm = mmHg*0.00131579;