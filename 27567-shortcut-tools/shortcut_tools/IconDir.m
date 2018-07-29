function iconDir = IconDir()
%ICONDIR Returns a path to the directory containing icons.
% 
% ICONDIR = ICONDIR() returns a path to the directory containing icons.
% 
% Examples: 
% 
% web(fullfile(IconDir, 'error.png'));
% 
% See also: List related files here

% $Author: rcotton $	$Date: 2010/10/01 13:58:56 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

iconDir = fullfile( ...
   matlabroot, ...
   'toolbox', ...
   'shared', ...
   'dastudio', ...
   'resources');

end
