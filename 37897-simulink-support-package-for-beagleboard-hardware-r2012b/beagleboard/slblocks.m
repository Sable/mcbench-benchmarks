function blkStruct = slblocks
% SLBLOCKS Defines the block library for BeagleBoard

%   Copyright 2011 The MathWorks, Inc.

blkStruct.Name = sprintf('BeagleBoard');
blkStruct.OpenFcn = 'beagleboardlib';
blkStruct.MaskInitialization = '';
blkStruct.MaskDisplay = 'disp(''BeagleBoard'')';

Browser(1).Library = 'beagleboardlib';
Browser(1).Name    = sprintf('Target for Use with BeagleBoard Hardware');
Browser(1).IsFlat  = 0; % Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;  

% Define information for model updater
blkStruct.ModelUpdaterMethods.fhSeparatedChecks = @ecblksUpdateModel;
 
