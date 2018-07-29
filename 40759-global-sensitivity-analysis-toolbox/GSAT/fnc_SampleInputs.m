%% fnc_SampleInputs: function that samples the inputs of a project
%
% Usage:
%   [Set1 Set2] = fnc_SampleInputs(pro)
%
% Inputs:
%    pro                project structure
%
% Output:
%     Set1, Set2        matrix with the input pdfs sampled
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

function [Set1 Set2] = fnc_SampleInputs(pro)

ninputs = length(pro.Inputs.pdfs);
Set1 = nan(pro.N, ninputs);
Set2 = nan(pro.N, ninputs);

isobol = [];
sobolRange = [];

for i=1:ninputs
    if ~isempty(strfind(func2str(pro.Inputs.pdfs{i}),'pdf_Sobol'))
        isobol(end+1) = i;
        sobolRange = [sobolRange; pro.Inputs.pdfs{i}()];
    else
        Set1(:,i) = pro.Inputs.pdfs{i}(pro.N);
        Set2(:,i) = pro.Inputs.pdfs{i}(pro.N);
    end
end

if ~isempty(isobol)
    ninsobol = length(isobol);
    
    if exist('sobolset')
        S = fnc_getSobolSetMatlab(ninsobol*2, pro.N);
    else
        S = fnc_getSobolSequence(ninsobol*2, pro.N);
    end
    Min = repmat(sobolRange(:,1)', pro.N, 1);
    Max = repmat(sobolRange(:,2)', pro.N, 1);   
    
    Set1(:,isobol) = Min + S(:,1:ninsobol).*(Max-Min);
    Set2(:,isobol) = Min + S(:,(ninsobol+1):end).*(Max-Min);    
end