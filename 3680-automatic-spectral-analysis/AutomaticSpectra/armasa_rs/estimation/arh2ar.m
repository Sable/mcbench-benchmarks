function [ar,ASAsellog,ASAcontrol] = arh2ar(varargin)

%ARH2AR AR model identification
%   [AR,SELLOG] = ARH2AR(ARH,N_OBS) calculates autoregressive models  
%   of various model orders from the high-order AR model ARH and selects
%   a model with optimal predictive qualities. ARH has been estimated
%   from N_OBS observations. The selected model is returned in the
%   parameter vector AR. The structure SELLOG provides additional
%   information on the selection process.
%   
%   N_OBS can also be a vector containing the lengths of segments of data.
%
%   ARH2AR is an ARMASA_RS main function.
%   
%   See also: SIG2AR, ARH2MA, ARH2ARMA, ARMASEL_RS, DATA_SEGMENTS.
   
%   References: P. M. T. Broersen, Facts and Fiction in Spectral
%               Analysis, IEEE Transactions on Instrumentation and
%               Measurement, Vol. 49, No. 4, August 2000, pp. 766-772.

%Header
%=============================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
[ar_rs,n_obs,cand_order,ASAcontrol] = ASAarg(varargin, ...
{'ar_rs'       ;'n_obs'        ;'cand_order';'ASAcontrol'}, ...
{'isnumeric'   ;'isnumeric'    ;'isnumeric' ;'isstruct'  }, ...
{'ar_rs'       ;'n_obs'                                  }, ...
{'ar_rs'       ;'n_obs'        ;'cand_order'             });

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
ASAcontrol.req_version.cic_s = [2000 12 30 20 0 0];
ASAcontrol.req_version.rc2arset = [2000 12 30 20 0 0];

%Checks
%------

if ~isfield(ASAcontrol,'error_chk') | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(ar_rs)
      error(ASAerr(11,'ar_rs'))
   elseif ~isvector(ar_rs)
      error([ASAerr(14) ASAerr(15,'ar_rs')])
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
   if ~isreal(ar_rs)
      error(ASAerr(13))
   end
   if max(cand_order) > length(ar_rs)-1
      error(ASAerr(21))
   end
end

if ~isfield(ASAcontrol,'version_chk') | ASAcontrol.version_chk
      %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
   
   %Make sure the requested versions of the called
   %functions comply with their actual versions
   cic_s(ASAcontrol);
   rc2arset(ASAcontrol);
end

if ~isfield(ASAcontrol,'run') | ASAcontrol.run
   ASAcontrol.run = 1;
   ASAcontrol.error_chk = 0;
   ASAtime = clock;
   ASAdate = now;
end

if ASAcontrol.run %Run the computational kernel   
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;

%Main   
%=====================================================
  
%Initialization of variables
%---------------------------

%Determine the size of the reduced statistic
n_red_stat = length(ar_rs)-1;
var = 1;   %Normalized variance

%Determination of the maximum candidate AR order
%-----------------------------------------------

if ~isempty(cand_order)
   max_order = cand_order(end);
else
   max_order = n_red_stat;
   cand_order = 0:max_order;
end

[dummy,rc] = ar2arset(ar_rs);
var = 1;   %Normalized variance

%AR model order selection
%------------------------

%Use the estimated reflectioncoefficients and the
%signal variance estimate to determine the residual
%variance estimates as a function of the model order
res = var*[1 cumprod(1-rc(2:end).^2)];

%Determine the CIC selection criterion
[cic,pe_est] = cic_s(res,n_obs,cand_order,ASAcontrol);

%The order to be selected corresponds to the location
%where CIC has its minimum value
[min_value,sel_location] = min(cic);
sel_order = cand_order(sel_location);

%Arranging output arguments
%--------------------------

%Computation of the parameters from the
%reflectioncoefficients using the parameter relations
%in the Levinson Durbin recursion
rc(1)=1;
ar = rc2arset(rc(1:sel_order+1),ASAcontrol);

%Assign reflectioncoefficients and selected model
%parameters to ASAglob variables, in order to make
%them available for other ARMASA functions
ASAglob_rc = rc;
ASAglob_ar = ar;

%Generate a structure variable ASAsellog to report
%the selection process
ASAsellog.funct_name = mfilename;
ASAsellog.funct_version = ASAcontrol.is_version;
ASAsellog.date_time = ...
   [datestr(ASAdate,8) 32 datestr(ASAdate,0)];
ASAsellog.comp_time = etime(clock,ASAtime);
ASAsellog.ar = ar;
ASAsellog.mean_adj = ASAglob_mean_adj;
ASAsellog.cand_order = cand_order;
ASAsellog.cic = cic;
ASAsellog.pe_est = pe_est;
ASAsellog.rc = rc;
ASAsellog.ar_stack = rc2arset(rc,cand_order)';

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
% former versions        P.M.T. Broersen        broersen@tn.tudelft.nl
% [2000 11  1 12 0 0]    W. Wunderink           wwunderink01@freeler.nl
% [2000 12 30 20 0 0]         ,,                          ,,
%                        S. de Waele            stijn.de.waele@philips.com
