function blkStruct = slblocks

blkStruct.Name = sprintf('UDP Lib');
blkStruct.OpenFcn = 'udplib';
blkStruct.MaskDisplay = 'disp(''UDP-LIB'')';

% Information for Simulink Library Browser
Browser(1).Library = 'udplib';
Browser(1).Name    = 'UDP Lib';
Browser(1).IsFlat  = 1;% Is this library "flat"

blkStruct.Browser = Browser;

