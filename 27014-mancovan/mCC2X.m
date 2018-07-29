% Description:
%
%     Create a design matrix for covariate-covariate interactions.
%
% Syntax:
%
%     [ X, terms ] = mCC2X(covariates, offset)
%
% Inputs:
%
%     covariates - [ N x C ] (double) - columns of quantitative variables
%     offset     - [ 1 x 1 ] (int)    - covariate offset index for terms
%     options    - [ 1 x P ] (cell)   - e.g. { 'verbose' }
%     columns    - [ T x 2 ] (int)    - indices into the columns of covariates
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
%     $Author: William Gruner $
%     $Date: 2010-04-08 08:48:31 -0600 (Thu, 08 Apr 2010) $
%     $Revision: 490 $

function [ X, terms ] = mCC2X(covariates, offset, options, columns)
    
    if ~exist('offset', 'var') || isempty(offset)
        offset = 0;
    end
    
    if ~exist('options', 'var')
        options = {};
    end
    
    if ~exist('columns', 'var')
        columns = mNC2(size(covariates, 2));
    end
    
    terms = {};
    X     = [];

    if ~isempty(strmatch('verbose', options, 'exact'))
        fprintf('\n')
    end

    for i = 1 : size(columns, 1)
        
        if ~isempty(strmatch('verbose', options, 'exact'))
            fprintf('Factor %d%d represents the interaction between columns %d and %d of covariates.\n', ...
                columns(i, 1) + offset, columns(i, 2) + offset, ...
                columns(i, 1), columns(i, 2))
        end

        X = cat(2, X, covariates(:, columns(i, 1)) .* covariates(:, columns(i, 2)));
        terms{end + 1} = columns(i, :) + offset;
        
    end
    
