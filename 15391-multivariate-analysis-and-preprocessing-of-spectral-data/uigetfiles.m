% UIGETFILES   Multiple file open dialog box.
%   [FILENAMES, PATHNAME] = UIGETFILES(FILTERSPEC,DIALOGTITLE)
%   displays a dialog box file browser from which the user can select
%   files.  The selected files are returned to FILENAMES as a cell array of
%   strings.  The directory containing these files is returned to PATHNAME
%   as a string.  FILTERSPEC is a string that determines the initial
%   display of files in the dialog box. For example '*.m' lists all the
%   MATLAB M-files.  Specifying multiple filters can be done as in: '*.m ;
%   *.mat'.  DIALOGTITLE is a string defining the title of the dialog box.
%
%   A successful return occurs only if the files exist.  If the user
%   selects a  file that does not exist, a warning message is displayed to
%   the command line and control returns to the dialog box.  The user may
%   then enter other filenames or use the Cancel button.  If the Cancel
%   button is selected or if an error occurs, an empty cell array is
%   assigned to FILENAMES and a numeric 0 is assigned to PATHNAME.  When an
%   error occurs, a warning message is displayed to the command line.
%
%   [FILENAMES, PATHNAME] = UIGETFILES(FILTERSPEC,DIALOGTITLE,STARTPATH)
%   allows the user to specify the string STARTPATH as the path for the
%   dialog to start from.  If a path is not specified, it uses MATLAB's
%   present working directory (PWD).
%
%   This DLL is for use with Windows operating systems only.
%   
%   See also UIGETFILE and UIPUTFILE.
%   MATLAB 6.5 (R13), See also UIGETDIR.

%   v 1.0
%   8-18-1998
%   First revision written by David J. Warren, Dept. of Bioengineering, University of Utah
%
%   v 1.1
%   10-28-2002 
%   Source maintenance transferred to Greg Aloe, The MathWorks, Inc.
%   Fixed bug where, after using the function, the directory listings (LS and DIR)
%   returned the last accessed directory, rather than the PWD.  However, PWD and 
%   the Current Directory combobox listed the true CWD.
%
%   v 2.0
%   12-24-2002
%   Greg Aloe and John R. Haines
%   added option of a STARTPATH.
%
%   v 2.1
%   12-26-2002
%   Greg Aloe
%   STARTPATH now accepts pathnames the same way MATLAB does.  That is,
%   combinations of path separators, and either backslash or forwardslash
%   are interpreted as a single backslash as required by Windows.
%
%   v 2.2
%   2-26-2003
%   Greg Aloe
%   Fixed type in help, and added note about being for Windows only
