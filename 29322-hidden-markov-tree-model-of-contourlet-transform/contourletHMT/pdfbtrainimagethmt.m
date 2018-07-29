% pdfbtrainimagethmt.m
% written by: Duncan Po
% Date: August 24, 2002
% Using the EM algorithm, train models for the specified image
% Usage: [model, stateprob] = pdfbtrainimagethmt(imname, imformat, initmodel, mD)
% Inputs:   imname      - name of the image file
%           imformat    - format of the image file (e.g. 'gif')
%           initmodel   - optional. Give an intial model to speed up the training
%                         process. Input '' if not providing initial model.
%           mD          - convergence value
% Output:   model       - the model generated
%           stateprob   - state probabilities

function [model, stateprob] = pdfbtrainimagethmt(imname, imformat, initmodel, mD)

pyrfilter = '9-7';
dirfilter = 'pkva';
levndir = [2 2 3 3];
ns = 2;
zeromean = 'yes';

coef = contourlet(pyrfilter, dirfilter, levndir, imname, imformat);

for dir = 1:2.^levndir(1)
    [tree, scaling] = contourlet2tree(coef, dir);
    if isempty(initmodel)
        [tempmodel, tempstateprob] = pdfbtrainthmt(tree, levndir, mD, ns,zeromean);
    else
        [tempmodel, tempstateprob] = pdfbtrainthmt(tree, levndir, mD,...
            initmodel{dir});
    end;
    model{dir} = tempmodel;
    stateprob{dir} = tempstateprob;
end;


