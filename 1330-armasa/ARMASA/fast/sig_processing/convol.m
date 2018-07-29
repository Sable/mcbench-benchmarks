function [z,ASAcontrol] = convol(x,y,shift1,shift2,last)
%CONVOL Convolution sum
%   Z = CONVOL(X,Y) is the convolution sum of two vectors X and Y. 
%   
%   CONVOL(X) is the auto-convolution sum of a vector X. 
%   
%   CONVOL(X,Y,SHIFT1,SHIFT2) or CONVOL(X,SHIFT1,SHIFT2) returns only the 
%   elements from SHIFT1 up to SHIFT2.
%   
%   CONVOL is an ARMASA main function.
%   
%   See also: CONVOLREV, DECONVOL, CONV.

%Header
%=============================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
switch nargin
case 1 
   if isa(x,'struct'), ASAcontrol=x; x=[]; 
   else, ASAcontrol=[];
   end
   y=[]; shift1=[]; shift2=[];
case 2 
   if isa(y,'struct'), ASAcontrol=y; y=[]; 
   else, ASAcontrol=[]; 
   end
   shift1=[]; shift2=[];
case 3 
   if isa(shift1,'struct'), ASAcontrol=shift1; shift1=[]; shift2=[];
   else, ASAcontrol=[]; shift2=shift1; shift1=y; y=[];
   end
case 4
   if isa(shift2,'struct'), ASAcontrol=shift2; shift2=shift1; shift1=y; y=[];
   else, ASAcontrol=[];
   end
case 5
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
ASAcontrol.is_version = [2000 12 6 12 17 20];
%and its compatability with versions down to,
ASAcontrol.comp_version = [2000 12 4 15 0 0];

%Checks
%------

if ~any(strcmp(fieldnames(ASAcontrol),'error_chk')) | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(x)
      error(ASAerr(11,'x'))
   end
   if ~isempty(y) & ~isnum(y)
      error(ASAerr(11,'y'))
   end
   if ~isempty(shift1) & (~isnum(shift1) | ...
         ~isintscalar(shift1) | shift1<0)
      error(ASAerr(17,'shift1'))
   end
   if ~isempty(shift2) & (~isnum(shift2) | ...
         ~isintscalar(shift2) | shift2<0)
      error(ASAerr(17,'shift2'))
   end
   
   %Input argument value checks
   if ~isavector(x)
      error([ASAerr(14) ASAerr(15,'x')])
   else
      l_x = length(x);
      l_y = length(x);
   end
   if ~isempty(y)
      if ~isavector(y)
         error([ASAerr(14) ASAerr(15,'y')])
      end
      l_y = length(y);
   end
   if ~(isempty(shift1) & isempty(shift2)) & ...
         (shift1 > shift2 | shift2 > l_x+l_y-1 | ...
         shift1==0)
      error(ASAerr(20,{'shift1','shift2'}))
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
%========================================================================

s_x = size(x);
l_x = prod(s_x);
if isempty(y)
   s_y = s_x;
   l_y = l_x;
else
   s_y = size(y);
   l_y = prod(s_y);
end
if l_x>l_y
   l_long = l_x;
   l_short = l_y;
else
   l_long = l_y;
   l_short = l_x;
end
if isempty(shift1)
   shift1 = 1;
   shift2 = l_long+l_short-1;
end
if s_x(1)==1 & s_y(1)==1
   z = zeros(1,shift2-shift1+1);
else
   z = zeros(shift2-shift1+1,1);
end

%Determination of the fastest approach
if l_long<81
   mode=2;
else
   if isempty(y)
      l_fft = nxtppow(l_long+1+max(shift2-l_long,l_long-shift1));
      t_fft = 14.6*l_fft*log(l_fft)+6*l_fft;
      thresh = min(l_long,shift2);
      t_direct = thresh^2-shift1^2+thresh+shift1;
      if shift2>thresh
         t_direct = t_direct+4*l_long*shift2-shift2^2-3*l_long^2;
      end
      if t_fft<t_direct
         mode = 3;
      else
         mode = 1;
      end
   else
      t_direct = 0;
      start = shift1;
      if shift1<l_short
         thresh = min(l_short,shift2);
         t_direct = thresh^2-shift1^2;
         start = l_short;
      end
      if start>=l_short
         thresh = min(l_long,shift2);
         t_direct = t_direct+2*l_short*max(0,(thresh-l_short));
      end
      if shift2>l_long
         t_direct = t_direct+2*l_short*(shift2-l_long)-(shift2-l_long)^2;
      end
      if shift1<l_short
         l_eff = shift2;
      else
         l_eff = shift2-shift1+l_short;  
      end
      t_filt = 0.6*l_eff*l_short+1.2*l_short^2;
      l_fft = nxtppow(l_long+l_short);
      t_fft = 14.6*l_fft*log(l_fft)+6*l_fft;
      [mode,index] = sort([t_direct t_filt t_fft]);
      mode = index(1);
   end
end

if mode==1 %Direct approach,
           %minimized number of flops
  if isempty(y)
     y = x;
  end   
  if l_x>=l_y
      if s_x(2)>1
         long = x;
      else
         long = x';
      end
      if s_y(2)>1;
         short = y(l_y:-1:1)';
      else
         short = y(l_y:-1:1);
      end
      first = shift1;
      last = shift2;
      k = 1;
      k_increm = 1;
   else
      if s_x(2)>1
         short = x';
      else
         short = x;
      end
      if s_y(2)>1;
         long = y(l_y:-1:1);
      else
         long = y(l_y:-1:1)';
      end
      first = l_x+l_y-shift2;
      last = l_x+l_y-shift1;
      k = last-first+1;
      k_increm = -1;
   end
   start = first;
   run_in = l_short-first;
   if run_in>0
      index_temp = run_in+1;
      i_stop = min(last-first,run_in-1);
      for i = 0:i_stop
         z(k) = long(1:first+i)*short(index_temp-i:l_short);
         k = k+k_increm;
      end
      start = l_short;
   end
   run_center = start-l_short;
   if run_center>=0
      if last<=l_long
         stop = last;
      else
         stop = l_long;
      end
      index_temp = run_center+1;
      i_stop = stop-start;
      for i=0:i_stop
         z(k) = long(index_temp+i:start+i)*short;
         k = k+k_increm;
      end
   end
   run_out = last-l_long;
   if run_out>0
      index_temp = l_long-l_short+1;
      i_start = max(1,first-l_long);
      for i = i_start:run_out
         z(k) = long(index_temp+i:l_long)*short(1:l_short-i);
         k = k+k_increm;
      end
   end
elseif mode==2 %Filter approach,
               %non-optimal in the sense of flops but sometimes
               %faster because 'filter' is a built-in function
   if isempty(y)
      y = x;
   end   
   if l_x>l_y
      if s_x(1)==1 & s_y(1)==1
         long = zeros(1,l_x+l_y-1);
         long(1:l_x) = x;
      else
         long = zeros(l_x+l_y-1,1);
         long(1:l_x) = x;
      end
      short = y;
   else
      if s_x(1)==1 & s_y(1)==1
         long = zeros(1,l_x+l_y-1);
         long(1:l_y) = y;
      else
         long = zeros(l_x+l_y-1,1);
         long(1:l_y) = y;
      end
      short = x;
   end
   first = shift1;
   last = shift2;
   if first-l_short>0
      start = first-l_short+1;
      first = l_short;
   else
      start = 1;
   end
   stop = last;
   z = filter(short,1,long(start:stop));
   z = z(first:end);
elseif mode==3 %FFT approach,
               %fast for long sequences
   if ~isempty(y) %cross-convolution
      first = shift1;
      last = shift2;
      run_in = l_short-first;
      if run_in<0
         start = 1-run_in;
         first = l_short;
      else
         start = 1;
      end
      if last<l_long
         stop = last;
      else
         stop = l_long;
      end
      first = first+1;
      last = last-start+2;
      l_long = stop-start+1;
      sig_mtx = zeros(l_fft,2);
      if l_x>l_y
         x = x(stop:-1:start);
         sig_mtx(l_fft-l_long+1:l_fft,1) = x(:);
         sig_mtx(1:l_y,2) = y(:);
      else
         y = y(stop:-1:start);
         sig_mtx(1:l_x,2) = x(:);
         sig_mtx(l_fft-l_long+1:l_fft,1,1) = y(:);
      end
      transf_mtx = fft(sig_mtx);
      z = real(fft(transf_mtx(:,1).*conj(transf_mtx(:,2))));
      if s_x(1)==1 & s_y(1)==1
         z = z(first:last)'/l_fft;
      else
         z = z(first:last)/l_fft;
      end
   else %auto-convolution
      l_sig = l_x;
      first = shift1+1;
      last = shift2+1;
      sig_mtx = zeros(l_fft,2);
      sig_mtx(1:l_x,2) = x(:);
      x = x(l_x:-1:1);
      sig_mtx(l_fft-l_x+1:l_fft,1) = x(:);
      transf_mtx = fft(sig_mtx);
      z = real(fft(transf_mtx(:,1).*conj(transf_mtx(:,2))));
      if s_x(1)==1 & s_y(1)==1
         z = z(first:last)'/l_fft;
      else
         z = z(first:last)/l_fft;
      end
   end
end

%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   z = ASAcontrol;
   ASAcontrol = [];
end

%Program history
%======================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% [2000 12 4 15  0  0]   W. Wunderink           wwunderink01@freeler.nl
% [2000 12 6 12 17 20]   W. Wunderink           wwunderink01@freeler.nl
