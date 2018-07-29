% Description:
%
%     Return the indices of the elements of terms not associated with term.
%
% Syntax:
%
%     I = mTerms(term, terms)
%
% Inputs:
%
%     term  - [ 1 x 1 ] or [ 1 x 2 ] (int)
%     terms - [ 1 x M ] (cell)
%
% Outputs:
%
%     I - [ 1 x P ] (int)
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
%     $Date: 2010-04-07 16:45:32 -0600 (Wed, 07 Apr 2010) $
%     $Revision: 487 $

function I = mTerms(term, terms)
        
    I = [];

    for i = 1 : length(terms)
        if length(term) == length(terms{i}) && ~all(term == terms{i})
            I = [ I i ];
        elseif length(term) <  length(terms{i}) && ~ismember(term, terms{i})
            I = [ I i ];
        elseif length(term) >  length(terms{i});
            I = [ I i ];
        end
    end
