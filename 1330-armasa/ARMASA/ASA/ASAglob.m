%ASAGLOB Variables with a global scope
%   Variables carrying the prefix 'ASAglob_' are implemented in ARMASA 
%   main functions to create the possibility to pass arguments between 
%   functions, not handled by function argument lists. It avoids the use 
%   of inconvenient argument lists, handles function-wide control of 
%   operation modes, and avoids redundant copy operations.
%   
%   Within functions, ASAGLOB variables are implemented as Matlab GLOBAL 
%   variables, combined with a routine that screens the workspace of the 
%   function's caller. When an ASAGLOB variable doesn't exist in the 
%   workspace of the caller function, it is declared empty. This 
%   procedure provides more control on the value of GLOBAL variables. 
%   Ordinarily, variables defined GLOBAL, keep there value, even after a 
%   function's execution has been terminated. By using ASAGLOB variables 
%   within nested functions, a screening at each workspace level is 
%   performed, that updates their values depending on the caller's 
%   workspace. A deliberate choice can be made, whether or not a variable 
%   will be "visible" for a called function. The next time a function is 
%   executed, the value of ASAGLOB variables will be reset, depending on 
%   the value in the caller's workspace. This way it is also possible to 
%   pass a value to all functions that will be called from the base 
%   workspace. This is done by declaring an ASAGLOB variable in the base 
%   workspace, not using the GLOBAL declaration. Avoiding the GLOBAL 
%   declaration in the base workspace, prevents that the value will be 
%   changed undesirably by a called function without notice. Use 
%   ASAGLOBRETR to retrieve the actual contents of the persisting GLOBAL 
%   variant of an ASAGLOB variable, without declaring it GLOBAL in the 
%   base workspace.
%   
%   Example:
%   
%   ASAGLOB variables are typically declared in the header sections of 
%   functions with a standard procedure,
%   
%     ASAglob = {'ASAglob_VAR1';'ASAglob_VAR2'};
%   
%   with for VAR1 and VAR2 appropriate names substituted. Next, the 
%   caller's workspace is screened by,
%   
%     for ASAcounter = 1:length(ASAglob)
%         ASAvar = ASAglob{ASAcounter};
%         eval(['global ' ASAvar]);
%         if evalin('caller',['exist(''' ASAvar ''',''var'')'])
%            eval([ASAvar '=evalin(''caller'',ASAvar);']);
%         else
%            eval([ASAvar '=[];']);
%         end
%     end
%   
%   The variables 'ASAglob_subtr_mean', 'ASAglob_mean_adj' and 
%   'ASAglob_ar_cond' can be of particular interest to users of the 
%   ARMASA estimation functions. This help file does not cover their use. 
%   Instead, see their own help texts.
%   
%   See also: ASAGLOBRETR, ASAGLOB_SUBTR_MEAN, ASAGLOB_MEAN_ADJ,
%             ASAGLOB_AR_COND.

disp('  Using ''ASAglob'' as a script or function is meaningless.')
disp('  Type ''help ASAglob'' instead.')