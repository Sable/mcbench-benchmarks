function term_mat = termcnvt(term_mat,T)
%
% Utility function: TERMCNVT
%
% The purpose of this function is to take the Lead/Lag terms, which are
% stored in phase and w and convert them into poles and zeros

% Author: Craig Borghesani
% Date: 8/17/94
% Copyright (c) 1999, Prentice-Hall

terms=[];
loc=find(term_mat(:,4)==8);
for k=loc(:)',
 phi=term_mat(k,1); wd=term_mat(k,2);
 if nargin==1,
  alpha=(1-sin(abs(phi*pi/180)))/(1+sin(abs(phi*pi/180)));
  a=wd*sqrt(alpha); b=wd/sqrt(alpha);
  if sign(phi)<0, terms=[terms;a,NaN,NaN,4]; terms=[terms;b,NaN,NaN,5];
  else terms=[terms;b,NaN,NaN,4]; terms=[terms;a,NaN,NaN,5]; end
 else
  x=cos(wd*T)+sin(phi*pi/180); y=sin(phi*pi/180)*cos(wd*T)+1;
  a=-(-y+sqrt(y^2-x^2))/x;
  b=-((sin(phi*pi/180)-a)/(-a*sin(phi*pi/180)+1));
  ac=-log(a)/T;
  bc=-log(b)/T;
  terms=[terms;ac,NaN,NaN,3]; terms=[terms;bc,NaN,NaN,2];
 end
end
term_mat(loc,:)=[];
term_mat=[term_mat; terms];
