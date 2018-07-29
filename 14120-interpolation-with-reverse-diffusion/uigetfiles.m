% UIGETFILES:   Multiple file open dialog box.
%   [FILENAMES, PATHNAME] = UIGETFILES('filterSpec', 'dialogTitle')
%   displays a dialog box for the user to fill in, and returns the
%   filenames as a cell array and the path as a string.  A successful 
%   return occurs only if the files exist.  If the user selects a 
%   file that does not exist, an error message is displayed, and control
%   returns to the dialog box. The user may then enter other filenames, 
%   or press the Cancel button. 
%
%   The filterSpec parameter determines the initial display of files in 
%   the dialog box.  For example '*.m' lists all the MATLAB M-files. Specifying
%   multiple filters can be done as in: '*.m ; *.mat'. 
%
%   Parameter 'dialogTitle' is a string containing the title of the dialog
%   box.
%
%   The output variable FILENAME is a cell array containing strings that are 
%   the names of the files selected in the dialog box.  If the user presses 
%   the Cancel button or if any error occurs, it is set to an empty cell array.
%
%   The output parameter PATHNAME is a string containing the path of
%   the file selected in the dialog box.  If the user presses the Cancel
%   button or if any error occurs, it is set to 0.
%
%   See also UIGETFILE and UIPUTFILE.

%  %   Dynamic Link Library for Windows 95/NT

% written by David J. Warren, Dept. of Bioengineering, University of Utah