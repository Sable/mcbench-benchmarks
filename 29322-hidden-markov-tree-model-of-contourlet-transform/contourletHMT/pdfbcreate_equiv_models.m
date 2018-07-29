% pdfbcreate_equiv_models
% written by:   Duncan Po
% Date:         December 5/2002
% Usage:        models = pdfbcreate_equiv_models(model)
% Input:    model   -   original model
% Output:   models  -   an array of equivalent models
%
% create equivalent models by flipping the states

function models = pdfbcreate_equiv_models(model)

l = 1;
temp_model{l}{1} = model;
for j = 1:length(model.stdv)
    for k= 1:length(model.stdv{j})
        l = l+1;
        for mm = 1:2.^(l-1)
            if mod(mm, 2) == 1
                temp_model{l}{mm} = pdfbflip_model(temp_model{l-1}{ceil(mm/2)}, j, k);
            else
                temp_model{l}{mm} = temp_model{l-1}{ceil(mm/2)};
            end;
        end;
    end;
end;

num = length(temp_model{end});
for ddd = 1:num
    models{ddd} = temp_model{end}{ddd};
end;