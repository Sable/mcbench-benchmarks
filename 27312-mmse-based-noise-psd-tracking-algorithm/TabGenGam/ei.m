function y=ei(x)

% ei - is an exponential integral
% ================================
% Usage:
%       y=ei(x)
% 
% Defined by :
%                inf
%  E1(x)=-Ei(-x)= S exp(-t)/t dt
%                 x

if min(x)>0,
      x=(x<20).*x+(x>=20).*20;
      az=1;
      s=0;
      for i=1:100,
          az=az*i;
          s=s+((-x).^i)/(i*az);
      end;
      s=-(0.577215+log(x)+s);
      y=sign(20-x).*(sign(20-x)+1).*s/2;
   else 
   the_value_cannot_be_zero_or_negative
end;
