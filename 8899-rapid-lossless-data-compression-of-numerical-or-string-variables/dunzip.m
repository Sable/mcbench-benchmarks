function M = dunzip(Z)
% DUNZIP - decompress DZIP output to recover original data
%
% USAGE:
% M = dzip(Z)
%
% VARIABLES:
% Z = compressed variable to decompress
% M = decompressed output
%
% NOTES: (1) The input variable Z is created by the DZIP function and
%            is a vector of type uint8
%        (2) The decompressed output will have the same data type and
%            dimensions as the original data provided to DZIP.
%        (3) See DZIP for other notes.
%        (4) Carefully tested, but no warranty; use at your own risk.
%        (5) Michael Kleder, Nov 2005

import com.mathworks.mlwidgets.io.InterruptibleStreamCopier
a=java.io.ByteArrayInputStream(Z);
b=java.util.zip.InflaterInputStream(a);
isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
c = java.io.ByteArrayOutputStream;
isc.copyStream(b,c);
Q=typecast(c.toByteArray,'uint8');
cn = double(Q(1)); % class
nd = double(Q(2)); % # dims
s = typecast(Q(3:8*nd+2),'double')'; % size
Q=Q(8*nd+3:end);
if cn == 3
    M  = logical(Q);
elseif cn == 4
    M = char(Q);
else
    ct = {'double','single','logical','char','int8','uint8',...
        'int16','uint16','int32','uint32','int64','uint64'};
    M = typecast(Q,ct{cn});
end
M=reshape(M,s);
return
