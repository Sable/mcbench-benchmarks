function ASAvar=ASAglobretr(ASAglob_var)
%ASAGLOBRETR ASAglob variable retrieval 
%   VAR = ASAGLOBRETR(ASAGLOB_VAR) retrieves the contents of a global 
%   ASAglob variable ASAGLOB_VAR that resides in memory. ASAGLOB_VAR must 
%   be a character string containing the name of the ASAglob variable. If 
%   ASAGLOB_VAR doesn't exist, it returns an empty array.
%   
%   See also: ASAGLOB

if ~ischar(ASAglob_var)
   error(ASAerr(40,'ASAglob_var'))
end

eval(['global ' ASAglob_var]);
if eval(['isempty(' ASAglob_var ')'])
   eval(['clear global ' ASAglob_var]);
   ASAvar = [];
else
   eval(['ASAvar =' ASAglob_var ';']); 
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl