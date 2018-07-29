% Description:
%
%     Create a design matrix for groups and covariates depending on the options
%     specified (see mancovan.m for details).
%
% Syntax:
%
%     [ X, terms ] = mX(groups, covariates, options)
%
% Inputs:
%
%     groups     - [ N x G ] (int)
%     covariates - [ N x C ] (double)
%     options    - [ 1 x P ] (cell)
%
% Outputs:
%
%     X     - [ N x M ] (double)
%     terms - [ 1 x M ] (cell)
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
%     $Date: 2010-04-09 08:53:39 -0600 (Fri, 09 Apr 2010) $
%     $Revision: 491 $

function [ X, terms ] = mX(groups, covariates, options)
    
    if ~exist('covariates', 'var')
        covariates = [];
    end
    
    if ~exist('options', 'var')
        options = cell(0);
    end
    
    terms = { 0 };
    X     = ones(max(size(groups, 1), size(covariates, 1)), 1);
   
    if ~isempty(groups)
        [ x, t ] = mG2X(groups, 0, options);
        terms    = cat(2, terms, t);
        X        = cat(2, X, x);
    end
    
    if ~isempty(covariates)
        [ x, t ] = mC2X(covariates, size(groups, 2), options);
        terms    = cat(2, terms, t);
        X        = cat(2, X, x);
    end
    
    if size(groups, 2) > 1 && ...
            ~isempty(strmatch('group-group', options, 'exact'))
        [ x, t ] = mGG2X(groups, 0, options);
        terms    = cat(2, terms, t);
        X        = cat(2, X, x);
    end
    
    if size(covariates, 2) > 1 && ...
            ~isempty(strmatch('covariate-covariate', options, 'exact'))
        [ x, t ] = mCC2X(covariates, size(groups, 2), options);
        terms    = cat(2, terms, t);
        X        = cat(2, X, x);
    end
    
    if ~isempty(groups) && ~isempty(covariates) && ...
            ~isempty(strmatch('group-covariate', options, 'exact'))
        [ x, t ] = mGC2X(groups, covariates, 0, size(groups, 2), options);
        terms    = cat(2, terms, t);
        X        = cat(2, X, x);
    end
