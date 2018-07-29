function out = getDirectoryContents(theDir, opts)
%Get the contents of a directory 
% OUT = GETDIRECTORYCONTENTS(THEDIR, OPTS)
% Function returns the contents of a directory (THEDIR) omiting the . and ..
% listings from a directory listing (ls). This function can be considered
% as an overload of the built-in function dir. dir function returns also
% the . and .. entries. If no argument is specified then the contents of
% the current directory are returned. If special file format is specified
% at the OPTS argument then only those files that are of the specified
% format are returned. Valid arguments for OPTS are all file extensions
% recognised by the system and the keyword folder. If folder is used as
% OTPS argument then only directories are returned. 
%
% Examples:
%
% - Get the folders of the current directory:
%   >> getDirecoryContents(pwd, 'folder')
%
% - Get the wav files at a path stored in variable thePath:
%   >> getDirecoryContents(thePath, 'wav')
%
% Author: Konstantinos Drossos
% Version: 1.0

    if nargin < 2
        opts = 'all'; 
    end
    
    if nargin < 1
        theDir = pwd;
    end 
    
    if ~strcmp(opts, 'all') && ~strcmp(opts, 'folder') 
        searchStr = [theDir '/*.' opts];
    else
        searchStr = theDir;
    end
    
    try
        out = dir(searchStr);
        
        for indx = length(out):-1:1
            if strcmp(out(indx).name(1), '.')
                try
                    if strcmp(out(indx).name(2), '..')
                        out(indx) = [];
                    end
                catch
                end
                out(indx) = [];
            end
        end
        
        if strcmp(opts, 'folder')
            for indx = length(out):-1:1
                if ~(out(indx).isdir)
                    out(indx) = [];
                end
            end
        end
    catch
        error('ERROR:GETDIRECTORYCONTENTS','Wrong directory');
    end
    
    if isempty(out)
        warning('WARNING:GETDIRECTORYCONTENTS', 'No contents found');
    end

end