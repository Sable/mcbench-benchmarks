function hc = binHist(S)
% hc = binHist(S)
%   Generates histogram for binary vectors in S
%   S = D * N matrix
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling


D = size(S,1);
C = binBinaryToDec(S);
hc = countElem(C,0,2^D);
