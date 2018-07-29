function ASAversionbkup(funct_name)
%ASAVERSIONBKUP Version-tagged function backup
%   ASAVERSIONBKUP(FUNCTION) copies a m-file FUNCTION, that is provided 
%   with an ARMASA version identifier, into a directory 'Backup' and 
%   renames the file by appending the version identifier (that has been 
%   numerically converted) to its name. For more details about the 
%   numeric conversion, see ASAVERSION2NUMSTR. FUNCTION must be a 
%   character string, containing the name of the m-file to backup. The 
%   directory 'Backup' must be located in the directory where the m-file 
%   resides, or otherwise it is created.
%   
%   See also: ASAVERSION2NUMSTR

[funct_root,funct_name,funct_ext]=fileparts(which(funct_name));
ASAcontrol.run=0;
ASAcontrol.version_chk=0;
ASAcontrol=feval(funct_name,ASAcontrol);
funct_version=ASAversion2numstr(ASAcontrol.is_version);
bkup_name=[funct_name '_' strrep(funct_version,'.','_')];
if ~exist([funct_root filesep 'Backup'],'dir')
   mkdir(funct_root,'Backup');
end
copyfile([funct_root filesep funct_name funct_ext], ...
   [funct_root filesep 'Backup' filesep bkup_name funct_ext]);

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl