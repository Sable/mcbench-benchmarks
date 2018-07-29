function [ v_adj ] = get_voronoi_adj(x)
%% returns the first-shell Voronoi N-by-N adjacency matrix v_adj, given an N-by-2 matrix x of positions  
    
    %  Adam Zienkiewicz (2013) - adam.zienkiewicz@bristol.ac.uk
    %  University of Bristol : Centre for Complexity Sciences
    
    % number of data points
    N = size(x,1);

    % for less one or two data points, first shell is all other points
    if N < 4
        v_adj = sparse(ones(N,N));
        v_adj = v_adj - diag(diag(v_adj));
        return
    end  
    
    % zerod adjacency (sparse) matrix
    v_adj = sparse(N,N);
    
    % calculate Voronoi tesselation (MATLAB func.)
    [v,g] = voronoin(x);
    
    % retrieve edge data given the Voronoi vertex information in g
    all_edges = [];
    for node = 1:N
        if size(g{node},2) > 2
              n_edges = size(g{node},2);
        else
            n_edges = 1;
        end
        e_list = zeros(n_edges,2);
        e_list(n_edges,:) = [g{node}(1) g{node}(end)];
        if n_edges > 1
            for vertex = 1:n_edges-1
                e_list(vertex,:) = [g{node}(vertex) g{node}((vertex+1))];
            end
        end
        
        % sort edge list for this node
        e_list  = sort(e_list,2);
        e_list = sortrows(e_list,[1 2]);
        
        % compile list of all Voronoi edges, prefixed with data node #
        all_edges = [all_edges;[node*ones(n_edges,1),e_list]];
    end

    % sort full edge list by edges - forward difference to find duplicates (=0)
    sort_edges = sortrows(all_edges,[2,3]);
    d_rows = diff(sort_edges(:,2:3));
    idx =  [~(d_rows(:,1)|d_rows(:,2));0];
    
    % list of neigbours for each connected group found
    nb = [];
    for c = 1:size(idx,1)
        % where duplicate (shared) edges are found, add to group of connected nodes
        nb = [nb,sort_edges(c,1)];
        if idx(c) == 0
            % group complete - update adjacency with each node pair
            for ii = 1:size(nb,2)-1
                for jj = ii+1:size(nb,2)
                    v_adj(nb(ii),nb(jj)) = 1;
                end
            end
            % clear array for next group
            nb = [];
        end
    end
    
    % complete lower triangle of adjacency by adding the transpose
    v_adj = v_adj + v_adj';
    
    % ####################################################
    % PLOTS FOR INFORMATION
    % plot voronoi tesselation and number nodes
%     voronoi(x(:,1),x(:,2));
%     for ii = 1:N
%         h = text(x(ii,1),x(ii,2),[' ',num2str(ii)]);
%         set(h,'FontSize',12);
%     end
%     hold on; plot(v(:,1),v(:,2),'r.')
%     for ii = 2:size(v,1);
%         h = text(v(ii,1),v(ii,2),[' (',num2str(ii),')']);
%         set(h,'FontSize',8);
%     end
%     % calc. and plot delaunay triangulation
%     dt = DelaunayTri(x(:,1),x(:,2));
%     hold on; triplot(dt,'r-');

end

