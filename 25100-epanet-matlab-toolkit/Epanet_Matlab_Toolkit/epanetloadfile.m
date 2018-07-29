function [errorcode] = epanetloadfile(wdsfile)
%EPANETLOADFILE - Loads the dll library and the network INP file.
%
% Syntax:  [errorcode] = epanetloadfile(wdsfile)
%
% Inputs:
%    wdsfile - A string, name of the INP file
%
% Outputs:
%    errorcode - Fault code according to EPANET.
%
% Example: 
%    [errorcode]=epanetloadfile('Net1.inp')

% Original version
% Author: Philip Jonkergouw
% Email:  pjonkergouw@gmail.com
% Date:   July 2007

% Minor changes by
% Author: Demetrios Eliades
% University of Cyprus, KIOS Research Center for Intelligent Systems and Networks
% email: eldemet@gmail.com
% Website: http://eldemet.wordpress.com
% August 2009; Last revision: 21-August-2009

%------------- BEGIN CODE --------------

% Load the EPANET 2 dynamic link library ...
if ~libisloaded('epanet2') loadlibrary('epanet2', 'epanet2.h'); end


% Open the water distribution system ...
s = which(wdsfile);
if ~isempty(s) wdsfile = s; end

[errorcode] = calllib('epanet2', 'ENopen', wdsfile, 'temp1.$$$', 'temp2.$$$');
if (errorcode)
    fprintf('Could not open network ''%s''.\nReturned empty array.\n', wdsfile);
    return;
else
    fprintf('File ''%s'' opened successfully.\n', wdsfile);
end


%------------- END OF CODE --------------
%Please send suggestions for improvement of the above code 
%to Demetrios Eliades at this email address: eldemet@gmail.com.
