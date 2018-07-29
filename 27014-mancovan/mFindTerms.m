% Description:
%
%     Return the indices of terms matching term.
%
% Syntax:
%
%     I = mFindTerms(term, terms)
%
% Inputs:
%
%     term  - [ 1 x 1 ] or [ 1 x 2 ] (int)
%     terms - [ 1 x M ] (cell)
%
% Outputs:
%
%     I - [ 1 x T ] (int)
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

function I = mFindTerms(term, terms)

    I = [];

    for i = 1 : length(terms)
        if all(terms{i} == term)
            I = [ I i ];
        end
    end
