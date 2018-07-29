function [ar,ma,ASAsellog,ASAcontrol]=armasel_rs(varargin)
%ARMASEL_RS ARMAsel model identification
%   [AR,MA,SELLOG] = ARMASEL_RS(ARH,N_OBS) estimates autoregressive, moving 
%   average, and autoregressive moving average models from the high-order 
%   AR model ARH and selects the model with optimal predictive qualities.
%   ARH has been estimated from N_OBS observations. The AR and MA parts of
%   the selected model, each possibly of order 0, are returned in the
%   parameter vectors AR and MA. The structure SELLOG provides additional
%   information on the selection process.
%   
%   SELLOG contains the fields 'ar', 'ma' and 'arma', in which SELLOG 
%   structures are nested, as returned by the functions ARH2AR, ARH2MA 
%   and ARH2ARMA, invoked by ARMASEL. In the field 'armasel' a structure 
%   is nested that reports information about the final stage of model 
%   selection, where the preselected AR, MA and ARMA models are compared.
%   
%   ARMASEL(ARH,N_OBS,CAND_AR_ORDER,CAND_MA_ORDER,CAND_ARMA_ORDER)
%   narrows the selection to candidate models with orders provided by the 
%   rows CAND_AR_ORDER, CAND_MA_ORDER and CAND_ARMA_ORDER AR, MA and
%   ARMA(r,r-1) models independently.
%   For any of these arguments it is allowed to pass an 
%   empty array. Alternatively, additional arguments may be omitted from 
%   the input list. In both cases, default values are automatically 
%   determined and substituted for the missing arguments. The functions 
%   ARH2AR, ARH2MA and ARH2ARMA provide additional information on 
%   defining candidate orders. Note in this respect, that the candidate 
%   AR orders of the ARMA model are called CAND_ARMA_ORDER in this help 
%   text, while in ARH2ARMA they are called CAND_AR_ORDER.
%
%   The selection of MA and ARMA models can be conditioned to the 
%   selection of AR models from a specific set of candidate orders 
%   CAND_AR_ORDER. See ASAGLOB_AR_COND for more information.
%   
%   ARMASEL_RS is an ARMASA_RS main function.
%   ARMASEL_RS can also be used to selected models based on an ARH model
%   that has been estimated from segments of data.
%   
%   See also: ARMASEL, ARH2AR, ARH2MA, ARH2ARMA, DATA_SEGMENTS.

%   Reference:  P. M. T. Broersen and S. de Waele, Selection of Order and
%               Type of Time Series Models Estimated from Reduced Statistics
%               Proceedings of SYSID 2002, May 2002.

%Header
%===================================================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
[ar_rs,n_obs,cand_ar_order,cand_ma_order,cand_arma_order,arma_order_diff,ASAcontrol] = ASAarg(varargin, ...
{'ar_rs'       ;'n_obs'      ;'cand_ar_order';'cand_ma_order';'cand_arma_order';'arma_order_diff';'ASAcontrol'}, ...
{'isnumeric'   ;'isnumeric'  ;'isnumeric'    ;'isnumeric'    ;'isnumeric'      ;'isnumeric'      ;'isstruct'  }, ...
{'ar_rs'       ;'n_obs'                                                                                       }, ...
{'ar_rs'       ;'n_obs'      ;'cand_ar_order'                                                                 }, ...
{'ar_rs'       ;'n_obs'      ;'cand_ar_order';'cand_ma_order'                                                 }, ...
{'ar_rs'       ;'n_obs'      ;'cand_ar_order';'cand_ma_order';'cand_arma_order'                               }, ...
{'ar_rs'       ;'n_obs'      ;'cand_ar_order';'cand_ma_order';'cand_arma_order';'arma_order_diff'             });

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

if ~isfield(ASAcontrol,'error_chk') | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(ar_rs)
      error(ASAerr(11,'ar_rs'))
   elseif ~isvector(ar_rs)
      error([ASAerr(14) ASAerr(15,'ar_rs')])
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
   if ~isreal(ar_rs)
      error(ASAerr(13))
   end
   if max(cand_ar_order) > length(ar_rs)-1
      error(ASAerr(37,'cand_ar_order'))
   end
   if max(cand_ma_order) > length(ar_rs)-1
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

if ~isfield(ASAcontrol,'version_chk') | ...
      ASAcontrol.version_chk %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
   
   %Make sure the requested versions of the called
   %functions comply with their actual versions
   arh2ar(ASAcontrol);
   arh2ma(ASAcontrol);
   arh2arma(ASAcontrol);
end

if ~isfield(ASAcontrol,'run') | ASAcontrol.run
   ASAcontrol.run = 1;
   ASAdate = now;
end

if ASAcontrol.run %Run the computational kernel
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;

%Main   
%=====================================================
   
%Initialization of variables
%---------------------------

if ASAglob_ar_cond
   ASAglob_ar_cond = 1;
else
   ASAglob_ar_cond = 0;
end

n_obs_tot = sum(n_obs);

%AR-, MA- and ARMA-model identification
%--------------------------------------

[ar_ar,ar_sellog] = arh2ar...
   (ar_rs,n_obs,cand_ar_order,ASAcontrol);
[ma_ma,ma_sellog] = arh2ma...
   (ar_rs,n_obs,cand_ma_order,ASAcontrol);
[arma_ar,arma_ma,arma_sellog] = arh2arma...
   (ar_rs,n_obs,cand_arma_order,arma_order_diff,ASAcontrol);

%Selection of the ARMAsel model
%------------------------------

%Asess the selected model orders
order = ...
   [length(ar_ar)-1;length(ma_ma)-1;length(arma_ar)-1];

%Asess the corresponding prediction error estimates
sel_location = ...
   [find(order(1) == ar_sellog.cand_order);...
    find(order(2) == ma_sellog.cand_order);...    
    find(order(3) == arma_sellog.cand_ar_order)];
pe_est = [ar_sellog.pe_est(sel_location(1));...
      ma_sellog.pe_est(sel_location(2));...
      arma_sellog.pe_est(sel_location(3))];

%Select the model with the smallest prediction error
%estimate
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

%Gernerate a structure variable ASAsellog to report
%the selection process
ASAsellog.funct_name = mfilename;
ASAsellog.funct_version = ASAcontrol.is_version;
ASAsellog.date_time = ...
   [datestr(ASAdate,8) 32 datestr(ASAdate,0)];
ASAsellog.comp_time = ar_sellog.comp_time+...
   ma_sellog.comp_time+...
   arma_sellog.comp_time;
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
%                        S. de Waele            waele@tn.tudelft.nl
% [2000 11  1 12 0 0]    W. Wunderink           wwunderink01@freeler.nl
% [2000 12 30 20 0 0]         ,,                          ,,
