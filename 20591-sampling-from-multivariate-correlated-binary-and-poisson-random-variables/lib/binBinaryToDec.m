function dec = binBinaryToDec(bin)

% dec = binBinaryToDec(bin)
%   converts binary vectors to corresponding decimal numbers
%   last position is 2^0, first is 2^n-1
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling


bb = (size(bin,1)-1):-1:0;
dec = (2.^bb) * (bin>0);

    