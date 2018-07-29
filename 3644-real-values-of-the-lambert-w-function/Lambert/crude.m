% Crude approximations for the W function (used by bisect)
%
% Syntax:
% crude(xx,nb)
%
% xx is the argument, W(xx)
%
% nb is the branch of the W function needed:
% nb = 0 - upper branch, Wp
% nb <> 0 - lower branch, Wm
%
function c=crude(xx,nb)
%
% D. A. Barry, 23 June 2003 (d.a.barry@ed.ac.uk)
%
% Various constants
%
em=-exp(-1);
em9=-exp(-9);
c13=1/3;
em2=2/em;
s2=sqrt(2);
s21=2*s2-3;
s22=4-3*s2;
s23=s2-2;
if nb == 0
%
%  Calculations for crude Wp
%
   if xx <= 20
      reta=s2*sqrt(1-xx/em);
      an2=4.612634277343749*sqrt(sqrt(reta+1.09556884765625));
      c=reta/(1+reta/(3+(s21*an2+s22)*reta/(s23*(an2+reta))))-1;
   else
      zl=log(xx);
      c=log(xx/log(xx/zl^exp(-1.124491989777808/(.4225028202459761+zl))));
   end
else
%
%  Calculations for crude Wm
%
   if xx <= em9
      zl=log(-xx);
      t=-1-zl;
      ts=sqrt(t);
      c=zl-(2*ts)/(s2+(c13-t/(270+ts*127.0471381349219))*ts);
   else
      zl=log(-xx);
      eta=2-em2*xx;
      c=log(xx/log(-xx/((1-.5043921323068457*(zl+1))*(sqrt(eta)+eta/3)+1)));
   end
end