function [TW] = hpb2TW(hpb)
% Convert power from boiler horsepower to terawatts.
% Chad A. Greene 2012
TW = hpb*9809.5e-12;
