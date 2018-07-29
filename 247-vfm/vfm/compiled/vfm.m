function varargout = vfm(varargin)
% VFM  Perform frame grabbing from any Video for Windows source
% The function wraps a number of sub-functions. These are parameterised
% in the first paramter. Invocation of a sub-function, say 'grab', 
% is of the form:
%	vfw('grab', ...parameters...)
% 
% VFM('grab'?,	framecount?)
%	Grabs framecount frames. framecount defaults to 1
%	Returns M x N x 3 x framecount array of uint8, where M and N are the 
%	height and width respectively. Images are in RGB format.
%
% VFM('preview'?, bPreview?)
%	Switches preview mode on or off, according to the boolean value bPreview.
%	bPreview defaults to 1.
%
% VFM('show'?, bShow?)
%	Shows or hides the capture window according to the value of the boolean, bShow.
%	The window is displayed if and only if bShow is 1. bShow defaults to 1.
%
% VFM('configsource')
%	Displays the source configuration dialog, if available for the current driver.
%
% VFM('configformat')
%	Displays the format configuration dialog, if available for the current driver.
%
% VFM('configdisplay')
%	Displays the display configuration dialog, if available for the current driver.
%
% VFM('drivername', index)
%	Returns the name of a system driver for the given index. index must be in the 
%	the range 1-10. If a driver exists for that index, a string, representing the 
%	name of the driver is returned.
%
% VFM('setdriver', index)
%	Sets the driver according to the index. index must be in the range 1-10. If
%	a driver does not exist for the given index, a warning is issued.
%
%   Farzad Pezeshkpour, 
%	 School of Information Systems,
%	 University of East Anglia
%   Revision: 0.1   Date: 1998/12/16
error('Missing MEX-file VFM.DLL');