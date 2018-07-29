%% fnc_GetIndex: give the index of the element in the vector that
%%               corresponds to the set of inputs
%
% Usage:
%   i = fnc_GetIndex(C)
%
% Inputs:
%    C                array of input indexes
%
% Output:
%     i               index in the vector that contains all the variances
%
% ------------------------------------------------------------------------
% See also 
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 29-01-2011
%
% History:
% 1.0  29-01-2011  First release.
%%

function i = fnc_GetIndex(C)

i = sum(2.^(C-1));