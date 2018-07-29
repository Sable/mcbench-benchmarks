function blkStruct = slblocks

%
% Name of the subsystem which will show up in the Simulink Blocksets
% and Toolboxes subsystem.
%
blkStruct.Name = ['Self-Tuning Controllers Simulink Library - Standard'];

%
% The function that will be called when the user double-clicks on
% this icon.
%	
blkStruct.OpenFcn = '';

%
% The argument to be set as the Mask Display for the subsystem.  You
% may comment this line out if no specific mask is desired.
% Example:  blkStruct.MaskDisplay = 'plot([0:2*pi],sin([0:2*pi]));';
% No display for Simulink Extras.
%
blkStruct.MaskDisplay = '';

%
% Define the Browser structure array, the first element contains the
% information for the Simulink block library and the second for the
% Simulink Extras block library.
%
Browser(1).Library = 'stcsl_std';
Browser(1).Name    = 'STCSL standard';
Browser(1).IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;

% End of slblocks


