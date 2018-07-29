function clo=FunctionClosing(f,sizeel)

%=========================================================
% function clo=FunctionClosing(f,sizeel)
%
% This function perform the mathematical morphology 
% closing (= erosion of dilation of f) operator for 
% functions according to structural element of size sizeel.
%
% Inputs:
%   -f: input function
%   -sizeel: size of the structural element
%
% Output:
%   -clo: the closed function
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=========================================================

clo=FunctionErosion(FunctionDilation(f,sizeel),sizeel);