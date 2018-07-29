%#codegen
function outbuf = get_median_2d(inbuf)

outbuf = inbuf;
[nrows ncols] = size(inbuf);
for ii=coder.unroll(1:ncols)
    colData = outbuf(:, ii)';
    colDataOut = get_median_1d(colData)';
    outbuf(:, ii) = colDataOut;
end
for ii=coder.unroll(1:nrows)
    rowData = outbuf(ii, :);
    rowDataOut = get_median_1d(rowData);
    outbuf(ii, :) = rowDataOut;
end
