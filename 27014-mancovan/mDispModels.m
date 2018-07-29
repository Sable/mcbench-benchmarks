% Description:
%
%     Send full and reduced model information to the command window.
%
% Syntax:
%
%     mDispModels(B, I)
%
% Inputs:
%
%     B - [ 1 x N ] (cell)
%     b - [ 1 x M ] (cell)
%
% Outputs:
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
%     $Date: 2010-04-01 12:52:08 -0600 (Thu, 01 Apr 2010) $
%     $Revision: 483 $

function mDispModels(B, b)
            
    fprintf('\t             Full Model = ')
        for i = 2 : length(B)
            fprintf('%s ', num2str(B{i}, '%d'))
        end
    fprintf('\n')
    fprintf('\t          Reduced Model = ')
        for i = 2 : length(B)
            if mIsMember(B(i), b)
                fprintf('%s ', num2str(B{i}, '%d'))
            else
                fprintf('%s ', repmat(' ', 1, ...
                    length(num2str(B{i}, '%d'))))
            end
        end
    fprintf('\n')
