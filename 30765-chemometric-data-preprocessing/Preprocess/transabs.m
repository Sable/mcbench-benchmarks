function [x_abs] = transabs(X)
% Convert spectral transmitance to absorbance
%
% [x_abs] = transabs(X)
%  
% input:
% X (samples x transmitances)      transmittance data matrix
%
% output:
% x_tra (samples x absorbances)	absorbance data matrix
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil

x_abs = log10(1./(X/100));
