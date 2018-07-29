function [x,ASAcontrol] = armafilter(e,ar,ma,x_ini,e_ini,last)
%ARMAFILTER Digital filter with ARMA filter coefficients
%   X = ARMAFILTER(E,AR,MA) filters the data in vector E with a filter 
%   described by an ARMA model with parameter vectors AR and MA, to create 
%   the filtered data X. It implements the difference equation,
%   
%     x(n) = - a1*x(n-1) - ... - ap*x(n-p)
%     + e(n) + b1*e(n-1) + ... + bq*e(n-q)
%   
%   with the data to be filtered given by E = [e(n) , ... ,e(N)] leading 
%   to the output X = [x(n) , ... , x(N)]. The ARMA parameter vectors are  
%   AR = [1 , a1 , ... , ap] and MA = [1 , b1 , ... , bq].
%   
%   ARMAFILTER(E,AR,MA,X_INI,E_INI) is used to provide the filter with 
%   initial values from past output X_INI = [x(n-p) , ... , x(n-1)], and 
%   past input E_INI = [e(n-q) , ... , e(n-1)].
%   Excessive elements are ignored. 
%   
%   When X_INI or both X_INI and E_INI are omitted, left empty, or filled 
%   with an insufficient number of elements, zeros are substituted for the 
%   missing elements.
%   
%   ARMAFILTER is an ARMASA main function.
%   
%   See also: FILTER

%Header
%==============================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(e,'struct'), ASAcontrol=e; e=[]; 
   else, error(ASAerr(39))
   end
   ar=[]; ma=[]; x_ini=[]; e_ini=[];
case 3 
   x_ini=[]; e_ini=[]; ASAcontrol=[];
case 4
   if isa(x_ini,'struct'), ASAcontrol=x_ini; x_ini=[];
   else, ASAcontrol=[];
   end
   e_ini=[]; 
case 5
   if isa(e_ini,'struct'), ASAcontrol=e_ini; e_ini=[];
   else, ASAcontrol=[];
   end
case 6
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
ASAcontrol.is_version = [2000 12 12 14 0 0];
%and its compatability with versions down to,
ASAcontrol.comp_version = [2000 12 12 14 0 0];

%This function calls other functions of the ARMASA
%toolbox. The versions of these other functions must
%be greater than or equal to:
ASAcontrol.req_version.convol = [2000 12 4 15 0 0];
ASAcontrol.req_version.deconvol = [2000 12 11 12 0 0];

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
   %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(e)
      error(ASAerr(11,'e'))
   elseif ~isavector(e)
      error([ASAerr(14) ASAerr(15,'e')])
   elseif size(e,2)>1
      e = e(:);
      warning(ASAwarn(25,{'row';'e';'column'},ASAcontrol))
   end
   if ~isnum(ar)
      error(ASAerr(11,'ar'))
   elseif ~isavector(ar)
      error(ASAerr(15,'ar'))
   elseif size(ar,1)>1
      ar = ar';
      warning(ASAwarn(25,{'column';'ar';'row'},ASAcontrol))         
   end
   if ~isnum(ma)
      error(ASAerr(11,'ma'))
   elseif ~isavector(ma)
      error(ASAerr(15,'ma'))
   elseif size(ma,1)>1
      ma = ma';
      warning(ASAwarn(25,{'column';'ma';'row'},ASAcontrol))         
   end
   if ~isempty(e_ini)
      if ~isnum(e_ini)
         error(ASAerr(11,'e_ini'))
      elseif ~isavector(e_ini)
         error([ASAerr(14) ASAerr(15,'e_ini')])
      elseif size(e_ini,2)>1
         e_ini = e_ini(:);
         warning(ASAwarn(25,{'row';'e_ini';'column'},ASAcontrol))
      end
   end
   if ~isempty(x_ini)
      if ~isnum(x_ini)
         error(ASAerr(11,'x_ini'))
      elseif ~isavector(x_ini)
         error([ASAerr(14) ASAerr(15,'x_ini')])
      elseif size(x_ini,2)>1
         x_ini = x_ini(:);
         warning(ASAwarn(25,{'row';'x_ini';'column'},ASAcontrol))
      end
   end
   
   %Input argument value checks
   if ~(isreal(e) & isreal(ar) & isreal(ma)) | ...
         (~isempty(e_ini) & ~isreal(e_ini)) | ...
         (~isempty(x_ini) & ~isreal(x_ini))
      error(ASAerr(13))
   end
   if ar(1)~=1
      error(ASAerr(23,{'ar','parameter'}))
   end
   if ma(1)~=1
      error(ASAerr(23,{'ma','parameter'}))
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
   convol(ASAcontrol);
   deconvol(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
   %Run the computational kernel
   ASAcontrol.run = 1;
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;
   
%Main   
%================================================================================
    
l_e = length(e);
ar_order = length(ar)-1;
ma_order = length(ma)-1;
l_x_ini = length(x_ini);
l_e_ini = length(e_ini);

if ma_order>0
   l_e_ini = min(ma_order,l_e_ini);
   e_ini = e_ini(end-l_e_ini+1:end);
   v = convol([e_ini;e],ma,l_e_ini+1,ma_order+l_e+l_e_ini,ASAcontrol);
else
   v = e;
end

if ar_order>0
   l_x_ini=min(ar_order,l_x_ini);
   x_ini=x_ini(end-l_x_ini+1:end);
   v_ini=convol(ar,x_ini,1,l_x_ini,ASAcontrol);
   %x = deconvol([v_ini;v;zeros(ar_order,1)],ar,l_x_ini+1,l_x_ini+l_e,ASAcontrol);
   v_ext = [v_ini;v];
   x = filter(1,ar,v_ext(1:l_x_ini+l_e));
   x = x(l_x_ini+1:end);
else
   x = v(1:l_e);
end


%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   x = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 12 14 0 0]    W. Wunderink           wwunderink01@freeler.nl
