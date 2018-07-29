function cd2EditedFile()
% cd2EditedFile: goes to the the file opened in editor
%
% references at:
% <<http://blogs.mathworks.com/community/2011/05/16/matlab-editor-api-examples/>>

% Copyright 2012, Clemens Ager
%%
a = fileparts(matlab.desktop.editor.getActiveFilename);
cd(a);