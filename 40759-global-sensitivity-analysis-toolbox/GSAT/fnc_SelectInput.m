%% fnc_SelectInput: select the input indexes from a generic list
%
% Usage:
%   index = fnc_SelectInput(pro, iset)
%
% Inputs:
%    pro                project structure
%    iset               cell array or array of inputs of the considered set, they can be selected
%                       by index (1,2,3 ...) or by name ('in1','x',..) or
%                       mixed
%
% Output:
%     index              vector of indexes corresponding to the iset inputs
%
% ------------------------------------------------------------------------
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 02-02-2011
%
% History:
% 1.0  02-02-2011  First release.
%%

function index = fnc_SelectInput(pro, iset)

index = nan(size(iset));

if iscell(iset)
    for i=1:length(iset)
        in = iset{i};
        if isnumeric(in)
            index(i) = floor(in);
        else
            for j=1:length(pro.Inputs.pdfs)
                if strcmp(in,pro.Inputs.Names{j})
                    index(i) = j;
                end
            end
        end
    end
else
    index = iset;
end

if sum(isnan(index))>0 
    disp('Warning: some input is not well defined');
end

index = sort(unique(index));    
    