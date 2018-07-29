% Description:
%
%     Estimate the dimensionality of Y using the Bayesian information criterion 
%     (BIC) and perform an economy SVD of Y such that Y = U * S * V'.
%
% Syntax:
%
%     [ BIC, U, S, V, stats ] = mSVD(Y)
%
% Inputs:
%
%     Y       - [ N x M ] (double)
%     options - [ 1 x P ] (cell)
%
% Outputs:
%
%     BIC - [ 1 x B ] (double)
%     U   - [ N x N ] (double)
%     S   - [ N x N ] (double)
%     V   - [ M x N ] (double)
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
%     $Date: 2010-04-01 12:52:08 -0600 (Thu, 01 Apr 2010) $
%     $Revision: 483 $

function [ BIC, U, S, V ] = mSVD(Y, options)
    
    if ~exist('options', 'var')
        options = cell(0);
    end

    if ~isempty(strmatch('verbose', options, 'exact'))
        fprintf('\n')
        fprintf('Using an economy SVD to reduce the dimensionality of Y ...\n\n')
    end

    [ U, S, V ] = svd(Y, 'econ');

    b = [];
    n = size(U, 2);
    r = Inf;

    for i = 1 : n

        e = Y - U(:, 1 : i) * S(1 : i, 1 : i) * V(:, 1 : i)';

        b(i) = log(std(e(:)).^2) + (i / n) * log(n);

        if ~isempty(strmatch('verbose', options))
            fprintf('\tBIC(%d) = %g\n', i, b(i))
        end

        if i > 1 && b(i) > b(i - 1) && r == Inf
            r = i - 1;
        end

        if i > 2 * r
            break
        end

    end

    if ~isempty(strmatch('verbose', options))
        fprintf('\n... to the Bayesian information criterion estimate of %d.\n', r)
    end

    BIC = b;