% Description:
%
%     Compute the Lawley-Hotelling trace and the resulting p-value using full
%     and reduced model design and (optionally) projection matrices.
%
% Syntax:
%
%     [ T, p ] = mLHT(Y, X, X0, M, M0)
%
% Inputs:
%
%     Y       - [ N x M ] (double)
%     X       - [ N x A ] (double)
%     X0      - [ N x B ] (double)
%     M       - [ N x N ] (double) (optional)
%     M0      - [ N x N ] (double) (optional)
%     options - [ 1 x P ] (cell)
%
% Outputs:
%
%     T - [ 1 x 1 ] (double)
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

function [ T, p ] = mLHT(Y, X, X0, M, M0, options)
    
    if ~exist('M', 'var') || isempty(M)
        M = X * pinv(X' * X) * X';
    end
    
    if ~exist('M0', 'var') || isempty(M0)
        M0 = X0 * pinv(X0' * X0) * X0';
    end
    
    if ~exist('options', 'var')
        options = cell(0);
    end
    
    n = size(X, 1);
    r = rank(X);
    d = r - rank(X0);
    q = size(Y, 2);

    if ~isempty(strmatch('verbose', options, 'exact'))
        fprintf('\t         Full Model DoF = %g\n', n - r)
        fprintf('\t      Reduced Model DoF = %g\n', n - rank(X0))
    end

    H = Y' * (M - M0) * Y;
    E = Y' * (eye(size(M)) - M) * Y;
    T = (n - r) * trace(H * inv(E));

    B = ((n - r + d - q - 1) * (n - r - 1)) / ((n - r - q - 3) * (n - r - q));
    D = 4 + (q * d + 2) / (B - 1);
    G = (1 / (q * d)) * (D / (D - 2)) * ((n - r - q - 1) / (n - r));

    p = 1 - mFCDF(G * T, q * d, D);

    if ~isempty(strmatch('verbose', options, 'exact'))
        fprintf('\t          Numerator DoF = %g\n', q * d)
        fprintf('\t        Denominator DoF = %g\n', D)
        fprintf('\t Lawley-Hotelling Trace = %g\n', T)
        fprintf('\t                      p = %g\n', p)
    end
