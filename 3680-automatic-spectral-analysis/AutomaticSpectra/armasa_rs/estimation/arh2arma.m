function [ar,ma,ASAsellog,ASAcontrol]=arh2arma(varargin)
%ARH2ARMA ARMA model identification
%   [AR,MA,SELLOG] = ARH2ARMA(ARH,N_OBS) estimates autoregressive moving 
%   average models from the high-order AR model ARH and selects a model with 
%   optimal predictive qualities. ARH has been estimated from N_OBS
%   observations. Only ARMA(P,P-1) models are considered with AR order P 
%   being greater than the MA order by one. The selected model is returned 
%   in the parameter vectors AR and MA. The structure SELLOG provides
%   additional information on the selection process.
%   
%   ARH2ARMA(ARH,N_OBS,CAND_AR_ORDER,ARMA_ORDER_DIFF) selects only from 
%   candidate models ARMA(CAND_AR_ORDER,CAND_AR_ORDER - ARMA_ORDER_DIFF). 
%   CAND_AR_ORDER must either be a row of ascending orders, or a single 
%   order (in which case no true order selection is performed). 
%   ARMA_ORDER_DIFF, a scalar, is the difference between AR and MA orders 
%   being constant during selection. In the current version, only a value   
%   of 1 for ARMA_ORDER_DIFF allowed.
%   
%   N_OBS can also be a vector containing the lengths of segments of data.
%
%   CAND_AR_ORDER or ARMA_ORDER_DIFF may be passed as empty arguments. In 
%   case of empty ARMA_ORDER_DIFF, the difference between orders will be 
%   chosen 1. In case of empty CAND_AR_ORDER, an appropriate set of 
%   candidate orders will be chosen depending on the value of 
%   ARMA_ORDER_DIFF and the number of observations.
%   
%   ARH2ARMA is an ARMASA_RS main function.
%   
%   See also: SIG2ARMA, ARH2AR, ARH2MA, ARMASEL_RS, DATA_SEGMENTS.
   
%   Reference:  P. M. T. Broersen and S. de Waele, Selection of Order and
%               Type of Time Series Models Estimated from Reduced Statistics
%               Proceedings of {SYSID} 2000, May 2002.

%Header
%====================================================================

%Declaration of variables
%------------------------

%Declare and asarhn values to local variables
%according to the input argument pattern
[ar_rs,n_obs,cand_ar_order,arma_order_diff,ASAcontrol] = ASAarg(varargin, ...
{'ar_rs'       ;'n_obs'        ;'cand_ar_order';'arma_order_diff';'ASAcontrol'}, ...
{'isnumeric'   ;'isnumeric'    ;'isnumeric'    ;'isnumeric'      ;'isstruct'  }, ...
{'ar_rs'       ;'n_obs'                                                       }, ...
{'ar_rs'       ;'n_obs'        ;'cand_ar_order'                               }, ...
{'ar_rs'       ;'n_obs'        ;'cand_ar_order';'arma_order_diff'             });

if isequal(nargin,1) & ~isempty(ASAcontrol)
      %ASAcontrol is the only input argument
   ASAcontrol.error_chk = 0;
   ASAcontrol.run = 0;
end

%Declare ASAglob variables 
ASAglob = {'ASAglob_subtr_mean';'ASAglob_mean_adj'; ...
      'ASAglob_rc';'ASAglob_ar';'ASAglob_final_f'; ...
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
%toolbox. The versions of these other functions must
%be greater than or equal to:
ASAcontrol.req_version.burg = [2000 12 30 20 0 0];
ASAcontrol.req_version.cic_s = [2000 12 30 20 0 0];
ASAcontrol.req_version.rc2arset = [2000 12 30 20 0 0];
ASAcontrol.req_version.ar2arset = [2000 12 30 20 0 0];
ASAcontrol.req_version.cov2arset = [2000 12 30 20 0 0];
ASAcontrol.req_version.armafilter = [2000 12 12 14 0 0];
ASAcontrol.req_version.convol = [2000 12 6 12 17 20];
ASAcontrol.req_version.convolrev = [2000 12 6 12 17 20];
ASAcontrol.req_version.deconvol = [2000 12 12 12 0 0];

%Checks
%------

if ~isfield(ASAcontrol,'error_chk') | ASAcontrol.error_chk
   %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(ar_rs)
      error(ASAerr(11,'ar_rs'))
   end
   if ~isvector(ar_rs)
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
   if ~isempty(cand_ar_order) & ...
         ~isempty(arma_order_diff)
      if cand_ar_order(1)~=0 & ...
            (arma_order_diff < 1 | ...
            arma_order_diff > cand_ar_order(1))
         error(ASAerr(18,{'arma_order_diff';'1';...
               num2str(cand_ar_order(1))}))
      elseif length(cand_ar_order)>1 & ...
            (arma_order_diff < 1 | ...
            arma_order_diff > cand_ar_order(2))
         error(ASAerr(18,{'arma_order_diff';'1';...
               num2str(cand_ar_order(2))}))
      end
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
   ar2arset(ASAcontrol);
   cov2arset(ASAcontrol);
   armafilter(ASAcontrol);
   convol(ASAcontrol);
   convolrev(ASAcontrol);
   deconvol(ASAcontrol);
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

n_obs_tot = sum(n_obs);

%Assign zero-order ARMA parameters
ma_stack{1} = 1;
ar_stack{1} =1;
stack_entry = 1;

%Initialize AR parameter vectors
rc = [];
ar = [];

all_ill_cond = []; %Order where all methods are ill-conditioned

warn_state = warning;

%Combined determination of maximum candidate AR
%and MA orders
%----------------------------------------------
def_max_ar_order = length(ar_rs)-1;

%Asess the default value of the maximum candidate AR
%order
if isempty(arma_order_diff) %The default value of
    %Assign a default value 1 to the difference between
    %AR and MA orders
    arma_order_diff = 1;
elseif arma_order_diff < 1 | ...
        arma_order_diff > def_max_ar_order
    error(ASAerr(18,{'arma_order_diff';'1';...
            [num2str(def_max_ar_order) ...
                ' (== max. candidate AR order, selected by default)']}))
end

def_max_ar_order = ...
    min(fix([n_obs_tot/10 40*log10(n_obs_tot) (arma_order_diff+n_red_stat)/2]));
if def_max_ar_order > 200; 
    %Limit the default to order 200
    def_max_ar_order = 200;
end

%Determine maximum candidate ARMA orders
if isempty(cand_ar_order) %The default max. candidate
    %AR order is applicable
    cand_ar_order = ...
        [0 arma_order_diff:def_max_ar_order];
end
max_ar_order = cand_ar_order(end);
max_ma_order = max_ar_order-arma_order_diff;

%Determine the maximum candidate sliding AR order
if max_ar_order <= def_max_ar_order %The specified
    %max. AR order is less than the default value
    %Condition the max. sliding AR order to the AR
    %default
    max_slid_ar_order = min(fix([5*def_max_ar_order n_red_stat]));
else %The specified AR order is greater than the
    %default value (which means relatively large)
    %Except for the imposed maximum of 200, apply the
    %same rule to obtain the max. sliding AR order
    max_slid_ar_order = min(fix([5*max_ar_order n_red_stat]));
    %Check whether the size of the reduced statistic is sufficient
    %for the requested maximum model order
    if max_slid_ar_order-max_ar_order < max_ma_order
        %Lack of degrees of freedom in estimation
        max_ar_order = ...
            fix((arma_order_diff+max_slid_ar_order)/2);
        max_ma_order = ...
            max_ar_order - arma_order_diff;
        warning(ASAwarn(16,{num2str(max_ar_order);...
                num2str(max_ma_order)},ASAcontrol));
        if ~any(max_ar_order==cand_ar_order)
            error(ASAerr(38))
        end
    end
end

min_ar_order = arma_order_diff;
min_ma_order = 0;

%Preparations for the estimation procedure
%-----------------------------------------

if max_ar_order > 0 %An estimation is required
    [ar_orig, rc] = ar2arset(ar_rs,[1:max_slid_ar_order],ASAcontrol);
    rc = [1 rc];
    
    %AR model order selection
    if isequal(ASAglob_ar_cond,1) & ...
            ~isempty(ASAglob_ar) %The selected AR order
        %that will be used, is conditioned to an
        %earlier performed AR selection procedure
        %Assess the order of a previously selected AR
        %model
        ar = ASAglob_ar;
        sel_ar_order = length(ar)-1;
    else 
        %Select the optimal AR order for prediction
        res = var*[1 cumprod(1-rc(2:max_slid_ar_order+1).^2)];
        [min_value,sel_location] = ...
            min(cic_s(res,n_obs,ASAcontrol));
        sel_ar_order = sel_location-1;
        if sel_ar_order
            ar = ar_orig{sel_ar_order};
        else
            ar = 1;
        end
    end
    clear res
    
    %Determine the zero-order estimate
    counter = 1;
    res(counter) = moderr_e(1,1,ar_rs,1,1,ASAcontrol)+1;
    ar_stack{counter} = 1;
    ma_stack{counter} = 1;
    meth_s_stack(1) = 1;
    
    %Compute the first ARMA model, which equals an
    %AR model of the minimum candidate AR order
    counter = counter+1;
    ar_order = min_ar_order;
    ma_order = min_ma_order;
    ar_stack{counter} = ar_orig{ar_order};
    ma_stack{counter} = 1;
    
    %Evaluate the variables involved in order selection
    %for the model computed above
    res(counter) = moderr_e(ar_stack{counter},1,ar_rs,1,1,ASAcontrol)+1;
    
    ar_order = ar_order+1;
    ma_order = ma_order+1;
    
    %Initialize the sliding AR order
    slid_ar_order = 3*sel_ar_order+ar_order+ma_order;
    if slid_ar_order > max_slid_ar_order
        slid_ar_order = max_slid_ar_order;
    end
    
    %Initialize the estimation loop
    ar_order_start = ar_order;
    reset_type = 1;
    
    if arma_order_diff ~= 1,
        arma_order_diff
        error('This version of Reduced Statistics ARMA estimation only works for arma_order_diff = 1.')
    end
    
    
    %Estimation procedure
    %--------------------
    %Selection of estimators that are calculated (1 = calculate / 0 = not calculate).
    arma_ini_est = [1 1 1 1];
    all_ill_cond = [];

    for ar_order = ar_order_start:max_ar_order
        ar_slid_win = ar_orig{slid_ar_order};
        res_s = Inf;   %Reset residual of selected estimator
        %_s indicates: selected out of different estimators for the current order
        if arma_ini_est(1),
            %Method 1: long AR
            lastwarn(''); warning on
            R = toeplitz(ar_slid_win(ar_order+1:end-1)',ar_slid_win(ar_order+1:-1:3));
            f = ar_slid_win(ar_order+2:end)';
            ma_ini = [1 -(R\f)'];
            ar_ini = convol(ar_slid_win,ma_ini);
            if ar_ini(1)~=1, 
                disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long AR'])
                arma_ini_est(1) = 0;
            else
                ar_ini = ar2arset(ar_ini,ar_order,ASAcontrol);
                ar_ini = ar_ini{1};
                if ~isempty(lastwarn),
                    disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long AR'])
                    arma_ini_est(1) = 0;
                else
                    [ar_i,ma_i] = durbin2(ar_slid_win,ar_ini,ma_order,ASAcontrol);
                    res_i = moderr_e(ar_i,ma_i,ar_rs,1,1,ASAcontrol)+1;
                    if res_i<0,
                        disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long AR'])
                        arma_ini_est(1) = 0;
                    elseif res_i < res_s,
                        ar_s = ar_i; ma_s = ma_i; res_s = res_i;
                        meth_s = 1;
                    end
                end
            end
        end
        
        if arma_ini_est(2),
            %Method 2: long MA
            lastwarn(''); warning on
            ghat=armafilter([1; zeros(2*n_red_stat,1)],ar_slid_win,1)'; % impulse response
            R = toeplitz(ghat(ar_order:end-1)',ghat(ar_order:-1:1));
            f = ghat(ar_order+1:end)';
            ar_ini = [1 -(R\f)'];
            if ~isempty(lastwarn),
                disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long MA'])
                arma_ini_est(2) = 0;
            else 
                [ar_i,ma_i] = durbin2(ar_slid_win,ar_ini,ma_order,ASAcontrol);
                res_i = moderr_e(ar_i,ma_i,ar_rs,1,1,ASAcontrol)+1;
                if res_i<0,
                    disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long MA'])
                    arma_ini_est(2) = 0;
                elseif res_i < res_s,
                    ar_s = ar_i; ma_s = ma_i; res_s = res_i;
                    meth_s = 2;
                end
            end
        end
        
        if arma_ini_est(3),
            %Method 3: long COV
            lastwarn(''); warning on
            l = ar_order-1;
            coryw = arma2cor(ar_slid_win,1);
            ncor = length(coryw)-1;
            coryw = [coryw((ar_order-1:-1:1)+1) coryw]; %cor(t) = cor(t+ar_order)
            myw = toeplitz(coryw((l:ncor-1) +ar_order),coryw((l:-1:l-ar_order+1)  +ar_order));
            vyw = -coryw((l+1:ncor) +ar_order)';
            ar_ini = myw\vyw;
            ar_ini = [1 ar_ini'];   
            warning on
            if ~isempty(lastwarn),
                disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long COV'])
                arma_ini_est(3) = 0;
            else
                [ar_i,ma_i] = durbin2(ar_slid_win,ar_ini,ma_order,ASAcontrol);
                res_i = moderr_e(ar_i,ma_i,ar_rs,1,1,ASAcontrol)+1;
                if res_i<0,
                    disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long COV'])
                    arma_ini_est(3) = 0;
                elseif res_i < res_s,
                    ar_s = ar_i; ma_s = ma_i; res_s = res_i;
                    meth_s = 3;
                end
            end
        end
        
        if arma_ini_est(4),
            %Method 4: long Rinv; Inverse correlation method  
            lastwarn(''); warning on
            Rinv=arma2cor(1,ar_slid_win,slid_ar_order+1); %inverse correlation for ARMA method 4
            R = toeplitz(Rinv(ar_order+1:end-1)',Rinv(ar_order+1:-1:3));
            f = Rinv(ar_order+2:end)';
            ma_ini = [1 -(R\f)'];
            ar_ini = convol(ar_slid_win,ma_ini);
            if ar_ini(1)~=1, 
                disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long Rinv'])
                arma_ini_est(4) = 0;
            else
                ar_ini = ar2arset(ar_ini,ar_order,ASAcontrol);
                ar_ini = ar_ini{1};
                if ~isempty(lastwarn)
                    disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long Rinv'])
                    arma_ini_est(4) = 0;
                else 
                    [ar_i,ma_i] = durbin2(ar_slid_win,ar_ini,ma_order,ASAcontrol);
                    res_i = moderr_e(ar_i,ma_i,ar_rs,1,1,ASAcontrol)+1;
                    if res_i<0,
                        disp(['ARMA-Order = ' int2str(ar_order) ': Durbin 1 is ill-conditioned for long Rinv'])
                        arma_ini_est(4) = 0;
                    elseif res_i < res_s,
                        ar_s = ar_i; ma_s = ma_i; res_s = res_i;
                        meth_s = 4;
                    end
                end
            end
        end
        if ~any(arma_ini_est),
            %If non of the estimators yield a result, leave loop
            all_ill_cond = ar_order; %Order where all methods are ill-conditioned
            warning(['No ARMA estimates for order => ' int2str(ar_order)])
            break
        end
        %Add the computed parameter vectors to their stacks
        counter = counter+1;
        ar_stack{counter} = ar_s;
        ma_stack{counter} = ma_s;
        res(counter) = res_s;
        meth_s_stack(counter) = meth_s;
        ma_order = ma_order+1;
        
        if slid_ar_order < max_slid_ar_order-1
            %Slide the AR order 2 steps forward
            slid_ar_order = slid_ar_order+2;
        elseif slid_ar_order == max_slid_ar_order-1
            %Equalize the sliding AR order to its maximum  
            slid_ar_order = max_slid_ar_order;
        end
    end  
    if ~isempty(all_ill_cond)
        %If none of the estimators was succesfull:
        %Parameter estimates for higher order models
        %equal to last estimated ARMA model.
        ar_last = ar_stack{counter};
        ma_last = ma_stack{counter};
        res_last= res(counter);
        meth_s_last = meth_s_stack(counter);
        for ar_order = all_ill_cond:max_ar_order 
            counter = counter+1;
            ar_last = [ar_last 0];
            ma_last = [ma_last 0];
            %Possible: Durbin2 iterations
            ar_stack{counter} = ar_last;
            ma_stack{counter} = ma_last;
            res(counter) = res_last;
            meth_s_stack(counter) = meth_s_last;
        end
    end

   %ARMA model order selection
   %--------------------------
   [dummy gain] = arma2cor(ar_rs,1,0);
   res = res/gain;
   %Evaluate variables involved in order selection
   ar_orders = [0 arma_order_diff:max_ar_order];
   ma_orders = max(0,ar_orders-arma_order_diff);
   n_par = ar_orders+ma_orders;
   gic3 = log(res)+3*n_par/n_obs_tot;
    
   %Estimate the prediction error
   if ASAglob_mean_adj
       pe_est = res.*...
           (n_obs_tot+n_par+1)./...
           (n_obs_tot-n_par-1);
   else
       pe_est = res.*...
           (n_obs_tot+n_par)./...
           (n_obs_tot-n_par);
   end
   
   %Reduce the arrays computed above, keeping only the
   %elements associated with requested candidate
   %orders
   counter = 1;
   req_counter = 1;
   det_order = ...
      [0 min_ar_order ar_order_start:max_ar_order];
   for order = 0:max_ar_order
      if order == det_order(counter)
         if order == cand_ar_order(req_counter)
            res(req_counter) = res(counter);
            gic3(req_counter) = gic3(counter);
            pe_est(req_counter) = pe_est(counter);
            req_counter = req_counter+1;            
         end
         counter = counter+1;
      end
   end
   res = res(1:req_counter-1);
   gic3 = gic3(1:req_counter-1);
   pe_est = pe_est(1:req_counter-1);

   %Assess the order:
   %The order to be selected corresponds to the
   %location where GIC(3) has its minimum value
   [min_value,sel_location] = min(gic3);
   sel_cand_ar_order = cand_ar_order(sel_location);
   stack_entry = ...
      max(1,sel_cand_ar_order-min_ar_order+2);
else
    %Determine only the zero-order estimate
    counter = 1;
    res(counter) = moderr_e(1,1,ar_rs,1,1,ASAcontrol)+1;
    ar_stack{counter} = 1;
    ma_stack{counter} = 1;
    meth_s_stack(1) = 1;
    
    %Evaluate the variables involved in order selection
    %for the model computed above
    res(counter) = moderr_e(ar_stack{counter},1,ar_rs,1,1,ASAcontrol)+1;

   %Estimate the prediction error
   if ASAglob_mean_adj
       pe_est = res.*(n_obs_tot+1)/(n_obs_tot-1);
   else
       pe_est = res;
   end
   gic3 = log(res);
   all_ill_cond = [];
end

%Arranging output arguments
%--------------------------

ar_sel = ar;

%Retrieve the parameters of the proper model
ar = ar_stack{stack_entry};
ma = ma_stack{stack_entry};

%Assign reflectioncoefficients to ASAglob_rc, in order
%to make them available for other ARMASA functions
if ~isempty(rc)
   ASAglob_rc = rc;
end

%Generate a structure variable ASAsellog to report
%the selection process
ASAsellog.funct_name = mfilename;
ASAsellog.funct_version = ASAcontrol.is_version;
ASAsellog.date_time = ...
   [datestr(ASAdate,8) 32 datestr(ASAdate,0)];
ASAsellog.comp_time = etime(clock,ASAtime);
ASAsellog.ar = ar;
ASAsellog.ma = ma;
ASAsellog.ar_sel = ar_sel;
ASAsellog.mean_adj = ASAglob_mean_adj;
ASAsellog.cand_ar_order = cand_ar_order;
ASAsellog.arma_order_diff = arma_order_diff;
ASAsellog.gic3 = gic3;
ASAsellog.pe_est = pe_est;
ASAsellog.all_ill_cond = all_ill_cond;
% if cand_ar_order(1)~=0,
%     %Remove white noise model
%     ar_stack = ar_stack(2:end);
%     ma_stack = ma_stack(2:end);
%     meth_s_stack = meth_s_stack(2:end);
% end
ASAsellog.ar_stack = ar_stack(cand_ar_order+1);
ASAsellog.ma_stack = ma_stack(cand_ar_order+1);
ASAsellog.meth_s_stack = meth_s_stack(cand_ar_order+1);

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
% [2000 12 30 20 0 0]         ,,                          ,,
