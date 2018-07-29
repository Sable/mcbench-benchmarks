% This function performs the binary decision tree training. 

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

function T=create01Tree(X,label,Depth,Splits,MinNode)

% X: N*M training data matrix, each row is one sample
% label: N*1 labels of training data, each entry takes value 0 or 1
% Depth: maximal depth of decision tree
% Splits: number of candidate thresholds at each node
% MinNode: minimal size of a non-leaf node
% T: resulting decision tree

T=struct('feature',zeros(2^(Depth-1)-1,1),...
    'threshold',zeros(2^(Depth-1)-1,1),...
    'leaf',zeros(2^(Depth-1),2),...
    'leaf_prob',zeros(2^(Depth-1),1),...
    'depth',Depth);

T=get01Tree(1,T,X,label,Depth,Splits,MinNode);