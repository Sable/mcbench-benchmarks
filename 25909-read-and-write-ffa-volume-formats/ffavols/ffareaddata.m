function [data, count] = ffareaddata(fid, header, offsetFlag)

%   function [data, count] = ffareaddata(fid, header, offsetFlag);
%
%   This function will read the entire data volume from an ffa format data file.
%
%   Input:
%       filename                - full path and filename of the input file
%       header                  - structure containing file header information
%       offsetFlag (optional)   - flag to determine whether to offset unsigned data to be
%                                 centred around zero.  
%
%                                 0         = do not offset the trace (default)
%                                 non-zero  = unsigned data to be centred
%                                             around zero.
%
%   Return:
%       data                    - binary data read from the file       
%       count                   - number of voxels read from the file
%
%
%   See Also: ffaopen.m, ffaread.m, ffareadsubset.m
%
%

%
%   Author          Date            Comment
%   S.J.Purves      29.04.02        Initial Implementation
%   A.J.Eckersley   20.06.07        Offset option added
%
%
%


msg = nargchk(2,3,nargin);
if (~isempty(msg))
    disp(msg);
    return
end
if nargin < 3
    offsetFlag = 0;
end

status = fseek(fid,0,'eof');
if (status == -1)
    disp('seek failure for eof, invalid fid?')
    return
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


num_voxels = header.size(1) * header.size(2) * header.size(3);
data_size = (header.databits / 8)  * num_voxels;
file_size = data_size + 604;

% checks complete, read the data
status = fseek(fid,604,'bof');
if (status == -1)
    disp('seek failure for byte 604')
    return
end

[d,c] = fread(fid, num_voxels, header.binarytype);

if (c ~= num_voxels)
    disp('not all a data was read from the file');
    disp([c ' bytes read; ' data_size ' bytes expected']);
    return;
end


data = reshape(d, header.size(1), header.size(2), header.size(3));

if (header.scale(1) < 0)
  data = flipdim(data,1);
end

if (header.scale(2) < 0)
  data = flipdim(data,2);
end

if (header.scale(3) < 0)
  data = flipdim(data,3);
end

if offsetFlag ~= 0
    data = offsetData( data, header.binarytype );
end

count = c;






















