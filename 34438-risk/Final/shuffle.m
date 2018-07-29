function seq = shuffle(seq, N)

count = 0;
while count < N
    pair = round(rand(1,2) * (numel(seq) - 1)) + 1;
    tmp = seq(pair(1));
    seq(pair(1)) = seq(pair(2));
    seq(pair(2)) = tmp;
    count = count + 1;
end