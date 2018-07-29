% Description:
%
%     Remove one term at a time from a MANCOVAN model until all p-values are
%     below the specified threshold.
%
% Syntax:
%
%     [ T, p, stats ] = mStepwise(Y, groups, [], threshold)
%     [ T, p, stats ] = mStepwise(Y, [], covariates, threshold)
%     [ T, p, stats ] = mStepwise(Y, groups, covariates, threshold)
%     [ T, p, stats ] = mStepwise(Y, groups, covariates, threshold, options)
%
%     [ T, p, stats ] = mStepwise(Y, X, terms, threshold, options)
%
% Inputs:
%
%     Y          - [ N x M ] (double) - multivariate response
%     groups     - [ N x G ] (int)    - qualitative variables
%     covariates - [ N x C ] (double) - quantitative variables
%     threshold  - [ 1 x 1 ] (double) - p-value at which to stop dropping terms
%     options    - [ 1 x P ] (cell)   - see Options
%
%     X     - [ N x T ] (double) - design matrix
%     terms - [ 1 x T ] (cell)   - model terms
%
% Outputs:
%
%     T - [ (G + C) x 1 ] (double)
%     p - [ (G + C) x 1 ] (double)
%
%     stats.U - [ N x N ] (double) - U resulting from the SVD (option 'SVD').
%     stats.S - [ N x N ] (double) - S resulting from the SVD (option 'SVD').
%     stats.V - [ M x N ] (double) - V resulting from the SVD (option 'SVD').
%
%     stats.BIC - [ 1 x P ] (double) - values of the Bayesian information
%         criterion (BIC) associated with the SVD (option 'SVD').
%
%     stats.PVE - [ N x 1 ] (double) - the percentage of variance in Y explained
%         by each consecutive column of U (option 'SVD').
%
%     stats.Terms - [ 1 x B ] (cell) - full model terms numbering groups from
%         one through size(groups, 2) and covariates from size(groups, 2) + 1
%         through size(groups, 2) + size(covariates, 2) + 1, and interactions
%         according to combinations of these numbers.
%
%     stats.X - [ N x B ] (double) - full model design matrix, including columns
%         for the grand mean, groups, covariates, and interactions.
%
%     stats.Y - [ N x M ] (double) - the multivariate response used for the
%         computation.
%
%     stats.B - [ B x P ] (double) - regression coefficients associated with the
%         full model after stepwise removal of insignificant terms.
%
%     stats.SSE - [ P x P ] (int) - full model sum of squared errors associated
%         with each column of Y.
%
%     stats.DFE - [ 1 x M ] (int) - degrees of freedom used in the computation
%         of stats.MSE.
%
%     stats.MSE - [ P x P ] (int) - full model mean squared errors associated
%         with each column of Y.
%
% Details:
%
% Options:
%
%     'group-group'         - include group-group interactions
%     'covariate-covariate' - include covariate-covariate interactions
%     'group-covariate'     - include group-covariate interactions
%     'over-determined'     - use over-determined coding for the design matrix
%     'sigma-restricted'    - use sigma-restricted coding for the design matrix
%     'SVD'                 - reduce the dimensionality of Y using an SVD
%     'verbose'             - display extra information to the command window
%
% Examples:
%
%     The following example uses a simple additive model with covariates, but no
%     interactions and avoids using the Statistics Toolbox:
%
%         n          = 100; 
%         groups     = round(2 * rand(n, 2) + 0.5);
%         covariates = 10 * randn(n, 2);
%         Y          = groups + covariates + randn(n, 2);
%
%         [ T, p, stats ] = mStepwise(Y, groups, covariates, 0.10, ...
%             { 'group-group' 'covariate-covariate' 'group-covariate' 'verbose' });
%
%     For other examples, refer to mancovan.m.  The setup and syntax is exactly
%     the same in every case except for the addition of a threshold.
%
% Notes:
%
% Author(s):
%
%     William Gruner (williamgruner@gmail.com)
%
% References:
%
%     Refer to the references listed in mancovan.m.
%
% Acknowledgements:
%
%     Many thanks to Dr. Erik Erhardt and Dr. Elena Allen of the Mind Research
%     Network (www.mrn.org) for their continued collaboration.
%
% Version:
%
%     $Author: williamgruner $
%     $Date: 2010-04-15 07:46:14 -0600 (Thu, 15 Apr 2010) $
%     $Revision: 496 $

function [ T, p, stats ] = mStepwise(Y, groups, covariates, threshold, options)
    
    if nargin == 0
        T = BIT(); return
    end
    
    if ~exist('options', 'var')
        options = cell(0);
    end
    
    if iscell(covariates)
        X     = groups;
        terms = covariates;
    else
        [ X, terms ] = mX(groups, covariates, options);
    end
        
    if ~isempty(strmatch('SVD', options, 'exact'))
        
        [ BIC, U, S, V ] = mSVD(Y, options);

        stats.U   = U;
        stats.S   = S;
        stats.V   = V;
        stats.BIC = BIC;
        stats.PVE = cumsum(diag(S) ./ sum(diag(S)));
        
        b = find(diff(BIC) > 0);
        b = b(1);
        
        U = U(  :, 1:b);
        S = S(1:b, 1:b);
        V = V(  :, 1:b);
        
    else
        
        U = Y;
        
    end
    
    if ~isempty(strmatch('verbose', options, 'exact'))
        fprintf('\n')
    end
            
    while length(terms) > 1
    
        if ~isempty(strmatch('over-determined', options, 'exact'))
            M = X * pinv(X' * X) * X';
        else
            M = X * inv(X' * X) * X';
        end
        
        B = mUnique(terms(2:end));
        T = repmat(NaN, length(B), 1);
        p = repmat(NaN, length(B), 1);

        for i = 1 : length(B)

            I0 = mTerms(B{i}, terms);
            X0 = X(:, I0);
            
            if ~isempty(strmatch('over-determined', options, 'exact'))
                M0 = X0 * pinv(X0' * X0) * X0';
            else
                M0 = X0 * inv(X0' * X0) * X0';
            end
            
            if ~isempty(strmatch('verbose', options, 'exact'))
                mDispModels([ {0} B ], mUnique(terms(I0)))
            end

            [ T(i), p(i) ] = mLHT(U, X, X0, M, M0, options);

            if ~isempty(strmatch('verbose', options, 'exact'))
                fprintf('\n')
            end

        end

        if max(p) < threshold
            break
        end
        
        [ q, I ] = sort(p, 'descend');
        
        for i = 1 : length(I)
            if mIsInteractionTerm(B{I(i)})
                break
            elseif mIsMainTerm(B{I(i)})
                if ~ismember(B{I(i)}, cat(2, B{mFindInteractionTerms(B)}))
                    break
                end
            end
        end
        
        if q(i) < threshold
            
            break
            
        else
            
            if ~isempty(strmatch('verbose', options, 'exact'))
                
                if mIsInteractionTerm(B{I(i)})
                    fprintf('Removing %d%d ...\n', B{I(i)}(1), B{I(i)}(2))
                elseif mIsMainTerm(B{I(i)})
                    fprintf('Removing %d ...\n', B{I(i)})
                end
                
                fprintf('\n')
                
            end
        
            X    (:, mFindTerms(B{I(i)}, terms)) = [];
            terms(:, mFindTerms(B{I(i)}, terms)) = [];
            
        end
        
    end
    
    if ~isempty(strmatch('over-determined', options, 'exact'))
        stats.B = pinv(X' * X) * X' * U;
    else
        stats.B = inv(X' * X) * X' * U;
    end
    
    stats.Terms     = terms;
    stats.X         = X;
    stats.Y         = Y;
    stats.SSE       = U' * (eye(size(M)) - M) * U;
    stats.DFE       = size(X, 1) - rank(X);
    stats.MSE       = stats.SSE / stats.DFE;
    stats.Residuals = U - stats.X * stats.B;

function b = BIT()

    b = true;
    
    % Compare the results to those obtained from the previous version.

    s = load('mStepwise-BIT-1.mat');

    [ T, p, stats ] = mStepwise(s.Y, s.groups, s.covariates, 0.10, ...
        { 'sigma-restricted' 'group-group' 'covariate-covariate' 'group-covariate' 'verbose' });

    e = s.T - T;
    
    if any(abs(e(:)) > sqrt(eps))
        b = false;
    end
    
    e = s.p - p;
    
    if any(abs(e(:)) > sqrt(eps))
        b = false;
    end

    % Compare the results to those obtained from the previous version.
    
    s = load('mStepwise-BIT-2.mat');

    [ T, p, stats ] = mStepwise(s.Y, s.groups, s.covariates, 0.01, ...
        { 'sigma-restricted' 'group-group' 'covariate-covariate' 'group-covariate' 'verbose' });
    
    e = s.T - T;
    
    if any(abs(e(:)) > sqrt(eps))
        b = false;
    end
    
    e = s.p - p;

    if any(abs(e(:)) > sqrt(eps))
        b = false;
    end
    