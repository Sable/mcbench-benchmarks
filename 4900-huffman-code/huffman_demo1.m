function huffman_demo1
%HUFFMAN_DEMO1
%   Data compression-decompression demo.
%   A text string taken from MATLAB help is used.

%   $Author: Giuseppe Ridino' $
%   $Revision: 1.1 $  $Date: 04-Jul-2004 16:47:25 $


% data
data = ['Practical purposes often demand a separation of intermediate and leaf nodes'...
		' during that process. If you do that store the leaf nodes in an array of size'...
		' alphabetsize-1 and fill it from left to right. Since intermediate nodes are'...
		' constructed in the sequence they are used you just need two pointers;'...
		' one pointing to the next unfilled place and one pointing to the next unused'...
		' intermediate node. You don''t have to do the heap sink down that often this way;'...
		' you just compare the top of the heap containing the symbols with the unused'...
		' intermediate node. If you like you could also sort the symbols by probability'...
		' first and then use them in the sequence of increasing probability.'...
		' The result is the same; if you sort first you might use quicksort,'...
		' if you keep the heap idea you (implicitly) use heapsort to sort the symbols.'];
data = uint8(data);

% compress data
fprintf('Compresing data ... ')
[zipped,info] = norm2huff(data);
fprintf('Done!\n')

% decompress data
fprintf('Decompressing data ... ')
unzipped = huff2norm(zipped,info);
fprintf('Done!\n')

% test it
isOK = isequal(data(:),unzipped(:))

whos data zipped unzipped
