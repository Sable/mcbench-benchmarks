function size = calculateSize( fileName )
%CALCULATESIZE Calculates the size of a MATLAB file for use in the game Cody
%   CALCULATESIZE(FILENAME) determines the number of nodes in the parse tree
%   associated with the file FILENAME.
%
%   For more information, visit http://www.mathworks.com/matlabcentral/cody
%
%   Copyright 1984-2012 The MathWorks, Inc.

    % MTREE is an undocumented function. It will change in the future 
    % versions of MATLAB.
    t = mtree(fileName,'-file');
    size = length(t.nodesize);
end
