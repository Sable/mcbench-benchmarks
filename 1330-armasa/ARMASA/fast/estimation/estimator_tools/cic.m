function [cic,pe_est] = cic(res,n_obs,cand_order,last)
%CIC Finite sample order selection criterion
%   C = CIC(RES,N_OBS) is a transformation of the vector of estimated 
%   residualvariances RES, obtained from a recursive-in-order AR 
%   estimation procedure (Burg type assumed), applied to a signal segment 
%   of N_OBS observations. RES must contain all residual variance 
%   estimates, corresponding to orders 0 up to a maximum order of 
%   estimation. In this case, the location of the minimum of the 
%   criterion function CIC in vector C is the optimal order plus 1.
%   For example, if [DUMMY,LOCATION] = MIN(CIC(RES,N_OBS)), then 
%   SEL_ORDER = LOCATION-1.
%   
%   C = CIC(RES,N_OBS,CAND_ORDER) evaluates the criterion function at 
%   candidate orders CAND_ORDER only, and fills C with these values. 
%   CAND_ORDER must be either a row of ascending orders, or a single 
%   order.
%   
%   CIC is an ARMASA main function.
%   
%   See also: SIG2AR

%   References: P. M. T. Broersen, Facts and Fiction in Spectral
%               Analysis, IEEE Transactions on Instrumentation and
%               Measurement, Vol. 49, No. 4, pp. 766-772, August 2000,
%               section V.
%               P. M. T. Broersen and H. E. Wensink, On the Penalty
%               Factor for Autoregressive Order Selection in Finite
%               Samples, IEEE Transactions on Signal Processing, Vol. 44,
%               1996, pp. 748-752.
%               P. M. T. Broersen, Autoregressive Model Order Selection
%               by a Finite Sample Estimator for the Kullback-Leibler
%               Discrepancy, IEEE Transactions on Signal Processing,
%               Vol. 46, No. 7, 1998, pp. 2058-2061.

%Header
%=============================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(res,'struct'), ASAcontrol=res;
   else, error(ASAerr(39))
   end
   res=[]; n_obs=[]; cand_order=[];
case 2 
   if isa(n_obs,'struct'), error(ASAerr(2,mfilename))
   end
   cand_order=[]; ASAcontrol=[];
case 3 
   if isa(cand_order,'struct'), ASAcontrol=cand_order; cand_order=[];
   else, ASAcontrol=[];
   end
case 4
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
ASAglob = {'ASAglob_mean_adj','ASAglob_ar_est_method'};

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

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(res)
      error(ASAerr(11,'res'))
   end
   if ~isnum(n_obs) | ~isintscalar(n_obs) | n_obs<0
      error(ASAerr(17,'n_obs'))
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
   if ~isreal(res)
      error(ASAerr(13))
   end
   if ~isavector(res)
      error(ASAerr(15,'res'))
   end
   if max(cand_order) > length(res)-1
      error(ASAerr(27,{'cand_order';'res'}))
   end
   if length(res) > n_obs
      error(ASAerr(26,{'res';'n_obs'}))
   end
end

if ~any(strcmp(fieldnames(ASAcontrol),'version_chk')) | ASAcontrol.version_chk
      %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
      %Run the computational kernel
   ASAcontrol.run = 1;

%Main   
%=====================================================
  
%Initialization of variables
%---------------------------

s_res = size(res);
if s_res(1)>1
   res = res';
end

%Determination of the order selection criterion
%----------------------------------------------

if isempty(ASAglob_ar_est_method)
   ASAglob_ar_est_method = 'burg';
end
est_method = ASAglob_ar_est_method;

if isempty(cand_order)
   max_order = length(res)-1;
else
   max_order = cand_order(end);
   res = res(1:max_order+1);
end
i = 0:max_order;
i(1) = 1;
switch lower(est_method)
case 'burg'
   vi = 1./((n_obs+1)-i);
otherwise
   error(['Estimation method ''' est_method ...
         ''' not supported']);
end
if ~ASAglob_mean_adj
   vi(1) = 0;
end

fic_tail = 3*cumsum(vi);
fsic_tail = cumprod((1+vi)./(1-vi))-1;
cic_tail = max(fic_tail,fsic_tail);
cic = log(res)+cic_tail;
pe_est = res.*(fsic_tail+1);

%Arranging output arguments
%--------------------------

if ~isempty(cand_order)
   cic = cic(cand_order+1);
   pe_est = pe_est(cand_order+1);
end

if s_res(1)>1
   cic = cic';
   pe_est = pe_est';
end

%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   cic = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% former versions        P.M.T. Broersen        p.m.t.broersen@tudelft.nl
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl
