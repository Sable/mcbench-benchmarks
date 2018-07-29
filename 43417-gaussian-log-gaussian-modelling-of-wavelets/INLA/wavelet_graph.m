function wavelet_graph( L, save_file )

% Neighbor matrix for wavelet tree for use in INLA
% The dependency structure in the GLG model is specified as a graph in
% INLA. Note that this is *not* the usual structure for graphs in INLA.
% The output is written to a file.
%
% Syntax:
%   wavelet_graph( L, save_file )
%
%
% Input:
%   L    : The number of levels in the transform
%
%   file : Filename for save file
%
%
% See also: DWT2_TO_GRAPH

% A wavelet tree in one dimensions with three levels look like
%
%      1
%    /   \
%   2     3
%  / \   / \
% 4   5 6   7
%
% In two dimensions each node has four children.
%

% Each line of the output file contains a node number and one child

level2total = @(L) (4^L - 1)/3;
number2level = @(M) ceil( log(3*M+1)/log(4) );

% The total number of nodes with children
N = level2total(L-1);

fid = fopen( save_file, 'w' );

% Write the neighbors of each node
for j = 1:N
    % Level of current node
    cur_lev = number2level( j );
    
    % Number within level
    nl = j - level2total( cur_lev );
    
    % Children = children number within their level + the total number at
    % present level
    C = (nl-1)*4 + (1:4) + level2total(cur_lev+1);
    
    % Write to file
    for c = 1:numel(C)
        fprintf( fid, '%u %u\n', j, C(c) );
    end
end

fclose( fid );

end
