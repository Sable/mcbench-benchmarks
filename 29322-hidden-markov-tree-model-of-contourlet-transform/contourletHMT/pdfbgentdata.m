% pdfbgentdata.m
% written by: Duncan Po
% Date: August 24, 2002
% Using the provided model, generate random data in tree structure
% Usage: tree = pdfbgentdata(model, ntrees)
% Inputs:   model       - the model needed for data generation
%           ntrees      - number of data elements at root level of the tree
% Output:   tree        - generated data in tree structure

function tree = pdfbgentdata(model, ntrees)

nlevel = length(model.stdv);
for k = 1:nlevel
    levndir(k) = log2(length(model.stdv(k)));
end;

tree = pdfbgen_tdata(model, nlevel, ntrees, levndir);
