% bisect is a function which determines values of
% W(x) using the bisection method. It is used only as a check on
% the accuracy of wapr.m. This routine is not used directly,
% rather it is called by wapr_test.m
%
% Syntax:
% [b,ner]=bisect(xx,nb,l)
%
% b is the value of W(xx) computed
%
% ner is the error condition for the bisection routine
% ner = 0 - routine completed successfully
% ner = 1 - routine did not converge
%
% xx is the argument, W(xx)
%
% nb is the branch of the W function needed:
% nb = 0 - upper branch, Wp
% nb <> 0 - lower branch, Wm
%
% l - indicates if xx is offset from -exp(-1)
% l = 1, Yes, it is offset
% l <> 1, No, true xx is entered
%
function  [b,ner]=bisect(xx,nb,l)
%
% The parameter tol, which determines the accuracy of the bisection
% method, is calculated using nbits (assuming the final bit is lost
% due to rounding error).
%
% no is the maximum number of iterations used in the bisection
% method.
%
% For xx close to 0 for Wp, the exponential approximation is used.
% The approximation is exact to O(xx^8) so, depending on the value
% of nbits, the range of application of this formula varies. Outside
% this range, the usual bisection method is used.
%
% Initial estimates of W for the bisection method solution are given
% by crude.m
%
% D. A. Barry, 23 June 2003 (d.a.barry@ed.ac.uk)
%
nbits=52;
no=500;
ner=0;
if l == 1
   x=xx-exp(-1);
else
   x=xx;
end
if nb == 0
   if abs(x) < 1/(2^nbits)^(1/7)
      b=x*exp(-x*exp(-x*exp(-x*exp(-x*exp(-x*exp(-x))))));
      return
   else
      u=crude(x,nb)+1e-3;
      tol=abs(u)/2^nbits;
      d=max(u-2e-3,-1);
      for i=1:no
         r=(u-d)/2;
         b=d+r;
         if x < exp(1)
%
%           Find root using w*exp(w)-x to avoid log(0) error.
%
            f=b*exp(b)-x;
            fd=d*exp(d)-x;
         else
%
%           Find root using log(w/x)+w to avoid overflow error.
%
            f=log(b/x)+b;
            fd=log(d/x)+d;
         end
         if f == 0 | abs(r) <= tol
            return
         end
         if fd*f > 0
            d=b;
         else
            u=b;
         end
      end
   end
else
   d=crude(x,nb)-1e-3;
   u=min(d+2e-3,-1);
   tol=abs(u)/2^nbits;
   for i=1:no
      r=(u-d)/2;
      b=d+r;
      f=b*exp(b)-x;
      if f == 0 | abs(r) <= tol
         return
      end
      fd=d*exp(d)-x;
      if fd*f > 0
         d=b;
      else
         u=b;
      end
   end
end
ner=1;