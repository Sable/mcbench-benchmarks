function [ma,ASAsellog,ASAcontrol] = sig2ma(sig,cand_order,last)
%SIG2MA MA model identification
%   [MA,SELLOG] = SIG2MA(SIG) estimates moving average models from the 
%   data vector SIG and selects a model with optimal predictive 
%   qualities. The selected model is returned in the parameter vector MA. 
%   The structure SELLOG provides additional information on the selection 
%   process.
%   
%   SIG2MA(SIG,CAND_ORDER) selects only from candidate models whose 
%   orders are entered in CAND_ORDER. CAND_ORDER must either be a row of 
%   ascending orders, or a single order (in which case no true order 
%   selection is performed).
%   
%   Without user intervention, the mean of SIG is subtracted from the 
%   data. To control the subtraction of the mean, see the help topics on 
%   ASAGLOB_SUBTR_MEAN and ASAGLOB_MEAN_ADJ.
%     
%   SIG2MA is an ARMASA main function.
%   
%   See also: SIG2AR, SIG2ARMA, ARMASEL.

%   References: P. M. T. Broersen, Autoregressive Model Orders for
%               Durbin's MA and ARMA estimators, IEEE Transactions on
%               Signal Processing, Vol. 48, No. 8, August 2000,
%               pp. 2454-2457.

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
ASAcontrol.req_version.cic = [2000 12 30 20 0 0];
ASAcontrol.req_version.rc2arset = [2000 12 30 20 0 0];
ASAcontrol.req_version.cov2arset = [2000 12 30 20 0 0];
ASAcontrol.req_version.armafilter = [2000 12 12 14 0 0];
ASAcontrol.req_version.convol = [2000 12 6 12 17 20];
ASAcontrol.req_version.convolrev = [2000 12 6 12 17 20];

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
   %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(sig)
      error(ASAerr(11,'sig'))
   end
   if ~isavector(sig)
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
   cov2arset(ASAcontrol);
   armafilter(ASAcontrol);
   convol(ASAcontrol);
   convolrev(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
      %Run the computational kernel
   ASAcontrol.run = 1;
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;
   ASAtime = clock;
   ASAdate = now;

%Main   
%================================================================================================
  
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

n_obs = length(sig);
ar_stack = cell(4,1);
ar_entry = ones(1,4);
rc = [];
ma_sel = 1;

%Combined determination of the maximum candidate MA
%order and the max. candidate sliding AR order 
%--------------------------------------------------

def_max_ma_order = min(fix(n_obs/5),fix(80*log10(n_obs)));
if def_max_ma_order > 400; 
   def_max_ma_order = 400;
end

if isempty(cand_order)
   cand_order = 0:def_max_ma_order;
end
max_ma_order = cand_order(end);

if max_ma_order <= def_max_ma_order
   max_slid_ar_order = fix(2.5*def_max_ma_order);
else
   max_slid_ar_order = fix(2.5*max_ma_order);
   if max_slid_ar_order > n_obs-1
      max_slid_ar_order = n_obs-1;
   end
end

%Preparations for the estimation procedure
%-----------------------------------------

l_cand_order = length(cand_order);
ma = zeros(1,max_ma_order);
var = sig'*sig/n_obs;
if cand_order(1)==0
   zero_incl = 1;
   gic3 = zeros(1,l_cand_order);
   gic3(1) = log(var)+3/n_obs;
   pe_est = zeros(1,l_cand_order);
   if ASAglob_mean_adj
      pe_est(1) = var*(n_obs+1)/(n_obs-1);
   else
      pe_est(1) = var;
   end
else
   zero_incl = 0;
   cand_order = [0 cand_order];
   gic3 = zeros(1,l_cand_order+1);
   gic3(1) = inf;
   pe_est = zeros(1,l_cand_order+1);
end

if max_ma_order > 0
   %Conditioning AR orders to the previously selected AR model
   if isequal(ASAglob_ar_cond,1) & ~isempty(ASAglob_ar)
      ar = ASAglob_ar;
      sel_ar_order = length(ar)-1;
      if  2*sel_ar_order+max_ma_order < max_slid_ar_order
         max_slid_ar_order = 2*sel_ar_order+max_ma_order;
      end
   end 
   
   %AR model estimation
   l_rc = length(ASAglob_rc);
   if l_rc>1
      rc = ASAglob_rc;
      if (l_rc < max_slid_ar_order+1)
         if isempty(ASAglob_final_f)
            ar_det = rc2arset(ASAglob_rc(1:end-1),ASAcontrol);
            ASAglob_final_f = convol(sig,ar_det,l_rc-1,n_obs,ASAcontrol);
            ASAglob_final_b = convolrev(ar_det,sig,l_rc-1,n_obs,ASAcontrol);
         end
         rc = [ASAglob_rc burg(ASAglob_final_f, ...
               ASAglob_final_b,max_slid_ar_order+1-l_rc,ASAcontrol)];
      end
   else
      rc = burg(sig,max_slid_ar_order,ASAcontrol);
   end

   %AR model order selection
   if ~isequal(ASAglob_ar_cond,1) | isempty(ASAglob_ar)
      rc(1) = 0;
      res = var*cumprod(1-rc(1:max_slid_ar_order+1).^2);
      rc(1) = 1;
      [min_value,sel_location] = min(cic(res,n_obs,ASAcontrol));
      sel_ar_order = sel_location-1;
   end
   
   min_ma_order = max(1,cand_order(1));
   
   slid_ar_order = 2*sel_ar_order+min_ma_order;
   if slid_ar_order > max_slid_ar_order
      slid_ar_order = max_slid_ar_order;
   elseif slid_ar_order < 3
      slid_ar_order = min(3,max_slid_ar_order);
   end
   
   pred_ar_order = min(3*sel_ar_order+min(9,1+fix(n_obs/10)),max_slid_ar_order);
   
   %Determine a minimum set of AR parameter vectors, as needed for the preparations
   [cand_ar_order,ar_entry] = sort([sel_ar_order pred_ar_order slid_ar_order max_slid_ar_order]);
   equal_entry = zeros(1,4);
   [dummy,redirect] = sort(ar_entry);
   equal_counter = 0;
   for i = 2:4
      if isequal(cand_ar_order(i),cand_ar_order(i-1));
         equal_counter = equal_counter+1;
         equal_entry(i) = i;
         index = find(max(0,redirect-i+equal_counter));
         redirect(index) = redirect(index)-1;
      end
   end
   cand_ar_order(find(equal_entry)) = [];
   ar_entry = redirect;
   ar_stack = rc2arset(rc,cand_ar_order,ASAcontrol);
   
   ar_pred = ar_stack{ar_entry(2)};
   l_ar_pred = length(ar_pred);
   l_pred_sig = fix(n_obs/2);
   pred_sig_rev = armafilter(zeros(l_pred_sig,1),ar_pred,1,...
      sig(end:-1:1),convolrev(sig,ar_pred,1,l_ar_pred,ASAcontrol),ASAcontrol);
   pred_sig = pred_sig_rev(end:-1:1);
   
   counter = 2;
   req_counter = 2;
   sel_index = 1;
   ar_slid = zeros(1,max_slid_ar_order+1); 
   ar_slid(1:slid_ar_order+1) = ar_stack{ar_entry(3)};
   
   %Estimation procedure and model order selection
   %----------------------------------------------
   
   for order = min_ma_order:max_ma_order
      if cand_order(req_counter)==order
         ar_corr = convolrev(ar_slid(1:slid_ar_order+1),order,ASAcontrol);
         ma = cov2arset(ar_corr,ASAcontrol);
         
         e = armafilter(sig,ma,1,filter(1,ma,pred_sig),pred_sig,ASAcontrol);
         res = e'*e/n_obs;
         gic3_temp = log(res)+3*(order+1)/n_obs;
         gic3(req_counter) = gic3_temp;
         if gic3_temp < gic3(sel_index)
           sel_index = req_counter;
           ma_sel = ma;
         end
         if ASAglob_mean_adj
            pe_est(req_counter) = res*(n_obs+order+1)/(n_obs-order-1);
         else
            pe_est(req_counter) = res*(n_obs+order)/(n_obs-order);
         end
         req_counter = req_counter+1;            
      end
      
      if slid_ar_order < max_slid_ar_order
         slid_ar_order = slid_ar_order+1;
         rc_temp = rc(slid_ar_order+1);
         ar_slid(2:slid_ar_order) = ar_slid(2:slid_ar_order)+rc_temp*ar_slid(slid_ar_order:-1:2);
         ar_slid(slid_ar_order+1) = rc_temp;
      end
      
      counter = counter+1;
   end
end

%Arranging output arguments
%--------------------------

ma = ma_sel;

if ~zero_incl
   gic3(1) = [];
   pe_est(1) = [];
   cand_order(1) =[];
end

if ~isempty(rc)
   ASAglob_rc = rc;
end

if nargout>1
   ASAsellog.funct_name = mfilename;
   ASAsellog.funct_version = ASAcontrol.is_version;
   ASAsellog.date_time = [datestr(ASAdate,8) 32 datestr(ASAdate,0)];
   ASAsellog.comp_time = etime(clock,ASAtime);
   ASAsellog.ma = ma_sel;
   ASAsellog.ar_sel = ar_stack{ar_entry(1)};
   ASAsellog.mean_adj = ASAglob_mean_adj;
   ASAsellog.cand_order = cand_order;
   ASAsellog.gic3 = gic3;
   ASAsellog.pe_est = pe_est;
end

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
% former versions        P.M.T. Broersen        p.m.t.broersen@tudelft.nl
% [2000 12 30 20 0 0]    W. Wunderink           wwunderink01@freeler.nl
