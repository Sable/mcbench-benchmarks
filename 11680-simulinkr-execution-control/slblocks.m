% ===================================================================
%
% Copyright (C) 2005 The MathWorks, Inc. All rights reserved.
%
% Written By Roger Aarenstrup 2005-01-03
%
% For questions, suggestions or bug reports contact:
%
%   roger.aarenstrup@mathworks.com
%
function blkStruct = slblocks

blkStruct.Name = sprintf('Simulink Execution Control');
blkStruct.OpenFcn = 'SimulinkExecutionControl';
blkStruct.MaskDisplay = 'disp(''Simulink Execution Control'')';

% Information for Simulink Library Browser
Browser(1).Library = 'SimulinkExecutionControl';
Browser(1).Name    = 'Simulink Execution Control';
Browser(1).IsFlat  = 1;% Is this library "flat"

blkStruct.Browser = Browser;

