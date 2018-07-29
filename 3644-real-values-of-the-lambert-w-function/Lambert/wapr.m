% Real values of the Lambert W function
%
% Syntax:
% [w,nerror] = wapr(x,nb,l,m);
%
% The W function has two real branches, Wp, the upper branch, and
% Wm, the lower branch.
%
% Default usage: wapr(x) returns values for the upper branch of W.
%
% w is the value (scalar or vector) of W calculated
%
% nerror is the output error flag:
% nerror = 0 -> routine completed successfully
% nerror = 1 -> x is out of range
% Note: wapr will terminate if arguments are not within range. That
% is, nerror will be the same length as the vector x (arguments for
% which W function values are to be returned) only if all the values
% are within the valid range of arguments (see below).
%
% x - argument (assumed real) of W(x); vector or scalar.
% For a vector of arguments, wapr returns a vector w of results.
% Note that for a vector of arguments, each argument is assumed to
% refer to the same branch of the W function.
%
% nb (scalar) is the branch of the W function for which results are
% desired:
% nb = 0 - upper branch, Wp (default)
% nb ~= 0 - lower branch, Wm
%
% l - determines how wapr is to treat the argument x:
% l = 1 -> x is the positive offset from -exp(-1), so compute
% W(x-exp(-1))
% l ~= 1 -> x is the desired x, so compute W(x) (default)
% Further discussion on this point is included below.
%
% m - print messages from wapr?
% m = 1 -> Yes
% m ~= 1 -> No (default)
%
% Range: -exp(-1) <= x for the upper branch of the W function;
% -exp(-1) <= x < 0 for the lower branch of the W function.
%
% Users of wapr will usually want to calculate W(x) for specified
% values of x. However, if W(x) is to be evaluated near x = -exp(-1)
% there is a difficulty in specifying x due to roundoff. For
% example, if wapr is being used in single precision (usually a
% 7-digit mantissa) and W(-exp(-1)+1/10^10) is to be evaluated then
% it is not possible to enter the required x value. However, Wp(x),
% for example, will be affected because Wp ~ -1 +
% (2*exp(1)/10^10)^(1/2). Thus, the 1/10^10 increment to x at x =
% -exp(-1) increments W by about 2/10^5. For this reason wapr is
% used in either of two ways. First, x is specified and W(x) is
% returned. Alternatively, x is specified by its offset (delta_x)
% from -exp(-1), i.e., delta_x = x + exp(-1). In this case
% W(-exp(-1)+delta_x) is returned. Note that in the latter case it
% is not necessary for delta_x to be small.
%
% Note: Matlab installations with the Symbolic Math Toolbox have direct
% access to Maple's LambertW function (lambertw).
%
function [w,nerror] = wapr(x,varargin)
%
% Approximating the W function
% ____________________________
%
% wapr is the Matlab version of Algorithm 743 (written in
% FORTRAN), Collected Algorithms from ACM.
% Web reference: http://www.netlib.org/toms/743
%
% D. A. Barry, 23 June 2003 (d.a.barry@ed.ac.uk)
%
% Archival journal references:
%
% Barry, D. A., P. J. Culligan-Hensley, and S. J. Barry. 1995.
% Real values of the W-function. Association of Computing
% Machinery Transactions on Mathematical Software. 21(2): 161-171.
%
% Barry, D. A., S. J. Barry, and P. J. Culligan-Hensley. 1995.
% Algorithm 743: WAPR: A FORTRAN routine for calculating real
% values of the W-function. Association of Computing Machinery
% Transactions on Mathematical Software. 21(2): 172-181.
% __________________________________________________________________
%
% In varargin, only the first 3 elements are used. These are:
%
if length(varargin) > 0
   if length(varargin) == 1
      nb=varargin{1};
      l=0;
      m=0;
   elseif length(varargin) == 2
      nb=varargin{1};
      l=varargin{2};
      m=0;
   elseif length(varargin) >= 3
      nb=varargin{1};
      l=varargin{2};
      m=varargin{3};
   end
else
%
%  Default values of nb, l and m
%
   nb=0;
   l=0;
   m=0;
end
%
% Only consider real arguments
%
if imag(x) ~= 0
   if m == 1
      fprintf(1,'\r%s\r','Complex arguments not supported');
   end
   return      
end

% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%
% nbits is the number of bits (less 1) in the mantissa of the
% floating point number number representation of your machine.
% It is used to determine the level of accuracy to which the W
% function should be calculated.
%
% Most machines use a 24-bit matissa for single precision and
% 53-56 bits for double precision. The IEEE standard is 53
% bits. The Fujitsu VP2200 uses 56 bits. Long word length
% machines vary, e.g., the Cray X/MP has a 48-bit mantissa for
% single precision.
%
% Matlab uses the IEEE standard mantissa of 53 bits, thus nbits
% is set to 52. Uses can check this result by running the following
% section of code, although this is only necessary if Matlab departs
% from the IEEE standard.
%v=10;
%i=0;
%while v > 1
%   i=i+1;
%   b=2^(-i);
%   v=1+b;
%end
%nbits=i-1;
%j=-log10(b);
%if m == 1
%   fprintf(1,'\r%s%3.0f%s\r%s%3.0f%s\r',' nbits is',nbits,'.',' Expect',j,' significant digits from wapr.')
%end
%
nbits=52;
niter=1;
%
% The above 2 values (nbits and niter) should not need to change while Matlab uses
% the IEEE standard described above.
%
% Various constants
%
em=-exp(-1);
em9=-exp(-9);
c13=1/3;
c23=2*c13;
em2=2/em;
e12=-em2;
tb=.5^nbits;
tb2=sqrt(tb);
x0=tb^(1/6)/2;
x1=(1-17*tb^(2/7))*em;
an3=8/3;
an4=135/83;
an5=166/39;
an6=3167/3549;
s2=sqrt(2);
s21=2*s2-3;
s22=4-3*s2;
s23=s2-2;
%
% Calculate W for each element in the argument vector x
%
for lx=1:length(x)
   wflag=0;
   itflag=0;
   nerror(lx)=0;
   if l == 1
      delx=x(lx);
      if delx < 0
         if m == 1
            fprintf(1,'%s%3.0f\r',' For argument number',lx);
            fprintf(1,'%s\r',' Warning: the offset x is negative (it must be > 0)');
            fprintf(1,'%s\r',' Stopping calculations');
         end
         nerror(lx)=1;
         return
      end
      xx=x(lx)+em;
      if e12*delx < tb^2 & m == 1
         fprintf(1,'%s%3.0f\r',' For argument number',lx);
         fprintf(1,'%s%16.8f\r%s\r',' Warning: For this offset (',delx,'),',' W is negligibly different from -1');
      end
   else
      if x(lx) < em
         if m == 1
            fprintf(1,'%s%3.0f\r',' For argument number',lx);
            fprintf(1,'%s\r',' Warning: the argument x is less than -exp(-1) (it must be greater than or equal to this)');
            fprintf(1,'%s\r',' Stopping calculations');
         end
         nerror(lx)=1;
         return
      elseif x(lx) == em
         w(lx)=-1;
         wflag=1;
      end
      xx=x(lx);
      delx=xx-em;
      if delx < tb2 & m == 1 & x(lx) ~= em
         fprintf(1,'%s%3.0f\r',' For argument number',lx);
         fprintf(1,'\r%s%10.8f%s\r%s\r',' Warning: x (= ',xx,') is close to -exp(-1).',' Enter x as an offset to -exp(-1) for greater accuracy');
      end
   end
   if wflag == 0
      if nb == 0
%
%        Calculations for Wp
%
         if abs(xx) <= x0
            w(lx)=xx/(1+xx/(1+xx/(2+xx/(.6+.34*xx))));
            itflag=1;
         elseif xx <= x1
            reta=sqrt(e12*delx);
            w(lx)=reta/(1+reta/(3+reta/(reta/(an4+reta/(reta*an6+an5))+an3)))-1;
            itflag=1;
         elseif xx <= 20
            reta=s2*sqrt(1-xx/em);
            an2=4.612634277343749*sqrt(sqrt(reta+1.09556884765625));
            w(lx)=reta/(1+reta/(3+(s21*an2+s22)*reta/(s23*(an2+reta))))-1;
         else
            zl=log(xx);
            w(lx)=log(xx/log(xx/zl^exp(-1.124491989777808/(.4225028202459761+zl))));
         end
      else
%
%        Calculations for Wm
%
         if xx >= 0
            if m == 1
               fprintf(1,'%s%3.0f\r',' For argument number',lx);
               fprintf(1,'%s\r',' Warning: the argument x is greater than 0 (it must be less than or equal to this)');
               fprintf(1,'%s\r',' Stopping calculations');
            end
            nerror(lx)=1;
            return
         elseif xx <= x1
            reta=sqrt(e12*delx);
            w(lx)=reta/(reta/(3+reta/(reta/(an4+reta/(reta*an6-an5))-an3))-1)-1;
            itflag=1;
         elseif xx <= em9
            zl=log(-xx);
            t=-1-zl;
            ts=sqrt(t);
            w(lx)=zl-(2*ts)/(s2+(c13-t/(270+ts*127.0471381349219))*ts);
         else
            zl=log(-xx);
            eta=2-em2*xx;
            w(lx)=log(xx/log(-xx/((1-.5073921323068457*(zl+1))*(sqrt(eta)+eta/3)+1)));
         end
      end
      if itflag == 0
         for i=1:niter
            zn=log(xx/w(lx))-w(lx);
            temp=1+w(lx);
            temp2=temp+c23*zn;
            temp2=2*temp*temp2;
            w(lx)=w(lx)*(1+(zn/temp)*(temp2-zn)/(temp2-2*zn));
         end
      end
   end
end
%
% End of wapr
% __________________________________________________________________