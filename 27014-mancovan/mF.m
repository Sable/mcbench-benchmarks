% Description:
%
%     Compute the F-statistic and the resulting p-value using full and reduced
%     model design and (optionally) projection matrices.
%
% Syntax:
%
%     [ F, p ] = mF(y, X, X0, M, M0)
%
% Inputs:
%
%     y  - [ N x 1 ] (double)
%     X  - [ N x A ] (double)
%     X0 - [ N x B ] (double)
%     M  - [ N x N ] (double) (optional)
%     M0 - [ N x N ] (double) (optional)
%
% Outputs:
%
%     F - [ 1 x 1 ] (double)
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

function [ F, p ] = mF(y, X, X0, M, M0)
    
    if ~exist('M', 'var')
        M = X * pinv(X' * X) * X';
    end
    
    if ~exist('M0', 'var')
        M0 = X0 * pinv(X0' * X0) * X0';
    end
    
    SSEF = y' * (eye(size(M)) - M) * y;
    SSER = y' * (eye(size(M0)) - M0) * y;

    dFF = size(X, 1) - rank(X);
    dFR = size(X0, 1) - rank(X0);

    F = ((SSER - SSEF) / (dFR - dFF)) / (SSEF / dFF);
    p = 1 - mFCDF(F, dFR - dFF, dFF);
