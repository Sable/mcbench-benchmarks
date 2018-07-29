function FIGURE_CloseRequestFcn(handles)
% Callback for the GUI figure closing function

% Copyright 2010 The MathWorks, Inc.
%
% Auth/Revision:
%   The MathWorks Consulting Group
%   $Author: rjackey $
%   $Revision: 241 $  $Date: 2010-01-26 15:17:00 -0500 (Tue, 26 Jan 2010) $
% -------------------------------------------------------------------------

%Get the handle to the main GUI
hFigure = handles.MainFig;

%Allow the GUI's uiwait to stop waiting
uiresume(hFigure);

%end of FIGURE_CloseRequestFcn()