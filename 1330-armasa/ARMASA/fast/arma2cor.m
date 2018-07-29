function [cor,gain,ASAcontrol]=arma2cor(ar,ma,n_shift,last)
%ARMA2COR ARMA parameters to autocorrelations
%   [COR,GAIN] = ARMA2COR(AR,MA) determines MAX(LENGTH(AR),LENGTH(MA)) 
%   elements of the right-sided autocorrelation function of the ARMA 
%   process, determined by the parameter vectors AR and MA. The results 
%   of this computation are the autocorrelations COR and the power gain 
%   of the ARMA process GAIN. For an ARMA process characterized by 
%   signals of observations X and random innovations E, the power gain is 
%   defined by VARIANCE(X)/VARIANCE(E).
%   
%   ARMA2COR(AR,MA,N_LAG) determines N_LAG lags of the right-sided 
%   autocorrelation function. If N_LAG exceeds the default number of 
%   determined elements (mentioned above), the sequence is extrapolated 
%   for the AR contributions.
%   
%   ARMA2COR is an ARMASA main function.
%   
%   See also: ARMA2PSD, COV2ARSET.

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
   if isa(ar,'struct'), ASAcontrol=ar; ar=[]; 
   else, error(ASAerr(39))
   end
   ar=[]; ma=[]; n_shift=[];
case 2 
   if isa(ma,'struct'), error(ASAerr(2,mfilename)) 
   end
   n_shift=[]; ASAcontrol=[];
case 3 
   if isa(n_shift,'struct'), ASAcontrol=n_shift; n_shift=[];
   else, ASAcontrol=[];
   end
case 4
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
ASAcontrol.is_version = [2001 3 9 12 0 0];
%and its compatability with versions down to,
ASAcontrol.comp_version = [2000 12 30 20 0 0];

%This function calls other functions of the ARMASA
%toolbox. The versions of these other functions must
%be greater than or equal to:
ASAcontrol.req_version.convolrev = [2000 12 6 12 17 20];
ASAcontrol.req_version.convol = [2000 12 6 12 17 20];
ASAcontrol.req_version.armafilter = [2000 12 12 14 0 0];

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
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
   if ~isempty(n_shift) & (~isnum(n_shift) | ...
         ~isintscalar(n_shift) | n_shift<0)
      error(ASAerr(17,'n_shift'))
   end
   
   %Input argument value checks
   if ~(isreal(ar) & isreal(ma))
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
   convolrev(ASAcontrol);
   armafilter(ASAcontrol);
end

if ~any(strcmp(fieldnames(ASAcontrol),'run')) | ASAcontrol.run
      %Run the computational kernel
   ASAcontrol.run = 1;
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 1;

%Main   
%==============================================================================
    
%Initializations
%---------------

%User adjustable:
%
%Set the allowed maximum number of parametervectors
%that are stored in a buffer. Limiting the buffer
%size prevents harddisk swapping. A greater buffer
%size results in a shorter processing time, as long
%as the computers RAM memory suffices.
buffer_size = 5000; %(required: buffer_size >=2)

ar_order = length(ar)-1;
ma_order = length(ma)-1;
if isempty(n_shift)
   n_shift = max(ar_order,ma_order);
end

if ma_order>0 & ar_order>0
   mode = 3;
elseif ma_order>0
   mode = 2;
elseif ar_order>0
   mode = 1;
else
   mode = 0;
end

%Dertermination of autocorrelations
%----------------------------------

%Determination of AR autocorrelations
if mode==1 | mode==3
   n_vv = n_shift+ma_order+1;
   n_par = ar_order+1;
   h_cor_vv = zeros(1,n_vv);
   h_cor_vv(1) = 1;
   ar_gain = 1;
   if n_par>1
      %Asess a protocol
      if (n_vv>buffer_size)&(n_par>buffer_size)
         n_store=buffer_size-1;
         n_temp=n_par-buffer_size;
         if n_vv>n_par
            n_continue=n_vv-n_par;
         else
            n_continue=0;
         end
      elseif n_vv>n_par
         n_store=n_par-1;
         n_temp=0;
         n_continue=n_vv-n_par;
      else
         n_store=n_vv-1;
         n_temp=n_par-n_vv;
         n_continue=0;
      end
      %Initializations
      n_store_h=n_store;
      lparmatrix=(n_store-1)*n_store/2+n_par-1;
      parmatrix=zeros(1,lparmatrix);
      temp1=zeros(1,n_par-1);
      temp2=zeros(1,n_vv-n_continue);
      pindex1=lparmatrix-n_par+2;
      pindex2=lparmatrix-1;
      pindex3=1;
      parmatrix(pindex1:lparmatrix)=ar(2:n_par);
      %Determine parameter vectors; do not store  
      while n_temp>0
         rc=parmatrix(pindex2+1);
         temp1(pindex3)=1-rc^2;
         parmatrix(pindex1:pindex2)=...
            (parmatrix(pindex1:pindex2)-...
            rc*parmatrix(pindex2:-1:pindex1))...
            /temp1(pindex3);
         pindex2=pindex2-1;
         pindex3=pindex3+1;
         n_temp=n_temp-1;
      end
      %Determine parameter vectors; store in a buffer  
      while n_store>1
         pindex4=pindex1-(n_par-pindex3-1);
         pindex5=pindex1-1;
         rc=parmatrix(pindex2+1);
         temp1(pindex3)=1-rc^2;
         parmatrix(pindex4:pindex5)=...
            (parmatrix(pindex1:pindex2)-...
            rc*parmatrix(pindex2:-1:pindex1))...
            /temp1(pindex3);
         pindex1=pindex4;
         pindex2=pindex5-1;
         pindex3=pindex3+1;
         n_store=n_store-1;
      end
      %Determine the AR power gain
      if nargout==2,
         if n_store_h>0
            rc=parmatrix(pindex2+1);
            temp1(pindex3)=1-rc^2;
         else
            pindex3=pindex3-1;
         end
         while pindex3>0
            ar_gain=ar_gain*temp1(pindex3);
            pindex3=pindex3-1;
         end
         ar_gain=1/ar_gain;
      end
      %Determine autocorrelations using stored parameter vectors
      pindex4=2;
      pindex6=2;
      pindex7=2;
      if n_store_h>0 %(n_vv>1 as well)
         h_cor_vv(2)=-parmatrix(1);
         while pindex4<n_store_h+1
            h_cor_vv(pindex4+1)=-parmatrix(pindex6:pindex7)*...
               h_cor_vv(pindex4:-1:2)'-parmatrix(pindex7+1);
            pindex6=pindex6+pindex4;
            pindex7=pindex6+pindex4-1;
            pindex4=pindex4+1;
         end
      end
      %Determine autocorrelations using reflectioncoefficients
      pindex7=pindex6;
      pindex6=pindex6-pindex4+1;
      pindex5=pindex7-pindex6;
      temp1(1:pindex5)=parmatrix(pindex6:pindex7-1);
      pindex6=pindex5+1;
      while pindex4<n_vv-n_continue
         temp2(1:pindex5)=parmatrix(pindex7)*temp1(pindex5:-1:1);
         temp1(1:pindex5)=temp1(1:pindex5)+temp2(1:pindex5);
         temp1(pindex6)=parmatrix(pindex7);
         h_cor_vv(pindex4+1)=...
            -temp1(1:pindex5)*h_cor_vv(pindex4:-1:2)'-temp1(pindex6);
         pindex4=pindex4+1;
         pindex5=pindex5+1;
         pindex6=pindex6+1;
         pindex7=pindex7+1;
      end
      %Extrapolate autocorrelations
      if n_continue>0
         h_cor_vv(n_par+1:n_par+n_continue)=...
            armafilter(zeros(n_continue,1),ar,1,h_cor_vv(1:n_par)',ASAcontrol);
      end
   end
end
%End of determination of AR autocorrelations

%Combining AR and MA autocorrelations
switch mode
case 0
   cor = [1 zeros(1,n_shift)];
   gain = 1;
case 1
   cor = h_cor_vv;
   gain = ar_gain;
case 2
   cov_xx = zeros(1,n_shift+1);
   cov_xx(1:min(n_shift+1,ma_order+1)) = ...
      convolrev(ma,min(n_shift,ma_order),ASAcontrol);
   ma_gain = cov_xx(1);
   cor = cov_xx/ma_gain;
   gain = ma_gain;
case 3
   index1 = ma_order-n_shift+1;
   index2 = ma_order+n_shift+1;
   l_ma = ma_order+1;
   bbm = convolrev(ma,ASAcontrol);
   temp = convol(bbm,h_cor_vv,max(1,index1),index2,ASAcontrol);
   center_corr = max(0,index1-1);
   temp(l_ma-center_corr:end);
   temp(l_ma-center_corr:-1:1);
   bbm(l_ma:min(index2,ma_order+l_ma));
   cov_xx = temp(l_ma-center_corr:end);
   cov_xx(1:min(l_ma,n_shift+1)) = cov_xx(1:min(l_ma,n_shift+1))+...
      temp(l_ma-center_corr:-1:1)-bbm(l_ma:min(index2,ma_order+l_ma));
   ma_gain = cov_xx(1);
   cor = cov_xx/ma_gain;
   gain = ar_gain*ma_gain;
end

%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   cor = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%================================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% former versions        P.M.T. Broersen        p.m.t.broersen@tudelft.nl
%                        S. de Waele            
% [2000 12 30 20 0 0]    W. Wunderink           
% [2001  3  9 12 0 0]          ,,               
