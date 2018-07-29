function [J] = kWh2J(kWh)
% Convert energy or work from kilowatt-hours to joules.
% Chad A. Greene 2012
J = kWh*3600000;