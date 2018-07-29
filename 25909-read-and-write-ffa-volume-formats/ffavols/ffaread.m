function [data, header, count] = ffaread(filename, offsetFlag)

%   function [data, header, count] = ffaread(filename, offsetFlag);
%
%   This function will read a whole ffa format data volume into memory.
%   
%   Input:
%       filename                - full path and filename of the input file
%       offsetFlag (optional)   - flag to determine whether to offset unsigned data to be
%                                 centred around zero.  
%
%                                 0         = do not offset the trace (default)
%                                 non-zero  = unsigned data to be centred around zero.
%
%
%   Return:
%       data                    - binary data read from the file       
%       header                  - structure containing file header information
%       count                   - number of voxels read from the file
%
%
%   See Also: ffareaddata.m, ffaopen.m, ffareadsubset.m
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
%


msg = nargchk(1,2,nargin);
if (~isempty(msg))
    disp(msg);
    return
end
if nargin < 2
    offsetFlag = 0;
end

[fid, header] = ffaopen(filename);
if (fid == -1)
    disp(['Could not open ' filename]);
    data = [];
    header = [];
    count = 0;
    return;
else
    [data, count] = ffareaddata(fid,header,offsetFlag);
    fclose(fid);
end
