function D = dirdir( path )
% DIRDIR List subdirectories of a directory.
%     DIR directory_name lists the subdirectories of a directory.
%  
%     D = DIRDIR('directory_name') returns the results in an M-by-1
%     structure with the fields: 
%         name  -- filename
%         date  -- modification date
%         bytes -- number of bytes allocated to the file
%  
%     If no subdirectories are present, an empty structure (0x0) is returned.
%     See also DIR, WHAT, CD, TYPE, DELETE.
%
% author:   Paul Macey [pmacey@ucla.edu]
% version:  1.0
% date:     4-Apr-2002

if nargin == 0
    path = pwd;
end
D = dir(path);

% Get indices of directories - remember, 1st two directories are "." and ".."
I = find([D(3:end).isdir])+2;

% Remove "isdir" field since this is redundant.
D = rmfield(D,'isdir');

% Set D to contain subdirectories only. If I == [],
%   D is returned as a 0x0 structure.
D = D(I);

%
% Alternative for no subdirectories
%  - replaces commands after line 22.
%
% D = D(find([D(3:end).isdir])+2);
% If no subdirectories exist, the following returns D as [].
% D = rmfield(D,'isdir');