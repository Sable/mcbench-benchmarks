function node_number = dwt2_to_graph( tree, D, save_file )

% Save wavelet transform for INLA
% Write the coefficients in a wavelet transform along with the
% corresponding node in the wavelet tree.
%
% Syntax:
%   node = dwt2_to_graph( tree, D, file )
%
% Input:
%   tree : Output from DWT2_TO_TREE
%
%   D    : Direction in the wavelet tree
%
%   file : Filename for save file
%
%
% Output:
%   node : Cell like TREE with node number at each coefficient location
%
%
% See also: WAVELET_GRAPH

L = numel(tree) - 1;

tree = tree(2:end);


% --------------------------------------------------------------------
% Get the node number of each coefficient

node_number = cell(1, L);
node_number{1} = ones( size(tree{1}{D}) );
node_number{2} = repmat( [2 4 ; 3 5], size(tree{1}{D}) );

cur_idx = 5;

for l = 3:L
    nodes_in_cell = num2cell( node_number{l-1} );
    
    for k = unique( node_number{l-1} )'
        node_idx = cellfun( @(x) isequal(x, k), nodes_in_cell );
        cur_idx = max(cur_idx) + (1:4);
        
        [nodes_in_cell{node_idx}] = deal( reshape(cur_idx, [2 2]) );
    end
    
    node_number{l} = cell2mat( nodes_in_cell );
end


% --------------------------------------------------------------------
% Write each coefficient and the corresponding node to save_file

if nargin == 2
    return
end

fid = fopen( save_file, 'w' );
fprintf( fid, 'node coef\n' );

for l = 1:L
    w = tree{l}{D};
    
    for k = 1:numel(w)
        fprintf( fid, '%u %f\n', node_number{l}(k), w(k) );
    end
end

fclose(fid);

end
