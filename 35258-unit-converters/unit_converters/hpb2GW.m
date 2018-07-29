function [GW] = hpb2GW(hpb)
% Convert power from boiler horsepower to gigawatts.
% You know, if Back to the Future were made today, the actors would
% probably know how to pronounce 21.1 gigawatts.  But we didn't have 
% gigabytes back then.  
% Chad A. Greene 2012
GW = hpb*9809.5e-9;
