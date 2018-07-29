function blkStruct = slblocks
%SLBLOCKS Define the Simulink library block representation.
%
%    Define the Simulink library block representation for the Testing

%    CP 10-11-05
%    Copyright 2005-2006, Fraunhofer FOKUS 
%    $Revision: 1.0.0.0 $  $Date: 2005/11/10 20:11:50 $
%    $Revision: 1.0.0.0 $  $Date: 2006/07/10 20:11:50 $
 
blkStruct.Name    = 'MIL Test Blockset';
% The function that is called when
% the user double-clicks on this icon.
blkStruct.OpenFcn = 'MIL_Test';
blkStruct.MaskInitialization = '';

% Define the library list for the Simulink Library browser.
% Return the name of the library model and the name for it
Browser(1).Library = 'MIL_Test';
Browser(1).Name    = 'MIL Test Blockset';
%Browser(1).IsFlat  = 1;% Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;


% End of slblocks.m