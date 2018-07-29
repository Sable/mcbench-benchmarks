function labelmap = points_showsome(bw, nodes, R)

% This function displays some points togther with its neigbours

labelmap = zeros(size(bw));

[M, N]= size(bw);
imdim = M*N + 1;

pt = nodes(:,1:2:end);
pt = pt(find(pt~=0));
labelmap = points_show(bw, pt, R);

for p = 1:size(nodes,1)
    node = nodes(p,:);
    
    % Highlight the connection points
    Neighbor = [-M, 1, M, -1];
    Len = prod(size(Neighbor));

    npix = node(2)+1;
    seeds = [node(1),node(4:2:end)];
    seeds = seeds(1:npix);
    
    for k = 1:npix
        localidx = seeds(k);
        neighidx = localidx + Neighbor;
        for i=1:Len
            idx = neighidx(i);
            if (idx>0) & (idx<imdim)
                labelmap(idx) = 1;
            end
        end
    end
    labelmap(seeds) = 1;
end