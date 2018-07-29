function integ_cplx=integrtr(rt,w,T,flag)
%
% Utility function: INTEGRTR
%
% The purpose of this function is to compute the bode of continuous
% integrator(s)/differentiator(s) or discrete delay(s)/predictor(s)

% Author: Craig Borghesani
% Date: 8/8/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

integ_cplx=ones(1,length(w));

if nargin==3,
 if ~length(T), % continuous integrator(s)/differentiator(s)
  s=sqrt(-1)*w(:)';

% avoid 'Divide by zero' error
  zero=find(s==0);
  if length(zero),
   s(zero)=ones(1,length(zero))*eps;
  end
  integ_cplx=(1 ./(s.^rt));

 else   % discrete delay(s)/predictor(s)
  z=exp(sqrt(-1)*w(:)'*T);
  zero=find(z==0);
  if length(zero),
   z(zero)=ones(1,length(zero))*eps;
  end
  for n=1:abs(rt),
   if rt<0,
    integ_cplx=integ_cplx.*z;
   else
    integ_cplx=integ_cplx./z;
   end
  end
 end
else % discrete integrators/differentiators
 z=exp(sqrt(-1)*w(:)'*T);
 if rt==1,
  integ_cplx=(z./(z-1)).^(-flag);
 elseif rt==2,
  integ_cplx=(T*z./(z-1).^2).^(-flag);
 elseif rt==3,
  integ_cplx=((T^2*z.*(z+1))./(2*(z-1).^3)).^(-flag);
 end
end