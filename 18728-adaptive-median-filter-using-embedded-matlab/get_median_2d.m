%#eml
function [min,med,max] = get_median_2d(inbuf)

[nrows ncols] = size(inbuf);

tbuf = inbuf;

for ii=eml.unroll(1:nrows)
    tbuf(ii, :) = get_median_1d(inbuf(ii, :));
end
    
for jj=eml.unroll(1:ncols)
    tbuf(:, jj) = get_median_1d(tbuf(:, jj)')';
end

min = tbuf(1, 1);
med = tbuf(ceil(nrows/2), ceil(ncols/2));
max = tbuf(nrows, ncols);

end

