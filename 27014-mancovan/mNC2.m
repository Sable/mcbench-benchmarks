% Description:
%
%     Enumerate N choose 2 combinations.
%
% Syntax:
%
%     c = mNC2(n)
%
% Inputs:
%
%     n - [ 1 x 1 ] (int)
%
% Outputs:
%
%     c - [ N x 2 ] (int)
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

function c = mNC2(n)
    
    c = [];

    for i = 1 : n
        for j = i + 1 : n
            c(end + 1, :) = [ i j ];
        end
    end
