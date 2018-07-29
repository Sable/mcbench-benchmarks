%% fnc_GetInputs: give the vector of the inputs corresponding to the index
%
% Usage:
%   ii = fnc_GetInputs(i)
%
% Inputs:
%    i                scalar index of the inputs (given by fnc_GetIndex)
%
% Output:
%    ii               array of the corresponding inputs
%
% ------------------------------------------------------------------------
% See also 
%          fnc_GetIndex         
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 29-01-2011
%
% History:
% 1.0  29-01-2011  First release.
%%

function ii = fnc_GetInputs(i)

ii = find(de2bi(i));