% Description:
%
%     Returns an array the same size as A containing ones where elements of A
%     are in the set S and zeros otherwise.  Unlike the Matlab function, this
%     function works when the contents of A and S are vectors of numeric data.
%
% Syntax:
%
%     result = mIsMember(A, S)
%
% Inputs:
%
%     A - [ 1 x N ] (cell)
%     S - [ 1 x P ] (cell)
%
% Outputs:
%
%     result - [ 1 x N ] (logical)
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

function result = mIsMember(A, S)
    
    a = cell(0);
    
    for i = 1 : length(A)
        a{i} = num2str(A{i}, '%d '); 
    end
    
    s = cell(0);
    
    for i = 1 : length(S)
        s{i} = num2str(S{i}, '%d '); 
    end
    
    result = ismember(a, s);
