% Description:
%
%     Return p-values from the t cummulative distribution function.
%
% Syntax:
%
%     p = mTCDF(x, v)
%
% Inputs:
%
%     x - [ 1 x 1 ] (double)
%     v - [ 1 x 1 ] (double)
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

function p = mTCDF(x, v)
    
    p = betainc((x + sqrt(x.^2 + v)) ./ (2 * sqrt(x.^2 + v)), v/2, v/2);
