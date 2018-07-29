function term_cplx=termcplx(term_mat,w,T)
%
% Utility function: TERMCPLX
%
% The purpose of this function is take the term matrix and compute
% the complex number response

% Author: Craig Borghesani
% Date: 8/8/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

narg_vals = nargin;
if narg_vals==3,
 if ~length(T),
  narg_vals=2;
 end
end

[r,c]=size(term_mat);
if r == 1,
 if any(term_mat(4)==[20,40]),
  if term_mat(4) == 40, term_mat = pid2pid(term_mat,1); end
  term_mat = termpars(term_mat([3,1,2]),[1,0]);
 end
end

[r,c]=size(term_mat);
term_cplx=ones(1,length(w));
for k=1:r,
 if narg_vals==2,
  if term_mat(k,4)==1,
   cplx = term_mat(1,1)*exp(-i*w*term_mat(1,2));
  elseif (term_mat(k,4)==2 & term_mat(k,1)~=0),
   cplx=integrtr(term_mat(k,1),w,[]);
  elseif (term_mat(k,4)==4 | term_mat(k,4)==5),
   cplx=realpole(term_mat(k,1),w,(term_mat(k,4)==5)-(term_mat(k,4)==4));
  elseif (term_mat(k,4)==6 | term_mat(k,4)==7),
   cplx=cplxpole(term_mat(k,1),term_mat(k,2),w,(term_mat(k,4)==7)-(term_mat(k,4)==6));
  elseif term_mat(k,4)==8,
   cplx=leadlag(term_mat(k,1),term_mat(k,2),w);
  else cplx=1; end
 else
  if term_mat(k,4)==1,
   cplx=term_mat(1,1);
  elseif (term_mat(k,4)==2 | term_mat(k,4)==3),
   cplx=realpole(term_mat(k,1),w,[(term_mat(k,4)==3)-(term_mat(k,4)==2) T]);
  elseif (term_mat(k,4)==4 | term_mat(k,4)==5),
   cplx=cplxpole(term_mat(k,1),term_mat(k,2),w,[(term_mat(k,4)==5)-(term_mat(k,4)==4) T]);
  elseif term_mat(k,4)==6,
   cplx=leadlag(term_mat(k,1),term_mat(k,2),w,T);
  elseif (term_mat(k,4)==7 & term_mat(k,1)~=0),
   cplx=integrtr(term_mat(k,1),w,T);
  elseif (term_mat(k,4)==8 & term_mat(k,1)~=term_mat(k,2)),
   ca=1; cb=1;
   if term_mat(k,1)~=0, ca=integrtr(term_mat(k,1),w,T,-1); end
   if term_mat(k,2)~=0, cb=integrtr(term_mat(k,2),w,T,1); end
   cplx=ca.*cb;
  end
 end
 term_cplx = term_cplx.*cplx;
end