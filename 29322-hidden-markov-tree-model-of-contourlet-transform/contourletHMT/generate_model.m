% generate_model.m
% written by: Duncan Po
% Date: August 24, 2002
% Generate a random model
% Usage: model = generate_model(nstates, nlevels, zeromean, levndir)
% Inputs:   nstates     - number of states in the model
%           nlevels     - number of levels in the model
%           zeromean    - 'yes' for zero mean model and 'no' for non-zeromean model
%           levndir     - the number of subbands in each level (e.g. [2 2 3 3])
% Output:   model       - the model generated

function model = generate_model(nstates, nlevels, zeromean, levndir)

model.nstates = nstates;
model.nlevels = nlevels;
model.zeromean = zeromean;
model.rootprob = rand(1,nstates);
model.rootprob = model.rootprob./sum(model.rootprob);
for l = 1:nlevels-1
    for k = 1:2.^(levndir(l+1)-levndir(1))
        model.transprob{l}{k} = rand(nstates);
        for m = 1:nstates
            model.transprob{l}{k}(:, m) = model.transprob{l}{k}(:, m)...
                ./sum(model.transprob{l}{k}(:, m));
        end;
    end;
end;
for l = 1:nlevels
    for k = 1:2.^(levndir(l)-levndir(1))     
        if strcmp(zeromean, 'yes') == 0
            model.mean{l}{k} = rand(1,nstates);
            for m = 1:nstates
                model.mean{l}{k}(m) = model.mean{l}{k}(m)*(10.^m);
            end;
        end;
        model.stdv{l}{k} = rand(1, nstates);
        for m = 1:nstates
            model.stdv{l}{k}(m) = model.stdv{l}{k}(m)*(10.^m);
        end;
    end;
end;