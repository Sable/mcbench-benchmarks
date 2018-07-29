%% pro_Create: Create a new project structure
%
% Usage:
%   pro = pro_Create()
%
% Inputs:
%
% Output:
%     pro                project structure
%                          .Inputs.pdfs: cell-array of the model inputs with the pdf handles
%                          .Inputs.Names: cell-array with the input names 
%                          .N: scalar, number of samples of crude Monte Carlo
%                          .Model.handle: handle to the model function
%                          .Model.Name: string name of the model
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

function pro = pro_Create()

pro.Inputs.pdfs = {};
pro.Inputs.Names = {};
pro.N = 10000;
pro.Model.handle = [];
pro.Model.Name = [];
