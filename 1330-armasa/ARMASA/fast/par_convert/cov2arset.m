function [ar,rc,ASAcontrol] = cov2arset(cov,req_order,last)
%COV2ARSET AR autocovariances to AR models
%   [AR,RC] = COV2ARSET(COV) converts autocovariances COV into an AR-
%   model of order LENGTH(COV)-1, with parameter vector AR and 
%   reflectioncoefficients RC. The procedure solves the set of Yule-
%   Walker equations, by applying the Levinson-Durbin recursion.
%   
%   [SET_AR,SET_RC] = COV2ARSET(COV,REQ_ORDER) returns intermediate AR 
%   parameter vectors in the cell array SET_AR and an array SET_RC of 
%   reflectioncoefficients, both corresponding to orders requested by 
%   REQ_ORDER. REQ_ORDER must be either a row of ascending AR-orders, or 
%   a single AR-order.
%   
%   COV2ARSET is an ARMASA main function.
%   
%   See also: RC2ARSET, AR2ARSET.

%   References: P. Stoica and R.L. Moses, Introduction to Spectral
%               Analysis, Prentice-Hall, Inc., New Jersey, 1997,
%               Chapter 3.

%Header
%=====================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(cov,'struct'), ASAcontrol=cov; cov=[];
   else, ASAcontrol=[];
   end
   req_order=[];
case 2 
   if isa(req_order,'struct'), ASAcontrol=req_order; req_order=[]; 
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
   if ~isnum(cov)
      error(ASAerr(11,'cov'))
   end
   if ~isavector(cov)
      error(ASAerr(15,'cov'))
   elseif size(cov,1)>1
      cov = cov';
      warning(ASAwarn(25,{'column';'cov';'row'},ASAcontrol))         
   end
   if ~isempty(req_order)
      if ~isnum(req_order) | ~isintvector(req_order) |...
            req_order(1)<0 | ~isascending(req_order)
         error(ASAerr(12,{'requested';'req_order'}))
      elseif size(req_order,1)>1
         req_order = req_order';
         warning(ASAwarn(25,{'column';'req_order';'row'},ASAcontrol))
      end
   end
   
   %Input argument value checks
   if ~isreal(cov)
      error(ASAerr(13))
   end
   if ~isempty(req_order) & req_order(end) > length(cov)-1
      error(ASAerr(24,'autocovariances'))
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
    
%Recursion initialization
%------------------------  

l_cov = length(cov);
max_k = l_cov;
ar = zeros(1,l_cov);
ar(1) = 1;
rc = zeros(1,l_cov);
rc(1) = 1;
var = cov(1);
inno_var = zeros(l_cov,1);
inno_var(1) = var;
store = ~isempty(req_order);
if store
   counter = 1;
   max_counter = length(req_order);
   max_k = req_order(max_counter)+1;
   ar_stack = cell(max_counter,1);
   rc_stack = zeros(1,max_counter);
   if req_order(1)==0
      ar_stack{1} = 1;
      rc_stack(1) = 1;
      counter = counter+1;
   end
end

%Integral Levinson Durbin recursion
%----------------------------------

for k = 2:max_k
   order = k-1;
   inno_var_temp = inno_var(order);
   rc_temp = -(cov(2:k)*ar(k-1:-1:1)')/inno_var_temp;
   rc(k) = rc_temp;
   inno_var(k) = inno_var_temp*(1-rc_temp^2);
   ar(2:order) = ar(2:order)+rc_temp*ar(order:-1:2);
   ar(k) = rc_temp;
   if store & k==req_order(counter)+1
      ar_stack{counter} = ar(1:k);
      rc_stack(counter) = rc_temp;
      counter = counter+1;
   end
end

%Output argument arrangement
%---------------------------

if store
   ar = ar_stack;
   rc = rc_stack;
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
