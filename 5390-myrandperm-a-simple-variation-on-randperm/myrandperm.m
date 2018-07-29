function permMat = myrandperm(inputMat)
% MYRANDPERM(A) returns matrix A with elements randomly permuted.  This
% function uses RANDPERM.

numElements = prod(size(inputMat));
randInd = randperm(numElements);

permVect = inputMat(randInd);
permMat = reshape(permVect,size(inputMat));