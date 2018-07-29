function blkStruct = slblocks

blkStruct.Name = sprintf('Model I/O and State Information');
blkStruct.OpenFcn = 'model_info';
blkStruct.MaskDisplay = 'disp(''Model I/O and State Information'')';

% Information for Simulink Library Browser
Browser(1).Library = 'model_info';
Browser(1).Name    = 'Model I/O and State Information';
Browser(1).IsFlat  = 1;% Is this library "flat"

blkStruct.Browser = Browser;

