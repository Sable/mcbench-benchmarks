function table = distableAll(board)

n = numel(board);
table = NaN * zeros(n);

for i = 1:n
    table(i,i) = 0;
    table(i, board(i).Neighbors) = 1;
    d = 1;
    N = -1;
    while nnz(~isnan(table(i,:))) ~= N;
        N = nnz(~isnan(table(i,:)));
        for j = find(table(i,:) == d)
            for k = board(j).Neighbors
                if i ~= k && isnan(table(i, k))
                    table(i, k) = d + 1;
                end
            end
        end        
        d = d + 1;
    end
end