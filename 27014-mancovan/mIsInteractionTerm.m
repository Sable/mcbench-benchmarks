% Description:
%
%     Return true if term represents a interaction effect and false otherwise.
%
% Syntax:
%
%     b = mIsInteractionTerm(term)
%
% Inputs:
%
%     term - [ 1 x 1 ] or [ 1 x 2 ] (int)
%
% Outputs:
%
%     b - [ 1 x 1 ] (logical)
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

function b = mIsInteractionTerm(term)
    
    b = length(term) == 2;