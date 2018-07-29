

% Example for the adjacency matrix of
%      0     0     1     1     1    -1     1     0
%      0     0     1    -1     0     1     1    -1
%      1     1     0     0     0     1     0     0
%      1    -1     0     0     0     0    -1     0
%      1     0     0     0     0     1    -1     1
%     -1     1     1     0     1     0     1    -1
%      1     1     0    -1    -1     1     0     0
%      0    -1     0     0     1    -1     0     0
% and 100 iterations of simulations

load adj2
heider(adj2,100);