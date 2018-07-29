function ASAversionchk(ASAcontrol)
%ASAVERSIONCHK Function version check
%   ASAVERSIONCHK(ASACONTROL) checks the compatibility of two functions 
%   according to the information provided in the structure variable 
%   ASACONTROL, if called from within the body of a m-file. If 
%   incompatibility is detected, it halts execution and prints an error 
%   message. 
%   
%   To apply a version check procedure when for example CALLER_FUNCTION 
%   calls CALLED_FUNCTION, the latter must invoke ASAVERSIONCHK. 
%   CALLER_FUNCTION must supply ASACONTROL as the last input argument 
%   when it calls CALLED_FUNCTION. ASACONTROL must contain a (nested) 
%   field named 'req_version.CALLED_FUNCTION' containing a version 
%   identifier that defines the minimum version of CALLED_FUNCTION, as 
%   required by CALLER_FUNCTION to guarantee consistency. In addition, 
%   CALLED_FUNCTION must add two fields to ASACONTROL, named 'is_version' 
%   and 'comp_version' prior to invoking ASAVERSIONCHK. Both fields 
%   containing version identifiers, are used respectively to identify 
%   CALLED_FUNCTION itself, with its own actual version, and to define 
%   its downward compatibility with former versions. Operable version 
%   check implementations can be found in all ARMASA main functions.
%   
%   See also: ASACONTROL, STRUCT

caller_stack = dbstack;
stack_length = length(caller_stack);
if stack_length == 1
   error(ASAerr(7))
else
   [caller_path chk_caller] = fileparts(caller_stack(2).name);
   if stack_length >= 3
      [caller_path funct_caller] = fileparts(caller_stack(3).name);
   end
   if ~any(strcmp(fieldnames(ASAcontrol),'is_version'))|~any(strcmp(fieldnames(ASAcontrol),'comp_version'))
      error(ASAerr(22))
   end
end

if ~any(strcmp(fieldnames(ASAcontrol),'req_version'))
   chk = 0;
elseif ~any(strcmp(fieldnames(ASAcontrol.req_version),chk_caller))
   chk = 0;
else
   chk = 1;
   v = ASAcontrol.is_version;
   formatchk(v,'ASAcontrol.is_version',chk_caller);
   is_version = datenum(v(1),v(2),v(3),v(4),v(5),v(6));
   v = ASAcontrol.comp_version;
   formatchk(v,'ASAcontrol.comp_version',chk_caller);
   comp_version = datenum(v(1),v(2),v(3),v(4),v(5),v(6));
   v = getfield(ASAcontrol.req_version,chk_caller);
   formatchk(v,['ASAcontrol.req_version' chk_caller],chk_caller);  
   req_version = datenum(v(1),v(2),v(3),v(4),v(5),v(6));
end

if isequal(chk,0)
   if stack_length > 2
      show_warn = 0; % <----  User adjustable: show_warn = 1 will enable warning messages
   else
      show_warn = 0;
   end
   if show_warn
      v = ASAcontrol.is_version;
      formatchk(v,'ASAcontrol.is_version',chk_caller);
      string = sprintf('%0.0f %0.0f %0.0f %0.0f %0.0f %0.0f',v);
      warning(ASAwarn(8,...
         {funct_caller;chk_caller;funct_caller;chk_caller;...
            string;chk_caller;funct_caller},ASAcontrol))
   end
elseif req_version > is_version
   if stack_length == 2
      error(ASAerr(3,chk_caller))
   else
      error(ASAerr(4,{chk_caller;funct_caller}))
   end
elseif req_version < comp_version
   if stack_length == 2
      error(ASAerr(5,chk_caller))
   else
      error(ASAerr(6,{chk_caller;funct_caller}))
   end
end

function formatchk(version,name_version,chk_caller)

if ~isnumeric(version) | ~isequal(length(version),6)
   error(ASAerr(10,{name_version;chk_caller}))
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl
