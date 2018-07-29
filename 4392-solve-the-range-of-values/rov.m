%The field of definition of the quadratic function
%have been known,
%solve the range of values.
%rov(a,b,c,x1,x2),(x1<x2)
function rov(a,b,c,x1,x2)
a=sym(a);b=sym(b);c=sym(c);x1=sym(x1);x2=sym(x2);
dd=simple((-b)/(2*a));jj=simple((4*a*c-b^2)/(4*a));
fx1=simple(a*(x1^2)+b*x1+c);fx2=simple(a*(x2^2)+b*x2+c);
if double(a)>0
   if double(x2)<=double(dd)
      fmax=fx1
      fmin=fx2
   elseif double(x1)>=double(dd)
      fmax=fx2
      fmin=fx1
   elseif double(x1)<double(dd)&double(x2)>double(dd)
      fmax=big(fx1,fx2)
      fmin=jj
   end
else
   if double(x2)<=double(dd)
      fmax=fx2
      fmin=fx1
   elseif double(x1)>=double(dd)
      fmax=fx1
      fmin=fx2
   elseif double(x1)<double(dd)&double(x2)>double(dd)
      fmax=jj
      fmin=small(fx1,fx2)
   end
end

      
         