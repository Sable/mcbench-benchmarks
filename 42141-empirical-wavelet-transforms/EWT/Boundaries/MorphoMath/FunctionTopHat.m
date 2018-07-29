function tophat=FunctionTopHat(f,sizeel)

%=========================================================
% function tophat=FunctionTopHat(f,sizeel)
%
% This function perform the mathematical morphology 
% Top Hat (= f- opening of f) operator for functions 
% according to structural element of size sizeel.
%
% Inputs:
%   -f: input function
%   -sizeel: size of the structural element
%
% Output:
%   -tophat: the Top Hat function
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=========================================================

tophat=f-FunctionOpening(f,sizeel);