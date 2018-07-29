function huffman_bench1
%HUFFMAN_BENCH1
%   This file is a simple benchmark.
%   It uses this M-file as text string to be used.


%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 02-Jul-2004 16:47:25 $


% select this file to be red
file = [mfilename '.m'];

% Reading data
fprintf('Reading file %s ... ',file)
tic
fid = fopen(file,'r');
data = fread(fid,inf,'uint8');
fclose(fid);
toc
fprintf('Done!\n')
data = uint8(data);

fprintf('Compresing data... ')

tic
[zipped,info] = norm2huff(data);
toc

fprintf('Done!\n')

fprintf('Decompressing data...')

tic
unzipped = huff2norm(zipped,info);
toc

fprintf('Done!\n')

isOK = isequal(data(:),unzipped(:))

whos data zipped unzipped

bar(frequency(data)); axis tight
