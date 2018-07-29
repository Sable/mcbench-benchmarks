function [cic,pe_est] = cic(varargin)
%CIC_S Finite sample order selection criterion for segments
%   C = CIC_S(RES,N_OBS) is a transformation of the vector of estimated 
%   residualvariances RES, obtained from a recursive-in-order AR 
%   estimation procedure (Burg type assumed), applied to a signal segment 
%   of N_OBS observations. RES must contain all residual variance 
%   estimates corresponding to orders 0 up to a maximum order of 
%   estimation. In this case, the location of the minimum of the 
%   criterion function CIC in vector C is the optimal order plus 1.
%   For example, if [DUMMY,LOCATION] = MIN(CIC(RES,N_OBS)), then 
%   SEL_ORDER = LOCATION-1.
%
%   Difference with CIC: N_OBS can also be a vector containing the lengths
%   of segments of data.
%   
%   C = CIC_S(RES,N_OBS,CAND_ORDER) evaluates the criterion function at 
%   candidate orders CAND_ORDER only, and fills C with these values. 
%   CAND_ORDER must be either a row of ascending orders, or a single 
%   order.
%
%   CIC_S is an ARMASA_RS main function.
%   
%   See also: CIC, SIG2AR, DATA_SEGMENTS.

%Header
%==========================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
[res,n_obs,cand_order,ASAcontrol] = ASAarg(varargin, ...
{'res'      ;'n_obs'    ;'cand_order';'ASAcontrol'}, ...
{'isnumeric';'isnumeric';'isnumeric' ;'isstruct'  }, ...
{'res'      ;'n_obs'                              }, ...
{'res'      ;'n_obs'    ;'cand_order'             });

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
ASAcontrol.comp_version = [2000 11 1 12 0 0];

%Checks
%------

if ~isfield(ASAcontrol,'error_chk') | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(res)
      error(ASAerr(11,'res'))
   end
   if ~isnum(n_obs) | n_obs<0
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
   if ~isvector(res)
      error(ASAerr(15,'res'))
   end
   if max(cand_order) > length(res)-1
      error(ASAerr(27,{'cand_order';'res'}))
   end
   if length(res) > max(n_obs)
      error(ASAerr(26,{'res';'n_obs'}))
   end
end

if ~isfield(ASAcontrol,'version_chk') | ...
      ASAcontrol.version_chk
      %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
end

if ~isfield(ASAcontrol,'run') | ASAcontrol.run
   ASAcontrol.run = 1;
end

if ASAcontrol.run %Run the computational kernel   

%Main   
%=====================================================
  
%Initialization of variables
%---------------------------

s_res = size(res);
if s_res(1)>1
      %Transpose the input column 'res' to a row
   res = res';
end

n_obs_tot = sum(n_obs);

%Determination of the order selection criterion
%----------------------------------------------

%Asess the parameter estimation procedure used to
%obtain the residual variance estimates
if isempty(ASAglob_ar_est_method)
   %Assume by default, the Burg-estimator is applied
   ASAglob_ar_est_method = 'burg';
end
est_method = ASAglob_ar_est_method;

%The variance of the zero-order model parameter
%depends on the subtraction of the signal mean
if isequal(ASAglob_mean_adj,1) | ...
      isempty(ASAglob_mean_adj)
   v0 = 1/n_obs_tot;
else
   v0 = 0;
end

%Determine the variance of reflectioncoefficients in
%white noise
max_order = length(res)-1;
i = 1:max_order;
switch lower(est_method)
case 'burg'
% vi coefficients for order selection with Burg method
vi = v0;   
if all(n_obs == n_obs(1)),
    %Segments of equal length
    i = 1:max_order;
    n_seg = length(n_obs);
    vi(i+1) = 1./(n_obs_tot-n_seg*i+1);
else
    %Segments of unequal length
    for o = 1:max_order,
        vi(o+1) = 1/( sum(max(n_obs-o,0))+1 );   
    end %for o = 1:L,
end
otherwise
   error(['Estimation method ''' est_method ...
         ''' not supported']);
end

%Determine the criteria from their composing elements
fic_tail = 3*cumsum(vi);
fsic_tail = cumprod((1+vi)./(1-vi))-1;
cic_tail = max(fic_tail,fsic_tail);
cic = log(res)+cic_tail;
pe_est = res.*(fsic_tail+1);

%Arranging output arguments
%--------------------------

%Reduce the arrays computed above, to keep the
%elements associated with requested candidate orders
%only
if ~isempty(cand_order)
   cic = cic(cand_order+1);
   pe_est = pe_est(cand_order+1);
end

if s_res(1)>1 %Input argument 'res' has been a column
   %Transpose the output rows to columns
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
% former versions        P.M.T. Broersen        broersen@tn.tudelft.nl
% [2000 11  1 12 0 0]    W. Wunderink           wwunderink01@freeler.nl
% [2000 12 30 20 0 0]         ,,                          ,,
%                        S. de Waele            stijn.de.waele@philips.com