function [ma,ASAsellog,ASAcontrol] = arh2ma(varargin)
%ARH2MA MA model identification
%   [MA,SELLOG] = ARH2MA(ARH,N_OBS) estimates moving average models from
%   the high-order AR model ARH and selects a model with optimal predictive 
%   qualities. ARH has been estimated from N_OBS observations. The selected
%   model is returned in the parameter vector MA. The structure SELLOG
%   provides additional information on the selection process.
%   
%   N_OBS can also be a vector containing the lengths of segments of data.
%
%   SIG2MA(ARH,CAND_ORDER) selects only from candidate models whose 
%   orders are entered in CAND_ORDER. CAND_ORDER must either be a row of 
%   ascending orders, or a single order (in which case no true order 
%   selection is performed).
%   
%   SIG2MA is an ARMASA main function.
%   
%   See also: SIG2AR, SIG2ARMA, ARMASEL, DATA_SEGMENTS.

%   Reference:  P. M. T. Broersen and S. de Waele, Selection of Order and
%               Type of Time Series Models Estimated from Reduced Statistics
%               Proceedings of SYSID 2002, May 2002.

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
ASAcontrol.req_version.cic_s = [2000 12 30 20 0 0];
ASAcontrol.req_version.rc2arset = [2000 12 30 20 0 0];
ASAcontrol.req_version.cov2arset = [2000 12 30 20 0 0];

%Checks
%------

if ~isfield(ASAcontrol,'error_chk') | ...
      ASAcontrol.error_chk
   %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(ar_rs)
      error(ASAerr(11,'ar_rs'))
   end
   if ~isvector(ar_rs)
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
   cov2arset(ASAcontrol);
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

%Combined determination of the maximum candidate MA
%order and the max. candidate sliding AR order 
%--------------------------------------------------

%Asess the default value of the maximum candidate MA
%order
def_max_ma_order = ...
   min(fix([n_obs_tot/5 80*log10(n_obs_tot) n_red_stat]));
if def_max_ma_order > 400; 
   %Limit the default value to order 400
   def_max_ma_order = 400;
end

%Determine the maximum candidate MA order
if isempty(cand_order) %The MA default is applicable
   cand_order = 0:def_max_ma_order;
end
max_ma_order = cand_order(end);

%Determine the maximum sliding AR order
if max_ma_order <= def_max_ma_order %The specified
      %max. MA order is less than the default value
      %Condition the max. sliding AR order to the MA 
      %default
   max_slid_ar_order = min(fix([2.5*def_max_ma_order n_red_stat]));
else %The specified MA order is greater than the
     %default value (which means relatively large)
   %Except for the imposed maximum of 1000, apply the
   %same rule to obtain the max. sliding AR order
   max_slid_ar_order = min(fix([2.5*max_ma_order n_red_stat]));
end

%Preparations for the estimation procedure
%-----------------------------------------

if max_ma_order > 0 %An estimation is required
   %AR model estimation
   [ar_stack,rc] = ...
      ar2arset(ar_rs,[1:max_slid_ar_order],ASAcontrol);
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
         ar = ar_stack{sel_ar_order};
      else
         ar = 1;
      end
   end
      
   %Asess the minimum estimation order
   min_ma_order = max(1,cand_order(1));
   
   %Initialize the sliding AR order
   slid_ar_order = 2*sel_ar_order+min_ma_order;
   if slid_ar_order > max_slid_ar_order
      slid_ar_order = max_slid_ar_order;
   elseif slid_ar_order < 3
      slid_ar_order = min(3,max_slid_ar_order);
   end
        
   %Initialize the parameter storage stack counter
   counter = 2;

   %Estimation procedure
   %--------------------
   %Assign the zero-order MA parameter
   ma_stack{1} = 1;
   stack_entry = 1;
   
   %Determine the zero-order estimates concerning:
   %residual variance, selection criterion and prediction
   %error
   res = 1;
   gic3 = log(res)+3/n_obs_tot;
   if ASAglob_mean_adj
       pe_est = var*(n_obs_tot+1)/(n_obs_tot-1);
   else
       pe_est = var;
   end

   for order = min_ma_order:max_ma_order
      %Durbin MA estimator
      ar_slid = ar_stack{slid_ar_order};
      ar_corr = convolrev(ar_slid,order,ASAcontrol);
      ma_stack{counter} = ...
         cov2arset(ar_corr,ASAcontrol);

      if slid_ar_order < max_slid_ar_order
         %Slide the AR order one step forward
         slid_ar_order = slid_ar_order+1;
      end
      
      %Update the stack counter
      counter = counter+1;
   end
   
   %MA model order selection
   %------------------------
   [dummy gain] = arma2cor(ar_rs,1,0);
   %Evaluate variables involved in order selection
   counter = 2;
   for order = min_ma_order:max_ma_order
      %Estimate the residual variance
      res(counter) = (moderr(1,ma_stack{counter},ar_rs,1,1,ASAcontrol)+1)/gain;
      
      %Evaluate the order selection criterion GIC(3)
      gic3(counter) = ...
         log(res(counter))+3*(order+1)/n_obs_tot;
      
      %Estimate the prediction error
      if ASAglob_mean_adj
         pe_est(counter) = res(counter)*...
            (n_obs_tot+order+1)/(n_obs_tot-order-1);
      else
         pe_est(counter) = res(counter)*...
            (n_obs_tot+order)/(n_obs_tot-order);
      end
      counter = counter+1;
   end

   %Reduce the arrays computed above, keeping only the
   %elements associated with requested candidate
   %orders
   counter = 1;
   req_counter = 1;
   det_order = [0 min_ma_order:max_ma_order];
   for order = 0:max_ma_order
      if order == det_order(counter)
         if order == cand_order(req_counter)
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
   %The MA order to be selected corresponds to the
   %location where GIC(3) has its minimum value
   [min_value,sel_ma_location] = min(gic3);
   sel_cand_order = cand_order(sel_ma_location);
   stack_entry = sel_cand_order-min_ma_order+2;
end

%Arranging output arguments
%--------------------------

%Retrieve the parameters of the proper model
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
ASAsellog.ma = ma;
ASAsellog.ar_sel = ar;
ASAsellog.mean_adj = ASAglob_mean_adj;
ASAsellog.cand_order = cand_order;
ASAsellog.gic3 = gic3;
ASAsellog.pe_est = pe_est;
if cand_order(1)~=0,
    %Remove white noise model
    ma_stack = ma_stack(2:end);
end
ASAsellog.ma_stack = ma_stack;

%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   ma = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% former versions        P.M.T. Broersen        broersen@tn.tudelft.nl
% [2000 12 30 20 0 0]         ,,                          ,,
%                        S. de Waele            stijn.de.waele@philips.com