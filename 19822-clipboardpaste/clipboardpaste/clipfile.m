function filename = clipfile(multiselect)
    %clipfile v0.1.1
    %   Usage:
    %       filename = clipfile
    %
    %   Input Arguments:
    %       multiselect (optional)
    %           Boolean indicating whether multiple filenames found on the
    %           clipboard is not an error. By default, multiselect is
    %           false (multiple files cannot be copied to the clipboard).
    %   
    %   Output Arguments:
    %       filename:
    %           Filename, including path.
    %
    %   Description:
    %       Retrieves a filename (with path) from the clipboard. The user
    %       simply needs to select a file, copy it to the clipboard, and
    %       then call this function. If the user selects multiple files,
    %       clipfile will fail if multiselect is false (default behavior).
    %
    %   Example:
    %       Select a file in Windows Explorer/Mac OS Finder/Nautilus/etc
    %       and copy it to the clipboard. Then:
    %       >> filename = clipfile
    %       filename =
    %       C:\Documents and Settings\braines\Desktop\generalizedFosterReactance.pdf
    %
    %   =======================
    %   Written by Bryan Raines on May 6, 2008.
    %   Last updated on May 6, 2008.
    %   ElectroScience Laboratory at The Ohio State University
    %   Email: rainesb@ece.osu.edu
    %
    %   See also clipboardpaste.

    error(nargchk(0,1,nargin));
    
    if nargin < 1
        multiselect = false;
    else
        multiselect = logical(multiselect);
    end
    
    %Get data from clipboard
    clipData = clipboardpaste;
    
    if ~isempty(clipData)
        %Is the data a set of files?
        containsFiles = strcmp(clipData.subType,'file-list');

        if containsFiles
            filename = clipData.data;

            if ~multiselect
                if length(filename) > 1
                    error('Multiple filenames found on the clipboard (multiselect option was false)');
                end

                filename = filename{1};
            end
        else
            error('Clipboard does not contain filename information.');
        end
    else
        error('Clipboard is empty.');
    end
end