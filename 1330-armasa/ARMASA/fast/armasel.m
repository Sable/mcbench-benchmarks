function [ar,ma,ASAsellog,ASAcontrol]=armasel(sig,cand_ar_order,cand_ma_order,cand_arma_order,arma_order_diff,last)
%ARMASEL ARMAsel model identification
%   [AR,MA,SELLOG] = ARMASEL(SIG) estimates autoregressive, moving 
%   average, and autoregressive moving average models from the data 
%   vector SIG and selects the model with optimal predictive qualities. 
%   The AR and MA parts of the selected model, each possibly of order 0, 
%   are returned in the parameter vectors AR and MA. The structure SELLOG 
%   provides additional information on the selection process.
%   
%   SELLOG contains the fields 'ar', 'ma' and 'arma', in which SELLOG 
%   structures are nested, as returned by the functions SIG2AR, SIG2MA 
%   and SIG2ARMA, invoked by ARMASEL. In the field 'armasel' a structure 
%   is nested that reports information about the final stage of model 
%   selection, where the preselected AR, MA and ARMA models are compared.
%   
%   ARMASEL(SIG,CAND_AR_ORDER,CAND_MA_ORDER,CAND_ARMA_ORDER,ARMA_ORDER_DIFF)
%   narrows the selection to candidate models with orders provided by the 
%   rows CAND_AR_ORDER, CAND_MA_ORDER, CAND_ARMA_ORDER and the scalar  
%   ARMA_ORDER_DIFF, effecting the selection of AR, MA and ARMA models 
%   independently. For any of these arguments it is allowed to pass an 
%   empty array. Alternatively, additional arguments may be omitted from 
%   the input list. In both cases, default values are automatically 
%   determined and substituted for the missing arguments. The functions 
%   SIG2AR, SIG2MA and SIG2ARMA provide additional information on 
%   defining candidate orders. Note in this respect, that the candidate 
%   AR orders of the ARMA model are called CAND_ARMA_ORDER in this help 
%   text, while in SIG2ARMA they are called CAND_AR_ORDER.
%   
%   The selection of MA and ARMA models can be conditioned to the 
%   selection of AR models from a specific set of candidate orders 
%   CAND_AR_ORDER. See ASAGLOB_AR_COND for more information.
%   
%   Without user intervention, the mean of SIG is subtracted from the 
%   data. To control the subtraction of the mean, see the help topics on 
%   ASAGLOB_SUBTR_MEAN and ASAGLOB_MEAN_ADJ.
%     
%   ARMASEL is an ARMASA main function.
%   
%   See also: SIG2AR, SIG2MA, SIG2ARMA.

%   References: P. M. T. Broersen, Facts and Fiction in Spectral
%               Analysis, IEEE Transactions on Instrumentation and
%               Measurement, Vol. 49, No. 4, August 2000, pp. 766-772.

%Header
%===================================================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(sig,'struct'), ASAcontrol=sig; sig=[]; 
   else, ASAcontrol=[];
   end
   cand_ar_order=[]; cand_ma_order=[]; cand_arma_order=[]; arma_order_diff=[];
case 2 
   if isa(cand_ar_order,'struct'), ASAcontrol=cand_ar_order; cand_ar_order=[]; 
   else, ASAcontrol=[]; 
   end
   cand_ma_order=[]; cand_arma_order=[]; arma_order_diff=[];
case 3 
   if isa(cand_ma_order,'struct'), ASAcontrol=cand_ma_order; cand_ma_order=[]; 
   else, ASAcontrol=[]; 
   end
   cand_arma_order=[]; arma_order_diff=[];
case 4 
   if isa(cand_arma_order,'struct'), ASAcontrol=cand_arma_order; cand_arma_order=[]; 
   else, ASAcontrol=[]; 
   end
   arma_order_diff=[];
case 5 
   if isa(arma_order_diff,'struct'), ASAcontrol=arma_order_diff; arma_order_diff=[]; 
   else, ASAcontrol=[]; 
   end
case 6
   if isa(last,'struct'), ASAcontrol=last;
   else, error(ASAerr(39))
   end
otherwise
   error(ASAerr(1,mfilename))
end

%Declare ASAglob variables 
ASAglob = {'ASAglob_subtr_mean';'ASAglob_mean_adj';'ASAglob_rc';'ASAglob_ar';'ASAglob_final_f'; ...
      'ASAglob_final_b';'ASAglob_ar_cond'};

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
%toolbox. The versions of these other functions
%must be greater than or equal to:
ASAcontrol.req_version.sig2ar = [2000 12 30 20 0 0];
ASAcontrol.req_version.sig2ma = [2000 12 30 20 0 0];
ASAcontrol.req_version.sig2arma = [2000 12 30 20 0 0];

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
   if ~isempty(cand_ar_order)
      if ~isnum(cand_ar_order) | ~isintvector(cand_ar_order) |...
            cand_ar_order(1)<0 | ~isascending(cand_ar_order)
         error(ASAerr(12,{'candidate';'cand_ar_order'}))
      elseif size(cand_ar_order,1)>1
         cand_ar_order = cand_ar_order';
         warning(ASAwarn(25,{'column';'cand_ar_order';'row'},ASAcontrol))
      end
   end
   if ~isempty(cand_ma_order)
      if ~isnum(cand_ma_order) | ~isintvector(cand_ma_order) |...
            cand_ma_order(1)<0 | ~isascending(cand_ma_order)
         error(ASAerr(12,{'candidate';'cand_ma_order'}))
      elseif size(cand_ma_order,1)>1
         cand_ma_order = cand_ma_order';
         warning(ASAwarn(25,{'column';'cand_ma_order';'row'},ASAcontrol))
      end
   end
   if ~isempty(cand_arma_order)
      if ~isnum(cand_arma_order) | ~isintvector(cand_arma_order) |...
            cand_arma_order(1)<0 | ~isascending(cand_arma_order)
         error(ASAerr(12,{'candidate';'cand_arma_order'}))
      elseif size(cand_arma_order,1)>1
         cand_arma_order = cand_arma_order';
         warning(ASAwarn(25,{'column';'cand_arma_order';'row'},ASAcontrol))
      end
   end
   if ~isempty(arma_order_diff) & ...
         (~isnum(arma_order_diff) | ...
         ~isintscalar(arma_order_diff) |...
         arma_order_diff<0)
      error(ASAerr(17,'arma_order_diff'))
   end

   %Input argument value checks
   if ~isreal(sig)
      error(ASAerr(13))
   end
   if max(cand_ar_order) > length(sig)-1
      error(ASAerr(37,'cand_ar_order'))
   end
   if max(cand_ma_order) > length(sig)-1
      error(ASAerr(37,'cand_ma_order'))
   end
   if ~isempty(cand_arma_order) & ...
         ~isempty(arma_order_diff)
      if cand_arma_order(1)~=0 & ...
            (arma_order_diff < 1 | ...
            arma_order_diff > cand_arma_order(1))
         error(ASAerr(18,{'arma_order_diff';'1';...
               num2str(cand_arma_order(1))}))
      elseif length(cand_arma_order)>1 & ...
            (arma_order_diff < 1 | ...
            arma_order_diff > cand_arma_order(2))
         error(ASAerr(18,{'arma_order_diff';'1';...
               num2str(cand_arma_order(2))}))
      end
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
   sig2ar(ASAcontrol);
   sig2ma(ASAcontrol);
   sig2arma(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
      %Run the computational kernel
   ASAcontrol.run = 1;
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;
   ASAdate = now;

%Main   
%========================================================================================
   
%Initialization of variables
%---------------------------

if isempty(ASAglob_subtr_mean) | ASAglob_subtr_mean
   sig = sig-mean(sig);
   ASAglob_subtr_mean = 0;
   if isempty(ASAglob_mean_adj)
      ASAglob_mean_adj = 1;
   end
elseif isempty(ASAglob_mean_adj)
   ASAglob_mean_adj = 0;
end

if isempty(cand_ar_order) & isempty(cand_ma_order) & isempty(cand_arma_order)
   default_order = 1;
else
   default_order = 0;
end

if ASAglob_ar_cond
   ASAglob_ar_cond = 1;
else
   if default_order
      ASAglob_ar_cond = 1;
   else
      ASAglob_ar_cond = 0;
   end
end
   
%AR-, MA- and ARMA-model identification
%--------------------------------------

[ar_ar,ar_sellog] = sig2ar(sig,cand_ar_order,ASAcontrol);
[ma_ma,ma_sellog] = sig2ma(sig,cand_ma_order,ASAcontrol);
[arma_ar,arma_ma,arma_sellog] = sig2arma(sig,cand_arma_order,arma_order_diff,ASAcontrol);

%Selection of the ARMAsel model
%------------------------------

%Asess the selected model orders
order = [length(ar_ar)-1;length(ma_ma)-1;length(arma_ar)-1];

%Asess the corresponding prediction error estimates
if default_order
   sel_location = order+1;
else
   sel_location = ...
      [find(order(1) == ar_sellog.cand_order);...
       find(order(2) == ma_sellog.cand_order);...    
       find(order(3) == arma_sellog.cand_ar_order)];
end
pe_est = [ar_sellog.pe_est(sel_location(1));...
      ma_sellog.pe_est(sel_location(2));...
      arma_sellog.pe_est(sel_location(3))];

%Select the model with the smallest prediction error estimate
[sel_pe_est,model] = min(pe_est);


%Arranging output arguments
%--------------------------

%Retrieve the parameters of the selected model
ar = 1;
ma = 1;
switch model
case 1 %The AR model has been selected
   ar = ar_ar;
case 2 %The MA model has been selected
   ma = ma_ma;
case 3 %The ARMA model has been selected
   ar = arma_ar;
   ma = arma_ma;
end

%Gernerate a structure variable ASAsellog to report the selection process
if nargout>2
   ASAsellog.funct_name = mfilename;
   ASAsellog.funct_version = ASAcontrol.is_version;
   ASAsellog.date_time = [datestr(ASAdate,8) 32 datestr(ASAdate,0)];
   ASAsellog.comp_time = ar_sellog.comp_time+ma_sellog.comp_time+arma_sellog.comp_time;
   ASAsellog.armasel.ar = ar;
   ASAsellog.armasel.ma = ma;
   ASAsellog.armasel.ar_pe_est = pe_est(1);
   ASAsellog.armasel.ma_pe_est = pe_est(2);
   ASAsellog.armasel.arma_pe_est = pe_est(3);
   ASAsellog.armasel.ar_cond = ASAglob_ar_cond;
   ASAsellog.armasel.mean_adj = ASAglob_mean_adj;
   ASAsellog.ar = ar_sellog;
   ASAsellog.ma = ma_sellog;
   ASAsellog.arma = arma_sellog;
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
%                        S. de Waele            waele@tn.tudelft.nl
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl
