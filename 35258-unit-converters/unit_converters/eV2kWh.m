function [kWh] = eV2kWh(eV)
% Convert energy or work from electron volts to kilowatt-hours.
% Chad A. Greene 2012
kWh = eV*4.4504925e-26;