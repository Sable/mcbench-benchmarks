function [dims,times_c,times_d,isOK] = huffman_bench2
%HUFFMAN_BENCH2
%   This is a bench file about compression-decompression of random data
%      sized 1000,2000,5000,10000,20000,50000,100000,200000,500000.
%
%   [dims,times_c,times_d,isOK] = huffman_bench2 returns four vectors sized N,
%      being N the number of total tests:
%         dims: lenght of vector used for each test
%      times_c: time spent to compress
%      times_d: time spent to decompress
%         isOK: 1 if test is ok


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 02-Jul-2004 16:47:25 $


% vector lengths
dims = [1000,2000,5000,10000,20000,50000,100000,200000,500000];

% initialize elapsed times
times_c = zeros(size(dims));
times_d = zeros(size(dims));
isOK = zeros(size(dims));

fprintf('\n');
for index = 1:length(dims),
    % create vector
    data = uint8(256*rand(1,dims(index)));
    fprintf('size: %i   compressing: ',dims(index));
    % compress
    tic
    [zipped,info] = norm2huff(data);
    times_c(index) = toc;
    fprintf('%g   decompressing: ',times_c(index));
    % decompress
    tic
    unzipped = huff2norm(zipped,info);
    times_d(index) = toc;
    fprintf('%g   isOK: ',times_d(index));
    % check results
    isOK(index) = isequal(data(:),unzipped(:));
    fprintf('%i\n',isOK(index));
end