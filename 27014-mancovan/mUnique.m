% Description:
%
%     Return a list of unique values.  A must be a cell array of vectors of
%     numeric data.  B will be sorted in the order of the first occurrance of
%     each unique value in A.
%
% Syntax:
%
%     [ B, I, J ] = mUnique(A)
%
% Inputs:
%
%     A - [ 1 x N ] (cell)
%
% Outputs:
%
%     B - [ 1 x U ] (cell)
%     I - [ 1 x U ] (int)
%     J - [ 1 x N ] (int)
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

function [ B, I, J ] = mUnique(A)
    
    temp = cell(0);
    
    for i = 1 : length(A)
        temp{i} = num2str(A{i}, '%d '); 
    end
    
    [ B, I, J ] = unique(temp);
    
    I = sort(I);
    B = A(I);
