function [num,den] = termextr(term_mat,T)
%
% Utility function: TERMEXTR
%
% The purpose of this function is to extract the terms out of the
% term matrix created within the controls tutor

% Author: Craig Borghesani
% Date: 8/17/94
% Revised: 10/27/94
% Copyright (c) 1999, Prentice-Hall

if all(size(term_mat)==[1,4]), % pid controller
 if term_mat(4) == 40, term_mat = pid2pid(term_mat,1); end
 term_mat = termpars(term_mat([3,1,2]),[1,0]);
end

% Convert Lead/Lag terms into pole and zero terms
term_mat = termcnvt(term_mat);

num=1;nc=0;den=1;dc=0;
if nargin==1,
 for p=2:length(term_mat(:,1)),
  if term_mat(p,4)==4,
   den=conv(den,[1 term_mat(p,1)]);
  elseif term_mat(p,4)==5,
   num=conv(num,[1 term_mat(p,1)]);
  elseif term_mat(p,4)==6,
   den=conv(den,[1 2*term_mat(p,1)*term_mat(p,2) term_mat(p,2)^2]);
  elseif term_mat(p,4)==7,
   num=conv(num,[1 2*term_mat(p,1)*term_mat(p,2) term_mat(p,2)^2]);
  end
 end
else
 for p=2:lc,
  if term_mat(p,4)==2,
   pz=real(exp(-term_mat(p,1)*T));
   den=conv(den,[1 -pz]); nc=nc+1;
  elseif term_mat(p,4)==3,
   zz=real(exp(-term_mat(p,1)*T));
   num=conv(num,[1 -zz]); dc=dc+1;
  elseif term_mat(p,4)==4,
   a=term_mat(p,1)*term_mat(p,2);
   b=term_mat(p,2)*sqrt(1-term_mat(p,1)^2);
   den=conv(den,[1 -2*exp(-a*T(1))*cos(b*T(1)) exp(-2*a*T(1))]);
   nc=nc+1;
  elseif term_mat(p,4)==5,
   a=term_mat(p,1)*term_mat(p,2);
   b=term_mat(p,2)*sqrt(1-term_mat(p,1)^2);
   num=conv(num,[1 -2*exp(-a*T(1))*cos(b*T(1)) exp(-2*a*T(1))]);
   dc=dc+1;
  elseif term_mat(p,4)==7,
   if term_mat(p,1)==1, den=conv(den,[1 -1]); nc=nc+1;
   elseif term_mat(p,1)==2, den=conv(den,[1 -2 1]); nc=nc+1;
   elseif term_mat(p,1)==3, den=conv(den,[1 -3 3 -1]); num=conv(num,[1 1]);nc=nc+1; end
   if term_mat(p,2)==1, num=conv(num,[1 -1]); dc=dc+1;
   elseif term_mat(p,2)==2, num=conv(num,[1 -2 1]); dc=dc+1;
   elseif term_mat(p,2)==3, num=conv(num,[1 -3 3 -1]); den=conv(den,[1 1]);dc=dc+1; end
  end
 end
end

if nargin==2,
 t=nc-dc-term_mat(3,1);
 if t>0, num=conv(num,[1 zeros(1,t)]);
 elseif t<0, den=conv(den,[1 zeros(1,-t)]); end
else
 if term_mat(2,1)>0, den=conv(den,[1 zeros(1,term_mat(2,1))]);
 else num=conv(num,[1 zeros(1,abs(term_mat(2,1)))]); end
end
num = num*term_mat(1,1);