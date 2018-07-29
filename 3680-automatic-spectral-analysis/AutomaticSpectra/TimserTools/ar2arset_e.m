function [ar,rc,ASAcontrol] = ar2arset_e(varargin)
%AR2ARSET_E AR parameters to optimal lower-order AR models
%   [AR,RC] = AR2ARSET_E(AR) determines all lower-order 
%   reflectioncoefficients RC, corresponding to the AR-parameter vector 
%   AR, by applying a reversed Levinson-Durbin recursion.
%   
%   [SET_AR,SET_RC] = AR2ARSET_E(AR,REQ_ORDER) returns intermediate AR 
%   parameter vectors in the cell array SET_AR and an array SET_RC of 
%   reflectioncoefficients, both corresponding to orders requested by 
%   REQ_ORDER. REQ_ORDER must be either a row of ascending AR-orders, or 
%   a single AR-order.
%   
%   A parametervector in SET_AR of order LOWORDER represents an AR-model 
%   that gives the best description (in the sense of prediction) based on 
%   LOWORDER+1 autocovariances of the AR-model with parameter vector AR.
%   
%   AR2ARSET_E is an ARMASA main function.
%   
%   See also: RC2ARSET_E, COV2ARSET_E.

%   References: P. Stoica and R.L. Moses, Introduction to Spectral
%               Analysis, Prentice-Hall, Inc., New Jersey, 1997,
%               Chapter 3.

%Header
%=====================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
[ar,req_order,ASAcontrol]=ASAarg(varargin, ...
{'ar'       ;'req_order';'ASAcontrol'},...
{'isnumeric';'isnumeric';'isstruct'  },...
{'ar'                                },...
{'ar'       ;'req_order'             });

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
ASAcontrol.comp_version = [2000 11 1 12 0 0];

%Checks
%------

if ~isfield(ASAcontrol,'error_chk') | ASAcontrol.error_chk
   %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(ar)
      error(ASAerr(11,'ar'))
   end
   if ~isvector(ar)
      error(ASAerr(15,'ar'))
   elseif size(ar,1)>1
      ar = ar';
      warning(ASAwarn(25,{'column';'ar';'row'},ASAcontrol))         
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
   if ~isreal(ar)
      error(ASAerr(13))
   end
   if ar(1)~=1
      error(ASAerr(23,{'ar','parameter'}))
   end
   if ~isempty(req_order) & req_order(end) > length(ar)-1
      error(ASAerr(24,'AR parameters'))
   end
end

if ~isfield(ASAcontrol,'version_chk') | ASAcontrol.version_chk
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
    
%Recursion initialization
%------------------------  

%Assessment of the maximum model order
max_order = length(ar)-1;

%The last parameter equals the last
%reflectioncoefficient
rc(max_order+1) = ar(max_order+1);

if ~isempty(req_order) %Parameter vectors and 
      %reflectioncoefficients for requested orders
      %will be stored
   %Initialize the request counter
   counter = length(req_order);
   
   %Initialization of the storage stack
   if req_order(counter) == max_order
      ar_stack{counter,1} = ar;
      rc_stack(counter) = ar(end);
      counter = counter-1;
   end
else
   ar_stack = ar;
end

%Reversed Levinson Durbin recursion
%----------------------------------

for order = max_order-1:-1:0
   %The actual recursion
   inno_var = 1/(1-rc(order+2)^2);
   ar = inno_var*(ar-rc(order+2)*fliplr(ar));
   ar = ar(1:end-1);
   ar(1) = 1;
   rc(order+1) = ar(end);
   
   if ~isempty(req_order) %Storage could be necessary
      if gt(counter,0) & ...
            isequal(order,req_order(counter)) %Storage
            %is requested
         %Add the parameter vectors to their stacks
         ar_stack{counter,1} = ar;
         rc_stack(counter) = rc(order+1);
         counter = counter-1;
      end
   end
end

%Output argument arrangement
%---------------------------

if ~isempty(req_order) %Parameter vectors and 
      %reflectioncoefficients for requested orders
      %were stored
   %Assign the created stacks to the output
   ar = ar_stack;
   rc = rc_stack;
else %Only vectors of maximum orders have been stored
   %Return these vectors in arrays
   ar = ar_stack;
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
% former versions        P.M.T. Broersen        broersen@tn.tudelft.nl
% [2000 11  1 12 0 0]    W. Wunderink           wwunderink01@freeler.nl
% [2000 12 30 20 0 0]         ,,                          ,,
