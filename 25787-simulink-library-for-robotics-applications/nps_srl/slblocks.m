function blkStruct = slblocks
%SLBLOCKS Defines the block library for the NPS SRL Toolbox.

% Name of the subsystem which will show up in the
% Simulink Toolboxes subsystem.
blkStruct.Name = sprintf('NPS\nSRL\nToolbox');

% The function that is called when
% the user double-clicks on this icon.
blkStruct.OpenFcn = 'nps_srllib';

blkStruct.MaskInitialization = '';

%blkStruct.MaskDisplay = 'disp(''NPS\nSRL'')';
blkStruct.MaskDisplay = 'image(imread(''NPSSRLicon.JPG''))';

% Define the library list for the Simulink Library browser.
% Return the name of the library model and its title
Browser(1).Library = 'nps_srllib';
Browser(1).Name    = 'NPS SRL Toolbox';

blkStruct.Browser = Browser;

% define information for model updater
%blkStruct.ModelUpdaterMethods.fhDetermineBrokenLinks = @vrBrokenLinksMapping;

% End of slblocks
