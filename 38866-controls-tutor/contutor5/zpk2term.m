function term_mat = zpk2term(z,p,k,T)
%
% Utility Function: ZPK2TERM
%
% The purpose of this function is to convert zero/pole/gain format into
% the term matrix format used by the environments

% Author: Craig Borghesani
% Date: 9/5/94
% Copyright (c) 1999, Prentice-Hall

narg_vals = nargin;
if narg_vals==4,
 if ~length(T),
  narg_vals=3;
 end
end

ctz=length(z);
ctp=length(p);
ct=1;
term_mat(1,:) = [k,0,NaN,1];
term_mat(2,:) = [0,NaN,NaN,2];

if narg_vals==3,
 while ct<=ctz,
  if z(ct)==0,
   term_mat(2,1)=term_mat(2,1)-1;
   ct=ct+1;
  elseif imag(z(ct))==0,
   term_mat=[term_mat;-z(ct),NaN,NaN,5];
   ct=ct+1;
  else
   re=real(z(ct)); im=imag(z(ct));
   wn=sqrt(re^2+im^2); zta=-re/wn;
   term_mat=[term_mat;zta wn NaN 7];
   ct=ct+2;
  end
 end
 ct=1;
 while ct<=ctp,
  if p(ct)==0,
   term_mat(2,1)=term_mat(2,1)+1;
   ct=ct+1;
  elseif imag(p(ct))==0,
   term_mat=[term_mat;-p(ct),NaN,NaN,4];
   ct=ct+1;
  else
   re=real(p(ct)); im=imag(p(ct));
   wn=sqrt(re^2+im^2); zta=-re/wn;
   term_mat=[term_mat;zta wn NaN 6];
   ct=ct+2;
  end
 end
else
 while ct<=ctz,
  if z(ct)==0,
   term_mat(3,1)=term_mat(3,1)-1;
   ct=ct+1;
  elseif imag(z(ct))==0,
   if z(ct)==1,
    term_mat(2,2)=term_mat(2,2)+1;
   else
    term_mat=[term_mat;exp(-z(ct)*T),NaN,NaN,2];
   end
   ct=ct+1;
  else
   z(ct)=log(z(ct))/T;
   re=real(z(ct)); im=imag(z(ct));
   wn=sqrt(re^2+im^2); zta=-re/wn;
   term_mat=[term_mat;zta wn NaN 4];
   ct=ct+2;
  end
 end
 ct=1;
 while ct<=ctp,
  if p(ct)==0,
   term_mat(3,1)=term_mat(3,1)+1;
   ct=ct+1;
  elseif imag(p(ct))==0,
   if p(ct)==1,
    term_mat(2,1)=term_mat(2,1)+1;
   else
    term_mat=[term_mat;exp(-p(ct)*T),NaN,NaN,1];
   end
   ct=ct+1;
  else
   p(ct)=log(p(ct))/T;
   re=real(p(ct)); im=imag(p(ct));
   wn=sqrt(re^2+im^2); zta=-re/wn;
   term_mat=[term_mat;zta wn NaN 3];
   ct=ct+2;
  end
 end
end