function [data, count] = ffareadsubset(fid, header, position, size, offsetFlag)

%   function [line, count] = ffaread(fid, header, position, size, offsetFlag);
%
%   This function will read a subset of data from the file into memory.
%
%
%   Input:
%       filename                - full path and filename of the input file
%       header                  - structure containing file header information
%       position                - the position of the start of the subset [ Px Py Pz]
%       size                    - the size of the subset [ Sx Sy Sz ]
%       offsetFlag (optional)   - flag to determine whether to offset unsigned data to be
%                                 centred around zero.  
%
%                                 0         = do not offset the trace (default)
%                                 non-zero  = unsigned data to be centred around zero.
%
%
%   Return:
%       data        - binary data read from the file       
%       count       - number of voxels read from the file
%
%
%   NOTE: the subset is extracted voxel-wise. i.e. negative positions are 
%   not valid. However, resulting data subset is flipped according to the
%   sign if the header.scale values
%
%
%   NOTE: Reading subsets is slow and only suitable for extracting data
%   when the source volume is very large. For smaller managable volumes it
%   is much faster to load the entire volume [ffaread.m] and use Matlab array access
%   commands to pull out data.
%
%
%   See Also: ffareaddata.m, ffaread.m, ffaopen.m
%
%
%


%
%   Author          Date            Comment
%   S.J.Purves      29.04.02        Initial Implementation
%   A.J.Eckersley   20.06.07        Offset option added
%
%
%


msg = nargchk(4,5,nargin);
if (~isempty(msg))
    disp(msg);
    return
end

if nargin < 5
    offsetFlag = 0;
end



% validate the header structure

check = ~isempty(header.ffaid);
check = check & ~isempty(header.signflag);
check = check & ~isempty(header.floatflag);
check = check & ~isempty(header.signflag);
check = check & ~isempty(header.databits);
check = check & ~isempty(header.voxelbits);
check = check & ~isempty(header.numdims);
check = check & ~isempty(header.size);

if (~check)
    disp('Invalid header information');
    return;
end


extent = position + size;

if (( extent(1) > header.size(1) ) | ( extent(2) > header.size(2) ) | ( extent(3) > header.size(3) ))
    disp('subset extends outside of the data volume');
    return
end



% open file and check
status = fseek(fid,0,'eof');
if (status == -1)
    disp('seek failure for eof, invalid fid?')
    return
end


% need to read data in planes to navigate file properly
databytes = (header.databits / 8);
start_byte = 604;

volume_plane_voxels = header.size(1) * header.size(2);
volume_plane_bytes = volume_plane_voxels * databytes;

offset = position(3) * volume_plane_voxels;          % get to the right plane
offset = offset + position(2) * header.size(1);     % get to the right line
offset = offset + position(1);                      % get to the right voxel

start_byte = start_byte + offset * databytes; % this is the correct start byte


subset_plane_voxels = size(1) * size(2);
subset_size = subset_plane_voxels * size(3);
subset_plane_bytes = subset_plane_voxels * databytes;

next_line_bytes = (header.size(1) - size(1)) * databytes; % bytes between end of one line to start of next


count = 0;
data = [];

for z = 1:size(3) % for each x-y plane in the subset
   
    status = fseek(fid, start_byte, 'bof');
    if (status == -1)
        disp(['seek failure for byte ' start_byte])
        return
    end
    
    
    for y = 1:size(2)
      
       T = ftell(fid);
       % read in the data
       [d, c] = fread(fid, size(1), header.binarytype);
       d = d';
       count = count + c;

       if offsetFlag ~= 0
           d = offsetData( d, header.binarytype );
       end
       
       T = ftell(fid);
       % append to rest of subset so far
       data = [data d];
        
       
       T = ftell(fid); 

       if ( y ~= size(2) && z ~= size(3) )
           status = fseek(fid, next_line_bytes, 'cof');
           if (status == -1)
                disp(['seek failure, Z: ' num2str(z) ', Y: ' num2str(y)]);
                return
           end
       end

    end
    T = ftell(fid);   

    
    % set start_byte to the start ofhte next plane
    start_byte = start_byte + volume_plane_bytes;
    
end

if (count ~= subset_size)
    disp('complete subset was not read from the file');
    disp([count ' bytes read; ' data_size ' bytes expected']);
    return;
end

data = reshape(data, size(1), size(2), size(3));

if (header.scale(1) < 0)
    data = flipdim(data,1);
end

if (header.scale(2) < 0)
   data = flipdim(data,2);
end

if (header.scale(3) < 0)
   data = flipdim(data,3);
end


