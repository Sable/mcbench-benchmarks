function huffman_test1
% HUFFMAN_TEST1
% This is a simple test to have a code profile of the functions


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 02-Jul-2004 16:47:25 $


profile clear
profile on -history

tic

data = uint8(256*sin(1:100000));
[zipped,info] = norm2huff(data);
unzipped = huff2norm(zipped,info);

toc

unzipped = uint8(unzipped);
ok = isequal(data,unzipped)

profile off
profile report