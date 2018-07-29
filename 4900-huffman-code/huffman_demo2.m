function huffman_demo2
%HUFFMAN_DEMO2
%   This demo shows compression-decompression of different data.

%   $Author: Giuseppe Ridino' $
%   $Revision: 1.0 $  $Date: 02-Jul-2004 16:47:25 $


fprintf('\n')
disp('This is an example of function using Huffman compression-decompression')
disp('Press a key to continue...')
pause
fprintf('\n')

fprintf('\n')
disp('The string below will be compressed and decompressed')
disp('using norm2huff and huff2norm functions')
disp('Press a key to continue...')
pause
fprintf('\n')

data1 = 'This is a string demo. It will be compressed using norm2huff function.'

fprintf('\n')
disp('Now we will compress and decompress it.')
disp('But pay attention that data mut be converted to uint8!')
disp('Press a key to continue...')
pause
fprintf('\n')

% string data
data1 = uint8(data1);
[zipped1,info1] = norm2huff(data1)
unzipped1 = char(huff2norm(zipped1,info1))

isOK = isequal(data1,unzipped1)

whos data1 zipped1 unzipped1

bar(frequency(data1)); axis tight

%  random data1
fprintf('\n')
disp('Now we will try to compress a random sequence of 1000 bytes')
disp('Press a key to continue...')
pause
fprintf('\n')

data3 = uint8(256*rand(1,1000));
[zipped3,info3] = norm2huff(data3);
unzipped3 = huff2norm(zipped3,info3);

isOK = isequal(data3,unzipped3)

whos data3 zipped3 unzipped3

bar(frequency(data3)); axis tight

fprintf('\n')
disp('It is not well compressed. Why?')
disp('This is because the sequence is normally random!')
disp('Press a key to continue...')
pause
fprintf('\n')

%  random data2
fprintf('\n')
disp('Now we will try to compress a random sequence of 1000 bytes but not normally distributed')
disp('Press a key to continue...')
pause
fprintf('\n')

data4 = uint8(256*rand(1,1000).^3);
[zipped4,info4] = norm2huff(data4);
unzipped4 = huff2norm(zipped4,info4);

isOK = isequal(data4,unzipped4)

whos data4 zipped4 unzipped4

bar(frequency(data4)); axis tight

fprintf('\n')
disp('As the distribution is not uniform, the compression ratio is a bit more significant')
disp('Press a key to continue...')
pause
fprintf('\n')

% TERMINATED
fprintf('\n')
disp('#### FINISH ####')
