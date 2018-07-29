function term_mat = termpars(num,den,T)
%
% Utility function: TERMPARS
%
% The purpose of this function is to take a transfer function and determine
% the real and complex poles and real and complex zeros.

% Author: Craig Borghesani
% Date: 8/17/94
% Copyright (c) 1999, Prentice-Hall

narg_vals = nargin;
if narg_vals==3,
 if ~length(T),
  narg_vals=2;
 end
end

% seperate numerator and denominator into real and complex zeros and poles
num_rts=roots(num);
den_rts=roots(den);

q=1;
% initialize element matrix
if narg_vals==2,
 n=find(num~=0); d=find(den~=0);
 if ~length(n) | (~length(d)), error('Num or Den cannot be zero'); end
 term_mat(1,1:4)=[num(n(1))/den(d(1)) 0 NaN 1];
 term_mat(2,1:4)=[0 NaN NaN 2]; c=2;
else
 term_mat(1,1:4)=[1 0 NaN 1];
 term_mat(2,1:4)=[0 0 NaN 2];
 term_mat(3,1:4)=[0 NaN NaN 8]; c=3;
end

% separate and store poles and zeros
nsum=1;dsum=1;
while q<=length(num_rts),
 num_rts(q) = str2num(sprintf('%0.4f',real(num_rts(q))))+...
              str2num(sprintf('%0.4f',imag(num_rts(q))))*i;
 c=c+1;
 if imag(num_rts(q))==0,
  if narg_vals==3 & abs(num_rts(q)-1)>1e-10,
   nsum=nsum*(1-num_rts(q));
   if num_rts(q)~=0,
    num_rts(q)=log(num_rts(q))/T;
   end
  end
  term_mat(c,1:4)=[-num_rts(q) NaN NaN 5];
  q=q+1;
 else
  if narg_vals==3,
   num_rts(q)=log(num_rts(q))/T;
  end
  re=real(num_rts(q)); im=imag(num_rts(q));
  wn=sqrt(re^2+im^2); zta=-re/wn;
  term_mat(c,1:4)=[zta wn NaN 7]; q=q+2;
  if narg_vals==3,
   a=zta*wn; b=wn*sqrt(1-zta^2);
   nsum=nsum*(1-2*exp(-a*T)*cos(b*T)+exp(-2*a*T));
  end
 end
end

q=1;
while q<=length(den_rts),
 den_rts(q) = str2num(sprintf('%0.4f',real(den_rts(q))))+...
              str2num(sprintf('%0.4f',imag(den_rts(q))))*i;
 c=c+1;
 if imag(den_rts(q))==0,
  if narg_vals==3 & abs(den_rts(q)-1)>1e-10,
   dsum=dsum*(1-den_rts(q));
   if den_rts(q)~=0,
    den_rts(q)=log(den_rts(q))/T;
   end
  end
  term_mat(c,1:4)=[-den_rts(q) NaN NaN 4];
  q=q+1;
 else
  if narg_vals==3,
   den_rts(q)=log(den_rts(q))/T;
  end
  re=real(den_rts(q)); im=imag(den_rts(q));
  wn=sqrt(re^2+im^2); zta=-re/wn;
  term_mat(c,1:4)=[zta wn NaN 6]; q=q+2;
  if narg_vals==3,
   a=zta*wn; b=wn*sqrt(1-zta^2);
   dsum=dsum*(1-2*exp(-a*T)*cos(b*T)+exp(-2*a*T));
  end
 end
end

% if discrete, determine the number of integrators
if narg_vals==3,
 delays=0; preds=0;
 y=find(abs(1+term_mat(:,1))<1e-10 & term_mat(:,4)==2); term_mat(y,:)=[];
 x=find(term_mat(:,1)==0 & term_mat(:,4)==3);
 yl=length(y);
 if yl,
  if length(x), term_mat(x(1),:)=[];
  else delays=delays+1; end
  if yl==3,
   x=find(-term_mat(:,1)==-1 & term_mat(:,4)==3);
   if length(x), term_mat(x,:)=[];
   else term_mat=[term_mat; -1 NaN NaN 2]; end
  elseif yl>3,
   error('Cannot have more than 3 integrators');
  end
 end
 yy=find(abs(1+term_mat(:,1))<1e-10 & term_mat(:,4)==3); term_mat(yy,:)=[];
 x=find(term_mat(:,1)==0 & term_mat(:,4)==2);
 yyl=length(yy);
 if yyl,
  if length(x), term_mat(x(1),:)=[];
  else preds=preds+1; end
  if yyl==3,
   x=find(term_mat(:,1)==-1 & term_mat(:,4)==2);
   if length(x), term_mat(x,:)=[];
   else term_mat=[term_mat; -1 NaN NaN 3]; end
  elseif yyl>3,
   error('Cannot have more than 3 differentiators');
  end
 end
 yd=find(term_mat(:,1)~=0 & term_mat(:,4)==2);
 x=find(term_mat(:,1)==0 & term_mat(:,4)==3);
 if length(x)>=length(yd), term_mat(x(1:length(yd)),:)=[];
 elseif length(x)<length(yd),
  delays=length(yd)-length(x)+delays;
  term_mat(x,:)=[];
 end
 yn=find(term_mat(:,1)~=0 & term_mat(:,4)==3);
 x=find(term_mat(:,1)==0 & term_mat(:,4)==2);
 if length(x)>=length(yn), term_mat(x(1:length(yn)),:)=[];
 elseif length(x)<length(yn),
  preds=length(yn)-length(x)+preds;
  term_mat(x,:)=[];
 end
 yd=find(term_mat(:,2)~=NaN & term_mat(:,4)==4);
 x=find(term_mat(:,1)==0 & term_mat(:,4)==3);
 if length(x)>=length(yd), term_mat(x(1:length(yd)),:)=[];
 elseif length(x)<length(yd),
  delays=length(yd)-length(x)+delays;
  term_mat(x,:)=[];
 end
 yn=find(term_mat(:,2)~=NaN & term_mat(:,4)==5);
 x=find(term_mat(:,1)==0 & term_mat(:,4)==2);
 if length(x)>=length(yn), term_mat(x(1:length(yn)),:)=[];
 elseif length(x)<length(yn),
  preds=length(yn)-length(x)+preds;
  term_mat(x,:)=[];
 end
 x=find(term_mat(:,1)==0 & term_mat(:,4)==3);
 xxl=length(x)+preds;
 term_mat(x,:)=[];
 x=find(term_mat(:,1)==0 & term_mat(:,4)==2);
 term_mat(x,:)=[];
 xl=length(x)+delays;
 term_mat(2,1)=yl; term_mat(2,2)=yyl;
 term_mat(3,1)=xl-xxl;
 n=find(num~=0); d=find(den~=0);
 term_mat(1,1)=dsum/nsum*den(d(1))/num(n(1));

elseif narg_vals==2,  % Continuous

 xl=find(term_mat(:,1)==0 & term_mat(:,4)==5); term_mat(xl,:)=[];
 xll=find(term_mat(:,1)==0 & term_mat(:,4)==4); term_mat(xll,:)=[];
 term_mat(2,1)=length(xll)-length(xl);

end