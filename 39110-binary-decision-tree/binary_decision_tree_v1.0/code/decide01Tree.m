% This function performs the binary decision tree testing. 

% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Q. Wang, Y. Ou, A.A. Julius, K.L. Boyer, M.J. Kim, 
% Tracking tetrahymena pyriformis cells using decision trees, 
% in: 2012 International Conference on Pattern Recognition, Tsukuba Science City, Japan.
% 
% For commercial use, please contact the authors. 

function [y p]=decide01Tree(x,T)

% x: one data sample, row vector
% T: decision tree
% y: resulting label
% p: resulting probability of being label 1

k=1; % node index
d=1; % depth
c=1; % column

while d<T.depth
    if T.feature(k)==-1
        y=0;
        p=0;
        return;
    elseif x(T.feature(k))<=T.threshold(k)
        k=left_child(k);
        [d c]=index2depth(k);
    else
        k=right_child(k);
        [d c]=index2depth(k);
    end
end
p=T.leaf_prob(c);
if p>0.5
    y=1;
else
    y=0;
end