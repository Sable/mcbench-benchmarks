% GRAPHLABEL  Label a graph based upon a graph cut.
%
%   L = GRAPHLABEL(C, P) gives a labeling for
%   a set of nodes, given the following inputs:
%
%   C is a cost matrix where C(i,j) is the cost of assigning label i to node j.
%   P is a square matrix giving the penalty for assigning two nodes different labels.
%   I is an optional initial labeling.
%   N is the number of cycles, and defaults to 1.
%
%   If C is 2xN, an exact cut is returned using GCUT.
%   If C has more than two rows, then an approximate labeling is returned.

function label = graphlabel(C,P)

cut = gcut([zeros(2),C;C',P],[1 2]);
label = cut(3:end);  % We want just the pixel labels
