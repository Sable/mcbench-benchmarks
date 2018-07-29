% Description:
%
%     Create a design matrix for covariates.
%
% Syntax:
%
%     [ X, terms ] = mC2X(covariates, offset)
%
% Inputs:
%
%     covariates - [ N x C ] (double) - columns of quantitative variables
%     offset     - [ 1 x 1 ] (int)    - covariate offset intex for terms
%     options    - [ 1 x P ] (cell)   - e.g. { 'verbose' }
%     columns    - [ 1 x T ] (int)    - indices into the columns of covariates
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

function [ X, terms ] = mC2X(covariates, offset, options, columns)
    
    if ~exist('offset', 'var') || isempty(offset)
        offset = 0;
    end
    
    if ~exist('options', 'var')
        options = {};
    end
    
    if ~exist('columns', 'var')
        columns = 1 : size(covariates, 2);
    end
    
    terms = {};
    X     = [];

    if ~isempty(strmatch('verbose', options, 'exact'))
        fprintf('\n')
    end
    
    for i = columns
        
        if ~isempty(strmatch('verbose', options, 'exact'))
            fprintf('Factor %d represents column %d of covariates.\n', ...
                i + offset, i)
        end
        
        X = cat(2, X, covariates(:, i));
        terms{end + 1} = i + offset;
        
    end
