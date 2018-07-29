% Description:
%
%     Create a custom design matrix and use it in a call to mancovan, mStepwise,
%     and mT.
%
% Syntax:
%
%     mDemoA
%
% Inputs:
%
% Outputs:
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

function mDemoA
    
    % Create a set of simulated data with 2 groups and 2 covariates. 
    
    n          = 100;
    groups     = round(3 * rand(n, 2) + 0.5);
    covariates = randn(n, 2);
    Y          = groups + covariates + randn(n, 2);    
    
    % Create a design matrix for group 1, covariate 2, and their interaction.
    
    terms = { 0 };
    X     = ones(n, 1);

    [ x, t ] = mG2X(groups, 0, {}, 1);
    terms    = cat(2, terms, t);
    X        = cat(2, X, x);

    [ x, t ] = mC2X(covariates, size(groups, 2), {}, 2);
    terms    = cat(2, terms, t);
    X        = cat(2, X, x);

    [ x, t ] = mGC2X(groups, covariates, 0, size(groups, 2), {}, [ 1 2 ]);
    terms    = cat(2, terms, t);
    X        = cat(2, X, x);
    
    % Use the custom design matrix in a call to mancovan.
    
    fprintf('\nOutput from mancovan:\n\n')
    
    [ T, p ] = mancovan(Y, X, terms, { 'verbose' });
    
    % Use the custom design matrix in a call to mStepwise.
    
    fprintf('\nOutput from mStepwise:\n\n')

    [ T, p ] = mStepwise(Y, X, terms, 0.10, { 'verbose' });
    
    % Use the custom design matrix in a few calls to mT.
    
    fprintf('\nOutput from mT:\n\n')
    
    [ t, p ] = mT(Y, X, terms, 1)
    [ t, p ] = mT(Y, X, terms, 4)
    [ t, p ] = mT(Y, X, terms, [ 1 4 ])
    
    