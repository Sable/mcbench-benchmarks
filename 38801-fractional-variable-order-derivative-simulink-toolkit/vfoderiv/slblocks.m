function blkStruct = slblocks
%SLBLOCKS Defines the block library for a specific Toolbox or Blockset.

% Mark Beale, 11-31-97
% Copyright 1992-2002 The MathWorks, Inc.
% $Revision: 1.12 $

blkStruct.Name = sprintf('voderiv');
blkStruct.OpenFcn = '';
blkStruct.IsFlat  = 0;% Is this library "flat" (i.e. no subsystems)?

% blkStruct.MaskDisplay = '';

Browser(1).Library = 'voderiv';
Browser(1).Name    = 'Fractional Variable Order Derivative Toolkit';
Browser(1).IsFlat  = 1;

blkStruct.Browser = Browser;