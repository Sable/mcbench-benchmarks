function [z,p,k]=term2zpk(term_mat,T)
% TERM2ZPK Term matrix to zero/pole/gain format.
%          TERM2ZPK converts the terms matrix into a zero/pole/gain format

% Author: Craig Borghesani
% Date: 9/5/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

len = length(term_mat(:,1));
if len == 1, % pid controller
 term_mat = termpars(term_mat([3,1,2]),[1,0]);
end

narg_vals = nargin;
if narg_vals==2,
 if ~length(T),
  narg_vals=1;
 end
end

z=[]; p=[];
if narg_vals==1,
 term_mat=termcnvt(term_mat);
 k=term_mat(1,1);
 for v=1:length(term_mat(:,1)),
  if term_mat(v,4)==2,
   if term_mat(v,1)>0,
    p=[p;zeros(term_mat(v,1),1)];
   elseif term_mat(v,1)<0,
    z=[z;zeros(-term_mat(v,1),1)];
   end
  elseif term_mat(v,4)==4,
   p=[p;-term_mat(v,1)];
  elseif term_mat(v,4)==5,
   z=[z;-term_mat(v,1)];
  elseif term_mat(v,4)==6,
   p=[p;roots([1,2*term_mat(v,1)*term_mat(v,2),term_mat(v,2)^2])];
  elseif term_mat(v,4)==7,
   z=[z;roots([1,2*term_mat(v,1)*term_mat(v,2),term_mat(v,2)^2])];
  end
 end
else
 nc=0; dc=0;
 k=term_mat(1,1);
 term_mat=termcnvt(term_mat,T);
 for v=1:length(term_mat(:,1)),
  if term_mat(v,4)==0.5,
   p=[p;ones(term_mat(v,1),1)];
   if term_mat(v,1)==3, z=[z;-1]; end
   z=[z;ones(term_mat(v,2),1)];
   if term_mat(v,2)==3, p=[p;-1]; end
   if term_mat(v,1)>0, nc=nc+1; end
   if term_mat(v,2)>0, dc=dc+1; end
  elseif term_mat(v,4)==0.6,
   if term_mat(v,4)>0,
    p=[p;zeros(term_mat(v,1),1)];
   else
    z=[z;zeros(-term_mat(v,1),1)];
   end
  elseif term_mat(v,4)==1,
   k=k*(1-real(exp(-term_mat(v,1)*T)));
   p=[p;real(exp(-term_mat(v,1)*T))];
   nc=nc+1;
  elseif term_mat(v,4)==2,
   k=k/(1-real(exp(-term_mat(v,1)*T)));
   z=[z;real(exp(-term_mat(v,1)*T))];
   dc=dc+1;
  elseif term_mat(v,4)==3,
   a=term_mat(v,1)*term_mat(v,2);
   b=term_mat(v,2)*sqrt(1-term_mat(v,1)^2);
   k=k*(1-2*exp(-a*T(1))*cos(b*T(1))+exp(-2*a*T(1)));
   p=[p;roots([1 -2*exp(-a*T(1))*cos(b*T(1)) exp(-2*a*T(1))])];
   nc=nc+1;
  elseif term_mat(v,4)==4,
   a=term_mat(v,1)*term_mat(v,2);
   b=term_mat(v,2)*sqrt(1-term_mat(v,1)^2);
   k=k/(1-2*exp(-a*T(1))*cos(b*T(1))+exp(-2*a*T(1)));
   z=[z;roots([1 -2*exp(-a*T(1))*cos(b*T(1)) exp(-2*a*T(1))])];
   dc=dc+1;
  end
 end
 if (nc-dc)>0,
  z=[z;zeros(nc-dc,1)];
 else
  p=[p;zeros(dc-nc,1)];
 end
end