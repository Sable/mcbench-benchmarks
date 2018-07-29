function CloseGUI(handles)
% Close down the GUI, shutting down any services

% Copyright 2010 The MathWorks, Inc.
%
% Auth/Revision:
%   The MathWorks Consulting Group
%   $Author: rjackey $
%   $Revision: 241 $  $Date: 2010-01-26 15:17:00 -0500 (Tue, 26 Jan 2010) $
% -------------------------------------------------------------------------

%Get the handle to the main GUI
hFigure = handles.MainFig;

% Close the figure
delete(hFigure);

%end of CloseGUI()