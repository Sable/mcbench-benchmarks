%% pro_AddInput: Add a model input to the project s
%
% Usage:
%   pro = pro_AddInput(pro, inputpdf, name, analyse)
%
% Inputs:
%    pro                project structure
%    inputpdf           reference to a @(N)pdf(N,...)
%    name               name of the input 
%
% Output:
%     pro                project structure
%
% ------------------------------------------------------------------------
% See also 
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 28-01-2011
%
% History:
% 1.0  28-01-2011  First release.
%%

function pro = pro_AddInput(pro, inputpdf, name)

pro.Inputs.pdfs{end+1} = inputpdf;
pro.Inputs.Names{end+1} = name;

