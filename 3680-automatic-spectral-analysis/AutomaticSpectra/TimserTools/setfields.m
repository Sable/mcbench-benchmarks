function struc_out = setfields(struc_in,varargin)

%function struc_out = setfields(struc_in,checkfields,varargin)
%
%It is checked whether fieldnames exist in struc_in. If not, an error
%message is produced.
%
%See also: SETFIELD.

%S. de Waele, August 2001.

struc_out = struc_in;
nvar = length(varargin);
if ~iseven(nvar) | ~nvar
   error('Input should be ''fieldname'',value,...')
end
%Check fields for existance
for t = 1:2:nvar,
    if ~isfield(struc_out,varargin{t}),
        error(['Name or case setting in field ''' varargin{t} ''' is incorrect.'])
    end
end
%Set fields
for t = 1:2:nvar,
	struc_out = setfield(struc_out,varargin{t},varargin{t+1});
end