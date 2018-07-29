function ret = getdrives(varargin)
%GETDRIVES  Get the drive letters of all mounted filesystems.
%   F = GETDRIVES returns the roots of all mounted filesystems as a cell
%   array of char arrays.
%   
%   On Windows systems, this is a list of the names of all single-letter 
%   mounted drives.
%
%   On Unix systems (including Macintosh) this is the single root
%   directory, /.
% 
%   F = GETDRIVES('-nofloppy') does not scan for the a: or b: drives on
%   Windows, which usually results in annoying grinding sounds coming from
%   the floppy drive.
%   
%   F = GETDRIVES('-twoletter') scans for both one- AND two-letter drive
%   names on Windows.  While two-letter drive names are technically supported,
%   their presence is in fact rare, and slows the search considerably.
%
%   Note that only the names of MOUNTED volumes are returned.  In 
%   particular, removable media drives that do not have the media inserted 
%   (such as an empty CD-ROM drive) are not returned.
%
%   See also EXIST, COMPUTER, UIGETFILE, UIPUTFILE.

%   Copyright 2001-2009 The MathWorks, Inc.

% Short-circut on non-Windows machines.
if ~ispc
    ret = {'/'};
    return;
end

twoletter = false;
nofloppy = false;

% Interpret optional arguments
for i = 1:nargin
    if strcmp('-nofloppy', varargin{i}), nofloppy = true; end
    if strcmp('-twoletter', varargin{i}), twoletter = true; end
end

% Initialize return cell array
ret = {};

% Handle -nofloppy flag, or lack thereof.
startletter = 'a';
if nofloppy
    startletter = 'c';
end

% Look for single-letter drives, starting at a: or c: as appropriate
for i = double(startletter):double('z')
    if exist(['' i ':\'], 'dir') == 7
        ret{end+1} = [i ':\']; %#ok<AGROW>
    end
end

% Handle two-letter case.  The outer loop of this routine could have been
% combined with the one above, but was left separate for clarity's sake.
if twoletter
    for i = 'a':'z'
        for j = 'a':'z'
            if exist([i j ':\'], 'dir') == 7
                ret{end+1} = [i j ':\']; %#ok<AGROW>
            end
        end
    end
end