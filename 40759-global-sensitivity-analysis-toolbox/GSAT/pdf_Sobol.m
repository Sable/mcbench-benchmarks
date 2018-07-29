%% pdf_Sobol: Foo function for simulate a Sobol Set
%
% Usage:
%   pdf_Sobol()
%
% Inputs:
%     range            vector [min max] range of the random variable
%
% Output:
%     range            vector [min max] range of the random variable
% ------------------------------------------------------------------------
% See also 
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 01-02-2011
%
% History:
% 1.0  01-02-2011  First release.
%%

function range = pdf_Sobol(range)

range = range(:)';
% empty function