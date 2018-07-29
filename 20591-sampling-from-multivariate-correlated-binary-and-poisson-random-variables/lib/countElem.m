function c = countElem(x,sv,ev)

% c = countElem(x,sv,ev)
%  counts the occurences for each value in [sv,ev)
%
% Code from the paper: 'Generating spike-trains with specified
% correlations', Macke et al., submitted to Neural Computation
%
% www.kyb.mpg.de/bethgegroup/code/efficientsampling


if nargin<2
    sv=0;ev=max(x);
end

c =histc(x,sv:ev-1);