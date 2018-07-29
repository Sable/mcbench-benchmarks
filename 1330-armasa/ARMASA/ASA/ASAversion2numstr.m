function string = ASAversion2numstr(version)
%ASAVERSION2NUMSTR Version identifier to number as string type
%   NUMSTRING = ASAVERSION2NUMSTR(VERSION) converts a numeric ARMASA 
%   version identifier into a character string NUMSTRING containing a 
%   numeric conversion of the version identifier.
%   
%   ARMASA function version identifiers are implemented as date vectors 
%   according to the Matlab format, see DATEVEC. Each date vector can be 
%   associated with an equivalent serial date number, see DATENUM. 
%   ASAVERSION2NUMSTR accepts both numeric formats and converts them into 
%   the alternative numeric format which is subsequently converted into a 
%   character string. 
%   
%   Example:
%   
%   This function can be used to quickly generate a version identifier 
%   for an ARMASA main function that has just been created or modified. 
%   Typing,
%   
%     ASAversion2numstr(now)
%   
%   returns the current date and time in a date vector string that can 
%   directly be pasted at the appropriate location in the ARMASA function 
%   m-file.
%   
%   See also: ASACONTROL, ASAVERSIONCHK, DATENUM, DATESTR, DATEVEC, NOW.

if ~isnumeric(version) |  ~(isequal(length(version),6) | isequal(length(version),1))
   error(ASAerr(10,{'version';mfilename}))
end

if isequal(length(version),6)
   v = version;
   string = sprintf('%0.5f',datenum(v(1),v(2),v(3),v(4),v(5),v(6)));
else
   string = sprintf('%0.0f %0.0f %0.0f %0.0f %0.0f %0.0f',datevec(version));
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl