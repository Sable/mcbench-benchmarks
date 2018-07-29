function [me,ASAcontrol] = moderr(ar_est,ma_est,ar_ref,ma_ref,n_obs,ASAcontrol)
%MODERR Model error
%   ME = MODERR(AR_EST,MA_EST,AR_REF,MA_REF,N_OBS) is the model error of 
%   an ARMA model estimated from N_OBS observations, with parameter 
%   vectors AR_EST and MA_EST, applied for modeling a reference process 
%   with ARMA parameters AR_REF and MA_REF. It is a measure for the 
%   accuracy of the estimated model. The lower the model error, the 
%   better is the model accuracy. For estimated models, its asymptotic 
%   minimum value equals the AR-order plus the MA-order of the reference 
%   process.
%   
%   MODERR is an ARMASA main function.

%   References: P. M. T. Broersen, The Quality of Models for ARMA
%               Processes, IEEE Transactions on Signal Processing,
%               Vol. 46, No. 6,, June 1998, pp. 1749-1752.

%Header
%=============================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(ar_est,'struct'), ASAcontrol=ar_est; ar_est=[]; 
   else, error(ASAerr(39))
   end
   ma_est=[]; ar_ref=[]; ma_ref=[]; n_obs=[];
case 5 
   if isa(n_obs,'struct'), error(ASAerr(2,mfilename)) 
   end
   ASAcontrol=[];
case 6
   if ~isa(ASAcontrol,'struct'), error(ASAerr(39))
   end
otherwise
   error(ASAerr(1,mfilename))
end

if isequal(nargin,1) & ~isempty(ASAcontrol)
      %ASAcontrol is the only input argument
   ASAcontrol.error_chk = 0;
   ASAcontrol.run = 0;
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
ASAcontrol.req_version.convol = [2000 12 6 12 17 20];
ASAcontrol.req_version.arma2cor = [2000 12 30 20 0 0];

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(ar_est)
      error(ASAerr(11,'ar_est'))
   elseif ~isavector(ar_est)
      error(ASAerr(15,'ar_est'))
   elseif size(ar_est,1)>1
      ar_est = ar_est';
      warning(ASAwarn(25,{'column';'ar_est';'row'},ASAcontrol))         
   end
   if ~isnum(ma_est)
      error(ASAerr(11,'ma_est'))
   elseif ~isavector(ma_est)
      error(ASAerr(15,'ma_est'))
   elseif size(ma_est,1)>1
      ma_est = ma_est';
      warning(ASAwarn(25,{'column';'ma_est';'row'},ASAcontrol))         
   end
      if ~isnum(ar_ref)
      error(ASAerr(11,'ar_ref'))
   elseif ~isavector(ar_ref)
      error(ASAerr(15,'ar_ref'))
   elseif size(ar_ref,1)>1
      ar_ref = ar_ref';
      warning(ASAwarn(25,{'column';'ar_ref';'row'},ASAcontrol))         
   end
   if ~isnum(ma_ref)
      error(ASAerr(11,'ma_ref'))
   elseif ~isavector(ma_ref)
      error(ASAerr(15,'ma_ref'))
   elseif size(ma_ref,1)>1
      ma_ref = ma_ref';
      warning(ASAwarn(25,{'column';'ma_ref';'row'},ASAcontrol))         
   end
   if ~isnum(n_obs) | ~isintscalar(n_obs)
      error(ASAerr(17,'n_obs'))
   end

   %Input argument value checks
   if ~(isreal(ar_est) & isreal(ma_est) & ...
         isreal(ar_ref) & isreal(ma_ref))
      error(ASAerr(13))
   end
   if ar_est(1)~=1
      error(ASAerr(23,{'ar_est','parameter'}))
   end
   if ma_est(1)~=1
      error(ASAerr(23,{'ma_est','parameter'}))
   end
   if ar_ref(1)~=1
      error(ASAerr(23,{'ar_ref','parameter'}))
   end
   if ma_ref(1)~=1
      error(ASAerr(23,{'ma_ref','parameter'}))
   end
   if n_obs<1
      error(ASAerr(41,'n_obs'))
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
   arma2cor(ASAcontrol);
   convol(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
      %Run the computational kernel
   ASAcontrol.run = 1;
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;

%Main   
%=====================================================

%Determine the model error by evaluating the power
%gain of a modified ARMA model
[cor,gain] = arma2cor...
   (convol(ar_ref,ma_est,ASAcontrol),...
    convol(ar_est,ma_ref,ASAcontrol),0,ASAcontrol);
me = n_obs*(gain-1);
 
%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   me = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% former versions        P.M.T. Broersen        p.m.t.broersen@tudelft.nl
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl
