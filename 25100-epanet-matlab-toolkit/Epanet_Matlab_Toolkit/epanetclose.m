function [errorcode] = epanetclose()
%EPANETCLOSE - close the dll library 
%
% Syntax:  [errorcode] = epanetclose()
%
% Inputs:
%    none

% Outputs:
%    errorcode - Fault code according to EPANET.
%
% Example: 
%    [errorcode]=epanetclose()

% Original version
% Author: Philip Jonkergouw
% Email:  pjonkergouw@gmail.com
% Date:   July 2007

%------------- BEGIN CODE --------------


% Close EPANET ...
[errorcode] = calllib('epanet2', 'ENclose');
if (errorcode) fprintf('EPANET error occurred. Code %g\n', num2str(errorcode)); end
if libisloaded('epanet2') unloadlibrary('epanet2'); end