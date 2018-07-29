% Description:
%
%     Create a design matrix for groups.
%
% Syntax:
%
%     [ X, terms ] = mG2X(groups, offset)
%
% Inputs:
%
%     groups  - [ N x G ] (int)  - columns of qualitative variables
%     offset  - [ 1 x 1 ] (int)  - group offset index for terms
%     options - [ 1 x P ] (cell) - see Details and Options
%     columns - [ 1 x T ] (int)  - indices into columns of groups
%
% Outputs:
%
%     X     - [ N x M ] (double)
%     terms - [ 1 x M ] (cell)
%
% Details:
%
%     By default, mG2X.m uses a canonical coding of the design matrix that 
%     includes the first level of each grouping variable in the intercept.
%     This default coding may be replaced either by over-determined coding,
%     which includes a column of ones and zeros for every level of every
%     grouping variable, or by sigma-restricted coding, which estimates an
%     overall mean and offsets from the overall mean for every level of every
%     grouping variable, excluding the last level of each grouping variable.
%
% Options:
%
%     'over-determined'  - use over-determined coding for the design matrix
%     'sigma-restricted' - use sigma-restricted coding for the design matrix
%     'verbose'          - display extra information to the command window
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
%     $Date: 2010-04-12 07:14:07 -0600 (Mon, 12 Apr 2010) $
%     $Revision: 494 $

function [ X, terms ] = mG2X(groups, offset, options, columns)
    
    if ~exist('offset', 'var') || isempty(offset)
        offset = 0;
    end
    
    if ~exist('options', 'var')
        options = cell(0);
    end
    
    if ~exist('columns', 'var')
        columns = 1 : size(groups, 2);
    end
    
    terms = {};
    X     = [];

    if ~isempty(strmatch('verbose', options, 'exact'))
        fprintf('\n')
    end

    for i = columns
        
        [ B, I, J ] = unique(groups(:, i));
        
        if ~isempty(strmatch('verbose', options, 'exact'))
            fprintf('Factor %d represents column %d of groups and has %d levels.\n', ...
                i + offset, i, length(B))
        end
        
        if ~isempty(strmatch('over-determined', options, 'exact'))
        
            for j = 1 : length(B)
                X(J ~= j, length(terms) + j) =  0;
                X(J == j, length(terms) + j) =  1;
            end
        
            for j = 1 : length(B)
                terms{end + 1} = i + offset;
            end            
            
        elseif ~isempty(strmatch('sigma-restricted', options, 'exact'))
        
            for j = 1 : length(B) - 1
                X(J ~=         j, length(terms) + j) =  0;
                X(J ==         j, length(terms) + j) =  1;
                X(J == length(B), length(terms) + j) = -1;
            end
        
            for j = 1 : length(B) - 1
                terms{end + 1} = i + offset;
            end            
            
        else
            
            for j = 2 : length(B) 
                X(J ~= j, length(terms) + j - 1) = 0;
                X(J == j, length(terms) + j - 1) = 1;
            end
        
            for j = 1 : length(B) - 1
                terms{end + 1} = i + offset;
            end            
            
        end
        
    end
    
