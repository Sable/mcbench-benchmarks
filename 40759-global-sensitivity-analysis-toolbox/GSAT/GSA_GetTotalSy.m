%% GSA_GetTotalSy: calculate the total sensitivity S of a subset of inputs
%
% Usage:
%   [Stot eStot pro] = GSA_GetTotalSy(pro, iset, verbose)
%
% Inputs:
%    pro                project structure
%    iset               cell array or array of inputs of the considered set, they can be selected
%                       by index (1,2,3 ...) or by name ('in1','x',..) or
%                       mixed
%    verbose            if not empty, it shows the time (in hours) for
%                       finishing
%
% Output:
%     Stot               Total sensitiviy for the considered set
%     eStot              associated error estimation (at 50%)
%     pro                updated project structure
%
% ------------------------------------------------------------------------
% See also
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 15-02-2011
%
% History:
% 1.0  15-04-2011  Added verbose parameter
% 1.0  15-02-2011  First release.
%%

function [Stot eStot pro] = GSA_GetTotalSy(pro, iset, verbose)

if ~exist('verbose','var')
    verbose = 0;
else
    verbose = ~isempty(verbose) && verbose;
end


n = length(pro.Inputs.pdfs);

index = fnc_SelectInput(pro, iset);

compli = setdiff(1:n, index);

if isempty(compli)
    Stot = 1;
    eStot = 0;
else
    [S eS pro] = GSA_GetSy(pro, compli, verbose);
    Stot = 1 - S;
    eStot = eS;
end