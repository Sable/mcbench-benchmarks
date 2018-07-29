function [x_tra] = abstrans(X)
% Convert spectral absorbance to transmitance
%
% [x_tra] = abstrans(X)
%  
% input:
% X (samples x absorbances)		absorbance data matrix
%
% output:
% x_tra (samples x transmitances)	transmittance data matrix
%
% By Cleiton A. Nunes
% UFLA,MG,Brazil

x_tra = 100./(10.^X);