function maximalcliques_subgraphs = maximalCliques( X, MAX_CLIQUE_SIZE )
%MAXIMALCLIQUES finds all the maximal complete sub-graphs in a graph
%   @args:
%       X: The upper triangular adjacency graph
%       MAX_CLIQUE_SIZE: (Optional) gives the maximum size of the maximal
%               cliques wanted
%
%   The graph passed must be an upper rectangular square matrix. Each row
%   of a matrix denotes the presence of an edge with 1, and an absence of
%   it with 0. The row and col no. of an edge denotes the connecting nodes.
%   Given this matrix, this function finds all the maximal complete 
%   sub-graph (a set of nodes amongst all the nodes which form a complete 
%   sub-graph i.e. every node connects to every other) also known as 
%   cliques. A maximal graph is returned since every complete sub-graph 
%   will also have smaller complete sub-graphs inside itself. NOTE: this 
%   function would not return single node sub-graphs, although every
%   isolated node, in concept, also forms a complete sub-graph
%   The function returns all the sub-graphs in a cell-array, where each
%   row denotes a new sub-graph
%
%   @author: Ahmad Humayun
%   @date: 1st June 2010

%TEST CASES

% A = [-1  1  1  0  0  0
%      -1 -1  1  0  0  0
%      -1 -1 -1  1  0  1 
%      -1 -1 -1 -1  0  1
%      -1 -1 -1 -1 -1  0
%      -1 -1 -1 -1 -1 -1 ];
%
% B = [-1  1  1  0  1  1
%      -1 -1  1  1  1  1
%      -1 -1 -1  1  1  1 
%      -1 -1 -1 -1  1  0
%      -1 -1 -1 -1 -1  1
%      -1 -1 -1 -1 -1 -1 ];
%
% C = [-1  0  0  0  0  0  0  0  0
%      -1 -1  1  1  0  0  0  0  0
%      -1 -1 -1  0  0  0  0  0  0
%      -1 -1 -1 -1  0  0  0  0  0
%      -1 -1 -1 -1 -1  0  0  0  0
%      -1 -1 -1 -1 -1 -1  0  1  0
%      -1 -1 -1 -1 -1 -1 -1  0  1
%      -1 -1 -1 -1 -1 -1 -1 -1  1
%      -1 -1 -1 -1 -1 -1 -1 -1 -1 ];

    WARNING_CONNECTING_NODES_LENGTH = 50;
    
    [m n] = size(X);
    
    assert( m == n, 'The matrix should be square, cause each side denotes the nodes in the same graph' );

    if n > WARNING_CONNECTING_NODES_LENGTH
        warning('maximalCliques:LargeGraph', 'The adjacency graph is quite large and might be computationally expensive to compute');
    end
    
    if ~exist('MAX_CLIQUE_SIZE', 'var') || MAX_CLIQUE_SIZE < 2
        MAX_CLIQUE_SIZE = inf;
    end
    
    % the cell array which will hold the solution
    maximalcliques_subgraphs = {};
    
    % discard the lower triangular matrix, just in case it has values
    X = triu(X, 1);
    
    node_list = (1:n)';
    possible_comb_list = cell(n,1);
    
    %% Set the stage for make maximal cliques starting from size 2
    %   essentially the following few lines is a simpler version of the
    %   steps performed from line 89
    new_graph = false(nnz(X),n);
    new_node_list = zeros(nnz(X),2);
    combs_not_consumed = true(1, length(node_list));
    comb_no = 0;
    % wherever possible, join two rows to make graph of paired nodes
    for r = 1:size(X,1)
        comb_nodes = find(X(r,:));
        if ~isempty(comb_nodes)
            combs_not_consumed(r) = 0;
            
            for comb_node = comb_nodes
                comb_no = comb_no + 1;
                new_graph(comb_no,:) = X(r,:) & X(comb_node,:);
                new_node_list(comb_no,:) = [r, comb_node];
                possible_comb_list{comb_node} = [possible_comb_list{comb_node} comb_no];
                combs_not_consumed(comb_node) = 0;
            end
        end
    end
    % uncomment if you consider a single node as a maximal clique
%     for comb_no = find(combs_not_consumed)
%         maximalcliques_subgraphs = [maximalcliques_subgraphs; node_list(comb_no)];
%     end
    % shift lists for the next stage
    node_list = new_node_list;
    X = new_graph;
    
    
    %% starting from step which sieves out cliques of size 2
    clique_size = 2;
    
    % loop until either the cliques required at this step cannot be
    %  produced (because enough connecting nodes are not a available) or
    %  the node combinations no longer has any connection
    while size(X,1) >= clique_size+1 && any(any(X))
        % create the graph for the next iteration
        new_graph = false(nnz(X), n);
        
        % create the  node combination list for the next iteration
        new_node_list = zeros(nnz(X), clique_size+1);
        
        % keep a list of node combinations which are not used (these will
        %  form our cliques at this step)
        combs_not_consumed = true(1, length(node_list));
        
        % row list for quicker searching of possible node combinations
        new_possible_comb_list = cell(n,1);
        
        % to check in which row of new_graph to insert the new node
        %  combination adjacency graph (row)
        comb_no = 0;
        
        % inner loop iterating over all rows of the node combination graph
        for r = 1:size(X,1)
            % for the current row in the node combination graph, see which
            %  nodes it connects to
            comb_nodes = find(X(r,:));
            
            % if there are any connecting nodes for this node combination
            if ~isempty(comb_nodes)
                % mark the current row as used (hence cant form a clique at
                %  at the current size)
                combs_not_consumed(r) = 0;

                % iterate over all the connecting nodes
                for comb_node = comb_nodes
                    % increment the row number to insert in new_node_list
                    comb_no = comb_no + 1;
                    
                    % if using the current connecting node, what would be
                    %  the new set of node combinations
                    comb_nodes = [node_list(r,:) comb_node];
                    
                    % insert the previous row into the new_graph as a
                    %  starting point
                    new_graph(comb_no,:) = X(r,:);
                    
                    % counter to AND rows - so we can premprtively stop
                    rows_anded = 1;
                    
                    % iterate over all the rows and see which need to be
                    %  ANDed - use hints from possible_comb_list
                    for temp_comb_no = possible_comb_list{comb_node}
                        % check if the current suggestion actually needs to
                        %  be ANDed for our new nodes combination
                        if checkIfRowsCanBeCombined(node_list(temp_comb_no,:), comb_nodes)
                            % if so AND its row
                            new_graph(comb_no,:) = new_graph(comb_no,:) & X(temp_comb_no,:);
                            % increment counter
                            rows_anded = rows_anded + 1;
                            % mark the row as consumed
                            combs_not_consumed(temp_comb_no) = 0;
                            
                            % if enough rows have been ANDed to make the
                            %  next sized clique, break premptively
                            if rows_anded == clique_size + 1
                                break;
                            end
                        end
                    end
                    
                    assert(rows_anded == clique_size+1, 'Something is wrong with ANDing rows');
                    
                    % store the new nodes combination set
                    new_node_list(comb_no,:) = comb_nodes;
                    
                    % iterate over nodes combination and adjust
                    %  new_possible_comb_list for effective hints for the
                    %  next iteration
                    for temp_node_no = comb_nodes(2:end)
                        new_possible_comb_list{temp_node_no} = [new_possible_comb_list{temp_node_no} comb_no];
                    end
                    
                end
            end
        end

        % iterate over all rows which are not consumed and mark them as
        %  cliques for this stage
        for comb_no = find(combs_not_consumed)
            maximalcliques_subgraphs = [maximalcliques_subgraphs; node_list(comb_no,:)];
        end
        
        % shift lists for the next iteration
        node_list = new_node_list;
        possible_comb_list = new_possible_comb_list;
        X = new_graph;
        
        % if that is the maximum clique size the user requires
        if clique_size >= MAX_CLIQUE_SIZE
            return;
        end
        
        % next iteration will look for maximal cliques of a bigger size
        clique_size = clique_size + 1;
    end
    
    % add remaining maximal cliques to the list
    maximalcliques_subgraphs = [maximalcliques_subgraphs; num2cell(node_list,2)];
end


function same_list = checkIfRowsCanBeCombined(check_nodes, comb_nodes)
% used to see if the nodes pointed by check_nodes are all present in
%  comb_nodes. This function is a speedup of:
%       all(ismember(check_nodes, comb_nodes)

    same_list = 1;
    
    for test_node = check_nodes
        if ~any(test_node == comb_nodes)
            same_list = 0;
            return;
        end
    end
end