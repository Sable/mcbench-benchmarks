function blkStruct = slblocks

blkStruct.Name = sprintf('DC Motor Library');
blkStruct.OpenFcn = 'dc_motor_lib';
blkStruct.MaskDisplay = 'disp(''DC Motor Library'')';

% Information for Simulink Library Browser
Browser(1).Library = 'dc_motor_lib';
Browser(1).Name    = 'DC Motor Library';
Browser(1).IsFlat  = 1;% Is this library "flat"

blkStruct.Browser = Browser;

