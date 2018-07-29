function [ar,ASAsellog,ASAcontrol] = sig2ar(sig,cand_order,last)
%SIG2AR AR model identification
%   [AR,SELLOG] = SIG2AR(SIG) estimates autoregressive models from the 
%   data vector SIG and selects a model with optimal predictive 
%   qualities. The selected model is returned in the parameter vector AR. 
%   The structure SELLOG provides additional information on the selection 
%   process.
%   
%   SIG2AR(SIG,CAND_ORDER) selects only from candidate models whose 
%   orders are entered in CAND_ORDER. CAND_ORDER must either be a row of 
%   ascending orders, or a single order (in which case no true order 
%   selection is performed).
%   
%   Without user intervention, the mean of SIG is subtracted from the 
%   data. To control the subtraction of the mean, see the help topics on 
%   ASAGLOB_SUBTR_MEAN and ASAGLOB_MEAN_ADJ.
%     
%   SIG2AR is an ARMASA main function.
%   
%   See also: SIG2MA, SIG2ARMA, ARMASEL.

%   References: P. M. T. Broersen, Facts and Fiction in Spectral
%               Analysis, IEEE Transactions on Instrumentation and
%               Measurement, Vol. 49, No. 4, August 2000, pp. 766-772.

%Header
%=========================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(sig,'struct'), ASAcontrol=sig; sig=[];
   else, ASAcontrol=[];
   end
   cand_order=[];
case 2 
   if isa(cand_order,'struct'), ASAcontrol=cand_order; cand_order=[]; 
   else, ASAcontrol=[]; 
   end
case 3 
   if isa(last,'struct'), ASAcontrol=last;
   else, error(ASAerr(39))
   end
otherwise
   error(ASAerr(1,mfilename))
end

if isequal(nargin,1) & ~isempty(ASAcontrol)
      %ASAcontrol is the only input argument
   ASAcontrol.error_chk = 0;
   ASAcontrol.run = 0;
end

%Declare ASAglob variables 
ASAglob = {'ASAglob_subtr_mean';'ASAglob_mean_adj'; ...
      'ASAglob_rc';'ASAglob_ar'};

%Assign values to ASAglob variables by screening the
%caller workspace
for ASAcounter = 1:length(ASAglob)
   ASAvar = ASAglob{ASAcounter};
   eval(['global ' ASAvar]);
   if evalin('caller',['exist(''' ASAvar ''',''var'')'])
      eval([ASAvar '=evalin(''caller'',ASAvar);']);
   else
      eval([ASAvar '=[];']);
   end
end

%ARMASA-function version information
%-----------------------------------

%This ARMASA-function is characterized by
%its current version,
ASAcontrol.is_version = [2000 12 30 20 0 0];
%and its compatability with versions down to,
ASAcontrol.comp_version = [2000 12 30 20 0 0];

%This function calls other functions of the ARMASA
%toolbox. The versions of these other functions must
%be greater than or equal to:
ASAcontrol.req_version.burg = [2000 12 30 20 0 0];
ASAcontrol.req_version.cic = [2000 12 30 20 0 0];
ASAcontrol.req_version.rc2arset = [2000 12 30 20 0 0];

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(sig)
      error(ASAerr(11,'sig'))
   elseif ~isavector(sig)
      error([ASAerr(14) ASAerr(15,'sig')])
   elseif size(sig,2)>1
      sig = sig(:);
      warning(ASAwarn(25,{'row';'sig';'column'},ASAcontrol))
   end
   if ~isempty(cand_order)
      if ~isnum(cand_order) | ~isintvector(cand_order) |...
            cand_order(1)<0 | ~isascending(cand_order)
         error(ASAerr(12,{'candidate';'cand_order'}))
      elseif size(cand_order,1)>1
         cand_order = cand_order';
         warning(ASAwarn(25,{'column';'cand_order';'row'},ASAcontrol))
      end
   end
   
   %Input argument value checks
   if ~isreal(sig)
      error(ASAerr(13))
   end
   if max(cand_order) > length(sig)-1
      error(ASAerr(21))
   end
end

if ~any(strcmp(fieldnames(ASAcontrol),'version_chk')) | ASAcontrol.version_chk
      %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
   
   %Make sure the requested versions of the called
   %functions comply with their actual versions
   burg(ASAcontrol);
   cic(ASAcontrol);
   rc2arset(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
      %Run the computational kernel
   ASAcontrol.run = 1;
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;
   ASAtime = clock;
   ASAdate = now;

%Main   
%=====================================================
  
%Initialization of variables
%---------------------------

if isempty(ASAglob_subtr_mean) | ASAglob_subtr_mean
   sig = sig-mean(sig);
   if isempty(ASAglob_mean_adj)
      ASAglob_mean_adj = 1;
   end
elseif isempty(ASAglob_mean_adj)
   ASAglob_mean_adj = 0;
end

n_obs = size(sig,1);

%Determination of the maximum candidate AR order
%-----------------------------------------------

if ~isempty(cand_order)
   max_order = cand_order(end);
else
   max_order = ...
      min(fix(n_obs/2),fix(200*log10(n_obs)));
   if max_order > 1000; 
      max_order = 1000;
   end
end

%Estimation procedure
%--------------------

[rc,var] = burg(sig,max_order,ASAcontrol);

%AR model order selection
%------------------------

rc(1) = 0;
res = var*cumprod(1-rc.^2);
rc(1) = 1;
[cicar,pe_est] = cic(res,n_obs,cand_order,ASAcontrol);
[min_value,sel_location] = min(cicar);
if isempty(cand_order)
   cand_order = 0:max_order;
end
sel_order = cand_order(sel_location);

%Arranging output arguments
%--------------------------

ar = rc2arset(rc(1:sel_order+1),ASAcontrol);

ASAglob_rc = rc;
ASAglob_ar = ar;

if nargout>1
   ASAsellog.funct_name = mfilename;
   ASAsellog.funct_version = ASAcontrol.is_version;
   ASAsellog.date_time = ...
      [datestr(ASAdate,8) 32 datestr(ASAdate,0)];
   ASAsellog.comp_time = etime(clock,ASAtime);
   ASAsellog.ar = ar;
   ASAsellog.rcarlong = rc;
   ASAsellog.mean_adj = ASAglob_mean_adj;
   ASAsellog.cand_order = cand_order;
   ASAsellog.cic = cicar;
   ASAsellog.pe_est = pe_est;
end

%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   ar = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% former versions        P.M.T. Broersen        p.m.t.broersen@tudelft.nl
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl
