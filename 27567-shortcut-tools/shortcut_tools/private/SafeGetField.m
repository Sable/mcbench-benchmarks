function field = SafeGetField(str, fieldname, default, warn)
%SAFEGETFIELD A safe wrapper to GETFIELD.
% 
% FIELD = SAFEGETFIELD(STR, FIELDNAME) is a wrapper to GETFIELD that
% returns an empty matrix (with a warning) rather than an error if the
% field is not found.
% 
% FIELD = SAFEGETFIELD(STR, FIELDNAME, DEFAULT) works as above but
% returns the value DEFAULT instead of [] when the field is not found.
% 
% FIELD = SAFEGETFIELD(STR, FIELDNAME, DEFAULT, 0) works as above, but
% does not give a warning.
% 
% Examples: 
% 
% x.a = 1;
% SafeGetField(x, 'b')
% 
% See also: getfield

% $Author: rcotton $	$Date: 2010/10/01 13:58:35 $	$Revision: 1.1 $
% Copyright: Health and Safety Laboratory 2010

SetDefaultValue(3, 'default', []);
SetDefaultValue(4, 'warn', true);

if hasfield(str, fieldname)
   field = getfield(str, fieldname);    %#ok<GFLD>
else
   if warn
      warning('SafeGetField:NonExistentField', ...
         ['The field ''' fieldname ''' does not exist.']);
   end
   field = default;
end

end

function yn = hasfield(str, fieldname)
   yn = any(strcmp(fieldname, fieldnames(str)));
end

