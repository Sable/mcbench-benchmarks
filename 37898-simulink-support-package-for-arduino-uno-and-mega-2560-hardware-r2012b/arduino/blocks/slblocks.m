function blkStruct = slblocks
% SLBLOCKS Defines the block library for Arduino

%   Copyright 2012 The MathWorks, Inc.

blkStruct.Name = sprintf('Arduino');
blkStruct.OpenFcn = 'arduinolib';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = 'disp(''Arduino'')';

Browser(1).Library = 'arduinolib';
Browser(1).Name    = sprintf('Target for Use with Arduino Hardware');
Browser(1).IsFlat  = 0; % Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;  

% Define information for model updater
blkStruct.ModelUpdaterMethods.fhSeparatedChecks = @ecblksUpdateModel;
 
% LocalWords:  Uno arduinolib
