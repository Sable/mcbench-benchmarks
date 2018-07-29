% pdfbtrainthmt.m
% written by: Duncan Po
% Date: August 24, 2002
% Using the EM algorithm, train a model for the provided data
% Usage: model = pdfbtrainthmt(tree, levndir, mD, ns,zeromean)
%        [model, stateprob] = pdfbtrainthmt(tree, levndir, mD, ns,zeromean)
%        model = pdfbtrainthmt(tree, levndir, mD, initmodel)
%        [model, stateprob] = pdfbtrainthmt(tree, levndir, mD, initmodel)
% Inputs:   tree        - data in tree structure
%           levndir     - the number of subbands in each level (e.g. [2 2 3 3])
%           mD          - convergence value
%           ns          - number of states in the desired model
%           zeromean    - 'yes' for zero mean model and 'no' for non-zeromean model
%           initmodel   - an initial model can be provided to speed up the training 
% Output:   model       - the model generated
%           stateprob   - state probabilities

function [model, stateprob] = pdfbtrainthmt(tree, levndir, mD, ns,zeromean)

if nargout == 2
    needstateprob = 1;
else
    needstateprob = 0;
end;

nlevel = length(tree);

if nargin == 4
    initmodel.nstates = ns.nstates;
    realns = initmodel.nstates;
    initmodel.nlevels = ns.nlevels;
    initmodel.zeromean = ns.zeromean;
    initmodel.rootprob = zeros(1,realns);
    for l = 1:realns
        initmodel.rootprob(l) = ns.rootprob(l);
    end;
    for l = 1:nlevel-1
        for k = 1:2.^(levndir(l+1)-levndir(1))
            initmodel.transprob{l}{k} = zeros(realns);
            for m = 1:realns
                for n = 1:realns
                    initmodel.transprob{l}{k}(m,n) = ns.transprob{l}{k}(m,n);
                end;
            end;
        end;
    end;
    for l = 1:nlevel
        for k = 1:2.^(levndir(l)-levndir(1))     
            if strcmp(ns.zeromean, 'yes') == 0
                initmodel.mean{l}{k} = zeros(1,realns);
                for m = 1:realns
                    initmodel.mean{l}{k}(m) = ns.mean{l}{k}(m);
                end;              
            end;
            initmodel.stdv{l}{k} = zeros(1, realns);
            for m = 1:realns
                initmodel.stdv{l}{k}(m) = ns.stdv{l}{k}(m);
            end;                 
        end;
    end;
else
    model.nstates = -2;
    model.nlevels = -1;
    model.zeromean = 0;
    model.rootprob = zeros(1,ns);
    for l = 1:nlevel-1
        for k = 1:2.^(levndir(l+1)-levndir(1))
            model.transprob{l}{k} = zeros(ns);
        end;
    end;
    for l = 1:nlevel
        for k = 1:2.^(levndir(l)-levndir(1))     
            if strcmp(zeromean, 'yes') == 0
                model.mean{l}{k} = zeros(1,ns);
            end;
            model.stdv{l}{k} = zeros(1, ns);
        end;
    end;
end;

if ~exist('initmodel', 'var')
    if needstateprob == 0
        pdfbtrain_thmt(ns, nlevel, levndir, zeromean, tree, mD, model);
    else
        for l = 1:nlevel
            numofel = length(tree{l});
            stateprob{l} = zeros(numofel, ns);
        end;
        pdfbtrain_thmt(ns, nlevel, levndir, zeromean, tree, mD, model, stateprob);
    end;
else
    model = initmodel;
    if needstateprob == 0
        pdfbprotrain_thmt(ns, nlevel, levndir, tree ,mD, model);
    else
        ns = initmodel.nstates;
        for l = 1:nlevel
            numofel = length(tree{l});
            stateprob{l} = ones(numofel, ns);
        end;
        pdfbprotrain_thmt(ns, nlevel, levndir, tree, mD, model, stateprob);
    end;
end;

    