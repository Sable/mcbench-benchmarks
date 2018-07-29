% Description:
%
%     Return the indices of the interaction effects in terms.
%
% Syntax:
%
%     I = mFindInteractionTerms(terms)
%
% Inputs:
%
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

function I = mFindInteractionTerms(terms)
    
    I = [];

    for i = 1 : length(terms)
        if length(terms{i}) == 2
            I = [ I i ];
        end
    end
    