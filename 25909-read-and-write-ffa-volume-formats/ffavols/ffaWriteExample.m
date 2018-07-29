%
%
%   A Script shoing how to simply write a matrix out to an ffA format file.
%
%
%

%% load some recognisable data
load clown;

%% create an volume with variation in z
sz = [ size(X) 10 ];
data = zeros(sz);

for n = 1:sz(3)
    data(:,:,n) = X + n*10;
end

%% Build the ffa header struct
header = ffablankheader;

header.signflag = 0; % unsigned data
header.floatflag = 0; % integer data
header.databits = 8; % only 8 bit required
header.voxelbits = 8; % must match databits
header.numdims = 3; % always 3 for SVI Pro
header.size = sz;
header.origin = [1 1 1];
header.unitname.x = 'metres'; % to save a few clicks during SVI Pro import
header.unitname.y = 'metres';
header.unitname.z = 'metres';
header.binarytype = ffahdr2precision(header);

%% call the write function remembering to cast/scale my data appropriately
[header] = ffawrite( 'clownvolume2.ffa', header, uint8(data) );