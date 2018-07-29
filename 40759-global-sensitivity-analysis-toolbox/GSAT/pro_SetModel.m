%% pro_SetModel: Set the model to the project
%
% Usage:
%   pro = pro_SetModel(pro, model, name)
%
% Inputs:
%    pro                project structure
%    model              handle to the @(x)model(x,...) where x is a vector 
%    name               optional, name of the model
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

function pro = pro_SetModel(pro, model, name)

pro.Model.handle =  model;
if nargin>2
    pro.Model.Name = name;
end
