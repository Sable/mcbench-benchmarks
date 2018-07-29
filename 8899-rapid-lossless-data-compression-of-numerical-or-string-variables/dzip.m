function Z = dzip(M)
% DZIP - losslessly compress data into smaller memory space
%
% USAGE:
% Z = dzip(M)
%
% VARIABLES:
% M = variable to compress
% Z = compressed output
%
% NOTES: (1) The input variable M can be a scalar, vector, matrix, or
%            n-dimensional matrix
%        (2) The input variable must be a non-complex and full (meaning
%            matrices declared as type "sparse" are not allowed)
%        (3) Permitted input types include: double, single, logical,
%            char, int8, uint8, int16, uint16, int32, uint32, int64,
%            and uint64.
%        (4) In testing, DZIP compresses several megabytes of data per
%            second.
%        (5) In testing, random matrices of type double compress to about
%            75% of their original size. Sparsely populated matrices or
%            matrices with regular structure can compress to less than
%            1% of their original size. The realized compression ratio
%            is heavily dependent on the data.
%        (6) Variables originally occupying very little memory (less than
%            about half of one kilobyte) are handled correctly, but
%            the compression requires some overhead and may actually
%            increase the storage size of such small data sets.
%            One exception to this rule is noted below.
%        (7) LOGICAL variables are compressed to a small fraction of
%            their original sizes.
%        (8) The DUNZIP function decompresses the output of this function
%            and restores the original data, including size and class type.
%        (9) This function uses the public domain ZLIB Deflater algorithm.
%       (10) Carefully tested, but no warranty; use at your own risk.
%       (11) Michael Kleder, Nov 2005

s = size(M);
c = class(M);
cn = strmatch(c,{'double','single','logical','char','int8','uint8',...
    'int16','uint16','int32','uint32','int64','uint64'});
if cn == 3 | cn == 4
    M=uint8(M);
end
M=typecast(M(:),'uint8');
M=[uint8(cn);uint8(length(s));typecast(s(:),'uint8');M(:)];
f=java.io.ByteArrayOutputStream();
g=java.util.zip.DeflaterOutputStream(f);
g.write(M);
g.close;
Z=typecast(f.toByteArray,'uint8');
f.close;
return
