function table = distable(board, player)

n = numel(board);
table = NaN * zeros(n);

for i = 1:n
    table(i,i) = 0;
    neighbors = board(i).Neighbors;
    occupant = zeros(1, numel(neighbors));
    for j = 1:numel(neighbors)
        tmp = get(board(neighbors(j)).Patch, 'UserData');
        occupant(j) = tmp(1);
    end
    table(i, neighbors(occupant == player)) = 1;
    d = 1;
    N = -1;
    while nnz(~isnan(table(i,:))) ~= N;
        N = nnz(~isnan(table(i,:)));
        for j = find(table(i,:) == d)
            neighbors = board(j).Neighbors;
            for k = neighbors
                occupant = get(board(k).Patch, 'UserData');
                if i ~= k && isnan(table(i, k)) && occupant(1) == player
                    table(i, k) = d + 1;
                end
            end
        end        
        d = d + 1;
    end
end