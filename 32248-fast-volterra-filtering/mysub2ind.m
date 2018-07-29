function ndx = mysub2ind(siz,subinds)

k = [1 cumprod(siz(1:end-1))];
ndx = ones(size(subinds,1),1);
for i = 1:size(subinds,2)
    for r =1:size(subinds,1)
        v = subinds(r,i);
        ndx(r) = ndx(r) + (v-1)*k(i);
    end;
end
