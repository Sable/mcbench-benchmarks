function [filenames, pathname] = uigetfiles
% This is a Java interfaced version of UIGETFILES, that brings multiple file
% open dialog box. 
%
% [filenames, pathname] = uigetfiles; displays a dialog box file browser
% from which the user can select multiple files.  The selected files are
% returned to FILENAMES as an arrayed strings. The directory containing
% these files is returned to PATHNAME as a string. 
%
% A successful return occurs only if the files exist.  If the user selects
% a  file that does not exist, an error message is displayed to the command
% line.  If the Cancel button is selected, zero is assigned to FILENAMES
% and current directory is assigned to PATHNAME. 
% 
% This program has an equivalent function to that of a C version of
% "uigetfiles.dll" downloadable from www.mathworks.com under support, file
% exchange (ID: 331). 
%
% It should work for matlab with Java 1.3.1 or newer.
%
% Shanrong Zhang
% Department of Radiology
% University of Texas Southwestern Medical Center
% 02/09/2004
%
% email: shanrong.zhang@utsouthwestern.edu

% mainFrame = com.mathworks.ide.desktop.MLDesktop.getMLDesktop.getMainFrame;
filechooser = javax.swing.JFileChooser(pwd);
filechooser.setMultiSelectionEnabled(true);
filechooser.setFileSelectionMode(filechooser.FILES_ONLY);
selectionStatus = filechooser.showOpenDialog(com.mathworks.mwswing.MJFrame); 

if selectionStatus == filechooser.APPROVE_OPTION
    pathname = [char(filechooser.getCurrentDirectory.getPath), ...
                java.io.File.separatorChar];
    selectedfiles = filechooser.getSelectedFiles;
    for k = 1:1:size(selectedfiles)
        filenames(k) = selectedfiles(k).getName;
    end
    filenames = char(filenames);  
else
    pathname = pwd;
    filenames = 0;
end

% End of code