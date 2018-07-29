% Description:
%
%     Return p-values from the F cummulative distribution function.
%
% Syntax:
%
%     p = mFCDF(x, a, b)
%
% Inputs:
%
%     x - [ 1 x 1 ] (double)
%     a - [ 1 x 1 ] (double)
%     b - [ 1 x 1 ] (double)
%
% Outputs:
%
%     p - [ 1 x 1 ] (double)
%
% Details:
%
% Examples:
%
% Notes:
%
% Author(s):
%
%     William Gruner (williamgruner@gmail.com)
%
% References:
%
% Acknowledgements:
%
%     Many thanks to Dr. Erik Erhardt and Dr. Elena Allen of the Mind Research
%     Network (www.mrn.org) for their continued collaboration.
%
% Version:
%
%     $Author: williamgruner $
%     $Date: 2010-04-01 11:39:09 -0600 (Thu, 01 Apr 2010) $
%     $Revision: 482 $

function p = mFCDF(x, a, b)
    
    p = betainc(a * x ./ (a * x + b), a/2, b/2);
