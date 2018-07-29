% Description:
%
%     Create a design matrix for group-group interactions.
%
% Syntax:
%
%     [ X, terms ] = mGG2X(groups, offset)
%
% Inputs:
%
%     groups  - [ N x G ] (int)  - columns of qualitative variables
%     offset  - [ 1 x 1 ] (int)  - group offset index for terms
%     options - [ 1 x P ] (cell) - see Options
%     columns - [ T x 2 ] (int)  - indices into the columns of groups
%
% Outputs:
%
%     X     - [ N x M ] (double)
%     terms - [ 1 x M ] (cell)
%
% Details:
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

function [ X, terms ] = mGG2X(groups, offset, options, columns)
    
    if ~exist('offset', 'var') || isempty(offset)
        offset = 0;
    end
    
    if ~exist('options', 'var')
        options = cell(0);
    end
    
    if ~exist('columns', 'var')
        columns = mNC2(size(groups, 2));
    end
    
    terms = {};
    X     = [];

    if ~isempty(strmatch('verbose', options, 'exact'))
        fprintf('\n')
    end
    
    for i = 1 : size(columns, 1)

        A = mG2X(groups(:, columns(i, 1)), offset, intersect(options, ...
            { 'over-determined' 'sigma-restricted' }));
        
        B = mG2X(groups(:, columns(i, 2)), offset, intersect(options, ...
            { 'over-determined' 'sigma-restricted' }));
        
        combinations = [];

        for j = 1 : size(A, 2)
            for k = 1 : size(B, 2)
                combinations(end + 1, :) = [ j k ];
            end
        end

        for j = 1 : size(combinations, 1)
            X = [ X A(:, combinations(j, 1)) .* B(:, combinations(j, 2)) ];
            terms{end + 1} = columns(i, :) + offset;
        end
        
        if ~isempty(strmatch('verbose', options, 'exact'))
            fprintf('Factor %d%d represents the interaction between columns %d and %d of groups and has %d levels.\n', ...
                columns(i, 1) + offset, columns(i, 2) + offset, ...
                columns(i, 1), columns(i, 2), size(combinations, 1))
        end
        
    end
    
